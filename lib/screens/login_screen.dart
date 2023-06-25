import 'package:flutter/material.dart';
import 'package:money_mate/components/rounded_buttton.dart';
import 'package:money_mate/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:money_mate/screens/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  void _showErrorSnackBar(String errorMessage) {
    final snackBar = SnackBar(
      content: Text(
        errorMessage,
        style: TextStyle(color: Colors.white),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 60, left: 25, right: 25),
    );
    _scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        // backgroundColor: Colors.white,

        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 230.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kInputTextDecoration.copyWith(
                    hintText: '',
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kInputTextDecoration.copyWith(
                    hintText: '',
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                // RoundedButton(
                //   color: kPurple,
                //   buttonText: 'Login',
                //   onPressed: () async {
                //     try {
                //       setState(() {
                //         showSpinner = true;
                //       });
                //       final user = await _auth.signInWithEmailAndPassword(
                //           email: email, password: password);
                //       if (user != null) {
                //         Navigator.popUntil(context, ModalRoute.withName('/'));
                //         Navigator.pushNamed(context, '/dashboard');
                //       }
                //       setState(() {
                //         showSpinner = false;
                //       });
                //     } catch (e) {
                //       print(e);
                //     }
                //   },
                // ),
                RoundedButton(
                  color: kPurple,
                  buttonText: 'Login',
                  onPressed: () async {
                    try {
                      setState(() {
                        showSpinner = true;
                      });

                      // Check if the email field is empty
                      if (email == null || email.isEmpty) {
                        throw 'Please enter your email.';
                      }

                      // Check if the password field is empty
                      if (password == null || password.isEmpty) {
                        throw 'Please enter your password.';
                      }

                      final user = await _auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );

                      if (user != null) {
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                        Navigator.pushNamed(context, '/dashboard');
                      } else {
                        throw 'Unable to login. Please check your email and password.';
                      }

                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      setState(() {
                        showSpinner = false;
                      });

                      // Handle different error scenarios
                      String errorMessage;
                      if (e is String) {
                        errorMessage = e;
                      } else if (e is FirebaseAuthException) {
                        if (e.code == 'user-not-found') {
                          errorMessage = 'Email not registered.';
                        } else if (e.code == 'wrong-password') {
                          errorMessage = 'Wrong password.';
                        } else if (e.code == 'invalid-email') {
                          errorMessage = 'Invalid email format.';
                        } else {
                          errorMessage = 'Login failed. Please try again.';
                        }
                      } else {
                        errorMessage = 'Login failed. Please try again.';
                      }

                      _showErrorSnackBar(errorMessage);
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Dont have an account?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    RegistrationScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            transitionDuration:
                                const Duration(milliseconds: 50),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
