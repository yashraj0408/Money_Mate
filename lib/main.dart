import 'package:flutter/material.dart';
import 'package:money_mate/screens/dashboard.dart';
import 'package:money_mate/screens/welcome_screen.dart';
import 'package:money_mate/screens/login_screen.dart';
import 'package:money_mate/screens/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'screens/input_page.dart';

// void main() async {
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MoneyMate());
}

class MoneyMate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Color(0XFF0A0E21),
        ),
        scaffoldBackgroundColor: Color(0XFF0A0E21),
      ),

      initialRoute: '/',
      routes: {
        // '/': (context) => WelcomeScreen(),
        '/': (context) => Dashboard(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/dashboard': (context) => Dashboard(),
      },
      // home: InputPage(),
    );
  }
}
