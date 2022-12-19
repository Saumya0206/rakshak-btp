// // #include <HardwareSerial.h>
// #include <SoftwareSerial.h>

// void setup()
// {
//     Serial.begin(9600);
//     // while (!Serial)
//     ;
// }

// void loop()
// {
//     // if (Serial.available())
//     // {
//     // String inputString = Serial.readString();
//     Serial.println("inputString");
//     // }
// }

/*
Hardware Connections (MAX30102 to Arduino):
  -5V = 5V (3.3V is allowed)
  -GND = GND
  -SDA = A4 (or SDA)
  -SCL = A5 (or SCL)
*/

#include <SoftwareSerial.h>
#include <Wire.h>
#include "MAX30105.h"
#include "spo2_algorithm.h" // TODO: Package the algorithm in mobile app as native cpp code
// Data transmission constants
#define FLAG_BYTE 0x7E
#define FLAG_AVOID_BYTE 0x6E

MAX30105 particleSensor;
// Calibration
#define PULSE_MULTI 0.4

#define MAX_BRIGHTNESS 255
#define ledBrightness 60  // Options: 0=Off to 255=50mA
#define sampleAverage 4   // Options: 1, 2, 4, 8, 16, 32
#define sampleAverageBP 1 // Options: 1, 2, 4, 8, 16, 32
#define ledMode 2         // Options: 1 = Red only, 2 = Red + IR, 3 = Red + IR + Green
#define sampleRate 100    // Options: 50, 100, 200, 400, 800, 1000, 1600, 3200
#define sampleRateBP 50   // Options: 50, 100, 200, 400, 800, 1000, 1600, 3200
#define pulseWidth 411    // Options: 69, 118, 215, 411
#define adcRange 4096     // Options: 2048, 4096, 8192, 16384

#define bufferLength 25 // buffer length of 100 stores 4 seconds of samples running at 25sps
// changed 16 -> 32
uint16_t irBuffer[bufferLength];  // infrared LED sensor data
uint16_t redBuffer[bufferLength]; // red LED sensor data

int32_t spo2;          // SPO2 value
int8_t validSPO2;      // indicator to show if the SPO2 calculation is valid
int32_t heartRate;     // heart rate value
int8_t validHeartRate; // indicator to show if the heart rate calculation is valid
float temper = 0;

SoftwareSerial bluetooth(10, 11); // RX | TX (Current module needs these swapped)
#define OFF 0
#define PULSE_OXY_TEMPER 1
#define BP 2
byte function = OFF;

void setup()
{
    Serial.begin(9600);
    bluetooth.begin(9600);
    // Serial.println("Device started");

    // Initialize sensor
    while (!particleSensor.begin(Wire, I2C_SPEED_FAST)) // Use default I2C port, 400kHz speed
    {
        // Serial.println(F("Sensor missing."));
        delay(1000);
    }
    Serial.println(F("Sensor available."));

    particleSensor.setup();                    // Configure sensor with default settings
    particleSensor.setPulseAmplitudeRed(0x0A); // Turn Red LED to low to indicate sensor is running
    particleSensor.setPulseAmplitudeGreen(0);  // Turn off Green LED
}

void loop()
{
    // bluetooth.println("what");
    // if (bluetooth.available())
    // {
    //     Serial.println("available");
    // }
    // else
    // {
    //     Serial.println("not available");
    // }
    // Serial.println(bluetooth.available());
    // Await the command to transmit
    if (bluetooth.available())
    {
        String command = bluetooth.readString();
        Serial.println(command);
        Serial.println(command == "S");
        if (command == "B")
        {
            function = BP;
            particleSensor.setup(ledBrightness, sampleAverageBP, ledMode, sampleRateBP, pulseWidth, adcRange);
            bluetooth.println('B');
        }
        else if (command == "S")
        {
            Serial.println("1");
            function = PULSE_OXY_TEMPER;
            particleSensor.setup(ledBrightness, sampleAverage, ledMode, sampleRate, pulseWidth, adcRange);
            particleSensor.enableDIETEMPRDY(); // Enable the temp ready interrupt. This is required for temperature.
            bluetooth.println('S');
        }
        else
        {
            function = OFF;
            particleSensor.disableDIETEMPRDY();
        }
    }

    if (function == BP)
    {
        transmitRawData();
    }
    else if (function == PULSE_OXY_TEMPER)
    {
        transmitCalculatedData();
    }
}

