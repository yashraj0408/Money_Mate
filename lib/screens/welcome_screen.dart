import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:money_mate/components/rounded_buttton.dart';
import 'package:money_mate/constants.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 0),
      vsync: this,
      // upperBound: 100,
    );

    // animation = CurvedAnimation(parent: controller, curve: Curves.bounceIn);
    animation = ColorTween(begin: lightblue, end: bgColor).animate(controller);
    controller.forward();
    controller.addListener(() {
      // print(animation.value);
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset('images/logo.png'),
                height: 150,
              ),
            ),
            AnimatedTextKit(isRepeatingAnimation: false, animatedTexts: [
              WavyAnimatedText(
                'MoneyMate',
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 50.0,
                  fontWeight: FontWeight.w900,
                ),
                speed: const Duration(milliseconds: 200),
              ),
            ]),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
                color: lightblue,
                buttonText: 'Login',
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                }),
            RoundedButton(
                color: purple,
                buttonText: 'Signup',
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                }),
          ],
        ),
      ),
    );
  }
}
