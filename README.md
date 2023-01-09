# Distributed Analytics over Mobile Devices: RAKSHAK

This repository contains the code for the Rakshak App developed by : [Soumya Vaish & Shivam Kumar](https://github.com/slowdivesun/rakshak-btp) under the Btech Project. 

This is a Application developed using Flutter which helps to take measurements for human vitals and upload them for doctors to analyse as per convenience.


# Description ✌
This a mobile App that can take measurements for human vitals and upload them for doctors to analyze as per convenience. The portal measures the pulse rate, the oxygen level, the skin temperature and the heartbeat of the human body. 
These data are collected and are uploaded to the Firebase server where it can be fetched and read by the doctor for more analysis. These data are read using the hardware devices and sensors which are connected to the app. 

# TechStack 👩🏻‍💻
* Flutter & Dart because:
-Sparkfun Library
-Firebase Auth + Firebase Core
-Bluetooth Serial


# Development Tools used 🛠
* Android Studio for App
* For hardware part:
- Tele stethoscope for measuring heartbeat
- An HC-05 bluetooth module for establishing connection
- Sensor for measurement of HR, oxygen and temperature

# Features 📃
* Login / Register
* Connect to the device
* Record vitals using the sensor
* Upload them
* Connect tele-stethoscope
* Record audio
* Upload it

# Architecture 📐
* Global state has been used for only logged in user
* Local state has been used for blutooth connection & sensor output
* O2 page & Read Sensor Data page are tightly packed
* Cloud firestore was chosen among Realtime & cloud firestore for the firebase because:
- Collection-document structure
- Multi-region support


# What's in the code ? 💻
This code consists of three parts :
* Login/Register page
* Home page which instructs to use the app
* The tele stethoscope page
* The record human vitals page
* Bluetooth connection page

# How to use the website ? 😵
Link to demo & presentation: [Demo](https://docs.google.com/presentation/d/14SSebqDolUuIhiUERzsAAddhA5DYN4JQ9cAkyGowhZ8/edit?usp=sharing)

# Demo 🪧

https://user-images.githubusercontent.com/60199756/211395486-2bc967e6-8551-45dc-bdea-8e3e56a1635a.mp4


https://user-images.githubusercontent.com/60199756/211395658-de9555ee-8a85-45d9-9339-fbe796ee0f9a.mp4