void transmitCalculatedData()
{
    // read the first 100 samples, and determine the signal range
    Serial.println(particleSensor.available());
    Serial.println(particleSensor.getRed());
    for (byte i = 0; i < bufferLength; i++)
    {
        while (particleSensor.available() == false)
            particleSensor.check();

        redBuffer[i] = particleSensor.getRed();
        irBuffer[i] = particleSensor.getIR();
        particleSensor.nextSample();
    }
    // calculate heart rate and SpO2 after first 100 samples (first 4 seconds of samples)
    Serial.println("step1"); // debug statement
    maxim_heart_rate_and_oxygen_saturation(irBuffer, bufferLength, redBuffer, &spo2, &validSPO2, &heartRate, &validHeartRate);
    if (validSPO2 == 1 && validHeartRate == 1)
    {
        temper = (float)particleSensor.readTemperature();
        temper = ((int)(temper * 100)) / 100.0;
    }
    Serial.println("step2"); // debug statement;
    sendFormattedFrame(validSPO2 & validHeartRate);

    // Continuously taking samples.  Heart rate and SpO2 are calculated every 1 second
    while (!bluetooth.available())
    {
        // dumping the first 25 sets of samples in the memory and shift the last 75 sets of samples to the top
        for (byte i = 25; i < bufferLength; i++)
        {
            redBuffer[i - 25] = redBuffer[i];
            irBuffer[i - 25] = irBuffer[i];
        }

        // take 25 sets of samples before calculating the heart rate.
        for (byte i = bufferLength - 25; i < bufferLength; i++)
        {
            while (particleSensor.available() == false)
                particleSensor.check();

            redBuffer[i] = particleSensor.getRed();
            irBuffer[i] = particleSensor.getIR();
            particleSensor.nextSample();
        }
        // After gathering 25 new samples recalculate HR and SP02
        maxim_heart_rate_and_oxygen_saturation(irBuffer, bufferLength, redBuffer, &spo2, &validSPO2, &heartRate, &validHeartRate);
        if (validSPO2 == 1 && validHeartRate == 1)
        {
            temper = (float)particleSensor.readTemperature();
            temper = ((int)(temper * 100)) / 100.0;
        }
        sendFormattedFrame(validSPO2 & validHeartRate);
    }
}

int sendFormattedFrame(byte valid)
{
    // Serial.println("step3"); // debug statement;
    char data[14];
    if (valid)
    {
        Serial.println("step4"); // debug statement;
        sprintf(data, "^%d|%d|%d$", (int)(temper * 10), (int)(heartRate * PULSE_MULTI), spo2);
    }
    else
    {
        sprintf(data, "^0|0|0$");
    }
    Serial.println(data); // debug statement
    bluetooth.print(data);
    bluetooth.print(data);
}

void transmitRawData()
{
    uint16_t ir, red, timestamp = 0;

    while (!bluetooth.available())
    {
        while (particleSensor.available() == false)
            particleSensor.check();

        red = particleSensor.getRed();
        ir = particleSensor.getIR();
        timestamp++;

        // Serial.println(ir);
        sendRawFrame(timestamp, ir);
        particleSensor.nextSample();
    }
}

void intToBytes(uint16_t x, byte result[])
{
    result[0] = (byte)((x >> 8) & 0xFF); // Higher
    result[1] = (byte)(x & 0xFF);
}

void sendRawFrame(uint16_t timestamp, uint16_t ir)
{
    byte bytes[2][2];
    byte flagBytesInFrame = 0; // To track which data bytes had same value as flag byte. Should only track max 6 bytes at a time.
    bluetooth.write(FLAG_BYTE);

    intToBytes(timestamp, bytes[0]);
    if (bytes[0][0] == FLAG_BYTE)
    {
        flagBytesInFrame = flagBytesInFrame | 0x8;
        bluetooth.write(FLAG_AVOID_BYTE);
    }
    else
    {
        bluetooth.write(bytes[0][0]);
    }
    if (bytes[0][1] == FLAG_BYTE)
    {
        flagBytesInFrame = flagBytesInFrame | 0x4;
        bluetooth.write(FLAG_AVOID_BYTE);
    }
    else
    {
        bluetooth.write(bytes[0][1]);
    }

    intToBytes(ir, bytes[1]);
    if (bytes[1][0] == FLAG_BYTE)
    {
        flagBytesInFrame = flagBytesInFrame | 0x2;
        bluetooth.write(FLAG_AVOID_BYTE);
    }
    else
    {
        bluetooth.write(bytes[1][0]);
    }
    if (bytes[1][1] == FLAG_BYTE)
    {
        flagBytesInFrame = flagBytesInFrame | 0x1;
        bluetooth.write(FLAG_AVOID_BYTE);
    }
    else
    {
        bluetooth.write(bytes[1][1]);
    }

    bluetooth.write(flagBytesInFrame);
    bluetooth.write(FLAG_BYTE);
}