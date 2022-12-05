import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rakshak/results_screen/ForgotPassword.dart';
import 'package:rakshak/results_screen/GoogleDone.dart';
import 'package:rakshak/main_screens/RegisterPage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../results_screen/Done.dart';
import 'package:rakshak/main_screens/TestPage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

bool _wrongEmail = false;
bool _wrongPassword = false;

// new code: User
late User _user;

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  static String id = '/LoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // new code
  String email = "";
  String password = "";

  // old code
  // String email;
  // String password;

  bool _showSpinner = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // new code: User
  Future<User> _handleSignIn() async {
    // hold the instance of the authenticated user
//    FirebaseUser user;
    // flag to check whether we're signed in already
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      // if so, return the current user
      // new code: added null check
      _user = await _auth.currentUser!;
    } else {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      // get the credentials to (access / id token)
      // to sign in via Firebase Authentication
      // new code: changed to credential
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      // new code: added null check
      _user = (await _auth.signInWithCredential(credential)).user!;
    }

    return _user;
  }

  void onGoogleSignIn(BuildContext context) async {
    setState(() {
      _showSpinner = true;
    });

    // new code: User
    User user = await _handleSignIn();

    setState(() {
      _showSpinner = true;
    });

    Navigator.push(
        context,
        // test code
        MaterialPageRoute(builder: (context) => TestPage())

        // actual code
        // MaterialPageRoute(
        //     builder: (context) => GoogleDone(user, _googleSignIn))
        );
  }

  String emailText = 'Email doesn\'t match';
  String passwordText = 'Password doesn\'t match';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
                    'RAKSHAK Login',
                    style: TextStyle(fontSize: 50.0),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login your details,',
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
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Email',
                          labelText: 'Email',
                          errorText: _wrongEmail ? emailText : null,
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
                          hintText: 'Password',
                          labelText: 'Password',
                          errorText: _wrongPassword ? passwordText : null,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, ForgotPassword.id);
                          },
                          child: Text(
                            'Forgot Password?',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    // padding: EdgeInsets.symmetric(vertical: 10.0),
                    // color: Color(0xff447def),
                    onPressed: () async {
                      setState(() {
                        _showSpinner = true;
                      });
                      try {
                        setState(() {
                          _wrongEmail = false;
                          _wrongPassword = false;
                        });
                        final newUser = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (newUser != null) {
                          Navigator.pushNamed(context, Done.id);
                        }
                      } catch (e) {
                        // new code
                        print(e);
                        setState(() {
                          emailText = 'User doesn\'t exist';
                          passwordText = 'Please check your email';

                          _wrongPassword = true;
                          _wrongEmail = true;
                        });

                        // old code
                        // print(e.code);
                        // if (e.code == 'ERROR_WRONG_PASSWORD') {
                        //   setState(() {
                        //     _wrongPassword = true;
                        //   });
                        // } else {
                        //   setState(() {
                        //     emailText = 'User doesn\'t exist';
                        //     passwordText = 'Please check your email';

                        //     _wrongPassword = true;
                        //     _wrongEmail = true;
                        //   });
                        // }
                      }
                    },
                    child: Text(
                      'Login',
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
                        'Don\'t have an account?',
                        style: TextStyle(fontSize: 25.0),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegisterPage.id);
                        },
                        child: Text(
                          ' Sign Up',
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
