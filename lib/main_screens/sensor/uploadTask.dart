import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference satReading =
    FirebaseFirestore.instance.collection('saturation');

class uploadTask {
  Future<void> addStudent(name, number, value) {
    // EasyLoading.show(status: 'loading...');
    return satReading
        .add({
          'name': name,
          'number': number,
          'timestamp': Timestamp.now(),
          'value': value
        })
        .then((value) => print("Reading uploaded"))
        .catchError((error) => print("Error. Could not upload."));
  }
}
