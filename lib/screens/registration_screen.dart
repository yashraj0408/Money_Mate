import 'package:flutter/material.dart';
import 'package:money_mate/components/rounded_buttton.dart';
import 'package:money_mate/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                decoration:
                    kInputTextDecoration.copyWith(hintText: 'Full name'),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kInputTextDecoration.copyWith(hintText: 'Email'),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration:
                    kInputTextDecoration.copyWith(hintText: 'Create password'),
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
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);

                    if (newUser != null) {
                      Navigator.pushNamed(context, '/dashboard');
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                  ;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
