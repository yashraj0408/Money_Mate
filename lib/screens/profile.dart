import 'package:flutter/material.dart';
import 'package:money_mate/services/nav_provider.dart';
import 'package:provider/provider.dart';
import 'package:money_mate/components/bottom_nav_bar.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    navigationProvider.setIndex(2);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Text("hi"), // Existing code...
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
