import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rakshak/main_screens/HomePage.dart';
import 'package:rakshak/main_screens/Measurement.dart';

// ignore: must_be_immutable
class GoogleDone extends StatelessWidget {
  GoogleSignIn? _googleSignIn;

  User? _user;

  GoogleDone(User user, GoogleSignIn signIn) {
    _user = user;
    _googleSignIn = signIn;

    print(_user);
    print(_googleSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              // new code: changed photoUrl to photoURL
              child: Image.network(
                _user?.photoURL ?? "",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              // OLD code
              //   _user.photoURL != null
              //       ? Image.network(
              //           _user.photoURL,
              //           width: 100,
              //           height: 100,
              //           fit: BoxFit.cover,
              //         )
              //       : Image.network(
              //           'https://lh3.googleusercontent.com/6UgEjh8Xuts4nwdWzTnWH8QtLuHqRMUB7dp24JYVE2xcYzq4HA8hFfcAbU-R-PC_9uA1',
              //           width: 100,
              //           height: 100,
              //           fit: BoxFit.cover,
              //         ),
            ),
            Text(
                // new code: added ?? "Anon"
                _user?.displayName ?? "Anon",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            TextButton(
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                // Navigate to the homepage on press
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Measurement()));

                // don't sign out on press
                // _googleSignIn?.signOut();
                // Navigator.pop(context);
              },
              child: Text('Google sign in Done!'),
            ),
          ],
        ),
      ),
    );
  }
}
