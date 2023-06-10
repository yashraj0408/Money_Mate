import 'package:flutter/material.dart';

class Assets extends StatefulWidget {
  @override
  State<Assets> createState() => _AssetsState();
}

class _AssetsState extends State<Assets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding:
              const EdgeInsets.only(left: 15.0, right: 0, top: 2, bottom: 2),
          child: Image.asset(
            'images/logo.png',
          ),
        ),
        centerTitle: false,
        title: Text('MoneyMate'),
      ),
      body: SafeArea(
        child: Column(
          children: [],
        ),
      ),
      // bottomNavigationBar: BottomNavBar(),
    );
  }
}
