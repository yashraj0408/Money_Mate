import 'package:flutter/material.dart';
import 'package:money_mate/screens/assets.dart';
import 'package:money_mate/screens/dashboard.dart';
import 'package:money_mate/screens/welcome_screen.dart';
import 'package:money_mate/screens/login_screen.dart';
import 'package:money_mate/screens/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'screens/input_page.dart';
import 'screens/profile.dart';
import 'constants.dart';
import 'package:provider/provider.dart';
import 'services/nav_provider.dart';

// void main() async {
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: MoneyMate(),
    ),
  );
}

class MoneyMate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: kBgColor,
          // primary: Color(0XFF18222c),
        ),
        scaffoldBackgroundColor: kBgColor,
      ),

      initialRoute: '/',
      routes: {
        // '/': (context) => WelcomeScreen(),
        '/': (context) => Dashboard(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/home': (context) => Dashboard(),
        '/assets': (context) => Assets(),
        '/profile': (context) => Profile(),
      },
      // home: InputPage(),
    );
  }
}
