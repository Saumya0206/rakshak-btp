import 'package:flutter/material.dart';
import 'package:rakshak/results_screen/Done.dart';
import 'package:rakshak/results_screen/GoogleDone.dart';
import 'package:rakshak/main_screens/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// new downloads
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:validators/validators.dart' as validator;

// ignore: must_be_immutable
class RegisterPage extends StatefulWidget {
  static String id = '/RegisterPage';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // new code
  String name = "";
  String email = "";
  String password = "";

  // old code
  // String name;
  // String email;
  // String password;

  bool _showSpinner = false;

  bool _wrongEmail = false;
  bool _wrongPassword = false;

  String _emailText = 'Please use a valid email';
  String _passwordText = 'Please use a strong password';

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // new code: User
  Future<User> _handleSignIn() async {
    // hold the instance of the authenticated user
    // new code: User
    User user;

    // flag to check whether we're signed in already
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      // if so, return the current user
      // new code
      user = await _auth.currentUser!;

      // old code
      // user = await _auth.currentUser();
    } else {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication; // new code: Added null check

      // get the credentials to (access / id token) to sign in via Firebase Authentication
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      // new code: added null check
      user = (await _auth.signInWithCredential(credential)).user!;
    }

    return user;
  }

  void onGoogleSignIn(BuildContext context) async {
    // new code: User
    User user = await _handleSignIn();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GoogleDone(user, _googleSignIn)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        color: Colors.blueAccent,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Image.asset('assets/images/background.png'),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 60.0, bottom: 20.0, left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'RAKSHAK',
                    style: TextStyle(fontSize: 50.0),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Register into Rakshak',
                        style: TextStyle(fontSize: 30.0),
                      ),
                      Text(
                        'to know about your health :)',
                        style: TextStyle(fontSize: 30.0),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          name = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Full Name',
                          labelText: 'Full Name',
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          errorText: _wrongEmail ? _emailText : null,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          errorText: _wrongPassword ? _passwordText : null,
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                  ElevatedButton(
                    // padding: EdgeInsets.symmetric(vertical: 10.0),
                    // color: Color(0xff447def),
                    onPressed: () async {
                      setState(() {
                        _wrongEmail = false;
                        _wrongPassword = false;
                      });
                      try {
                        if (validator.isEmail(email) &
                            validator.isLength(password, 6)) {
                          setState(() {
                            _showSpinner = true;
                          });
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          if (newUser != null) {
                            print('user authenticated by registration');
                            Navigator.pushNamed(context, Done.id);
                          }
                        }

                        setState(() {
                          if (!validator.isEmail(email)) {
                            _wrongEmail = true;
                          } else if (!validator.isLength(password, 6)) {
                            _wrongPassword = true;
                          } else {
                            _wrongEmail = true;
                            _wrongPassword = true;
                          }
                        });
                      } catch (e) {
                        setState(() {
                          _wrongEmail = true;
                          // new code
                          print(e);
                          _emailText =
                              'The email address is already in use by another account';

                          // old code
                          // if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
                          //   _emailText =
                          //       'The email address is already in use by another account';
                          // }
                        });
                      }
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(fontSize: 25.0, color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          height: 1.0,
                          width: 60.0,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Or',
                        style: TextStyle(fontSize: 25.0),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          height: 1.0,
                          width: 60.0,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          // padding: EdgeInsets.symmetric(vertical: 5.0),
                          // color: Colors.white,
                          // shape: ContinuousRectangleBorder(
                          //   side:
                          //       BorderSide(width: 0.5, color: Colors.grey[400]),
                          // ),
                          onPressed: () {
                            onGoogleSignIn(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/google.png',
                                  fit: BoxFit.contain,
                                  width: 40.0,
                                  height: 40.0),
                              Text(
                                'Google',
                                style: TextStyle(
                                    fontSize: 25.0, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: ElevatedButton(
                          // padding: EdgeInsets.symmetric(vertical: 5.0),
                          // color: Colors.white,
                          // shape: ContinuousRectangleBorder(
                          //   side:
                          //       BorderSide(width: 0.5, color: Colors.grey[400]),
                          // ),
                          onPressed: () {
                            //TODO: Implement facebook functionality
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/facebook.png',
                                  fit: BoxFit.cover, width: 40.0, height: 40.0),
                              Text(
                                'Facebook',
                                style: TextStyle(
                                    fontSize: 25.0, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(fontSize: 25.0),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, LoginPage.id);
                        },
                        child: Text(
                          ' Sign In',
                          style: TextStyle(fontSize: 25.0, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
