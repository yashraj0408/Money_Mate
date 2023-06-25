import 'package:flutter/material.dart';
import 'package:money_mate/components/rounded_buttton.dart';
import 'package:money_mate/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:money_mate/screens/login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String name;
  late String email;
  late String password;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  Future<void> _saveUserProfile(User user) async {
    try {
      await user.updateDisplayName(name);

      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'displayName': name,
        'photoURL': 'initial value', // Set initial photoURL to a default value
        'email': email,
      });
    } catch (e) {
      print(e);
    }
  }

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
      margin: EdgeInsets.only(bottom: 30, left: 25, right: 25),
    );
    _scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
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
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: kInputTextDecoration.copyWith(
                    hintText: '',
                    labelText: 'Full Name',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 15,
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
                RoundedButton(
                  color: kPurple,
                  buttonText: 'Sign up',
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      // Validate input fields
                      if (name == null || name.isEmpty) {
                        throw 'Please enter your full name.';
                      }

                      if (email == null || email.isEmpty) {
                        throw 'Please enter your email.';
                      }

                      if (password == null || password.isEmpty) {
                        throw 'Please enter your password.';
                      }

                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );

                      if (newUser != null) {
                        await _saveUserProfile(newUser.user!);
                        Navigator.pushNamed(context, '/dashboard');
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
                        if (e.code == 'email-already-in-use') {
                          errorMessage =
                              'Email already registered. Use a different email.';
                        } else if (e.code == 'weak-password') {
                          errorMessage =
                              'Weak password. Please choose a stronger password.';
                        } else if (e.code == 'invalid-email') {
                          errorMessage = 'Invalid email format.';
                        } else {
                          errorMessage = 'Sign up failed. Please try again.';
                        }
                      } else {
                        errorMessage = 'Sign up failed. Please try again.';
                      }

                      _showErrorSnackBar(errorMessage);
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
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
                                    LoginScreen(),
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
                        "LogIn",
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
