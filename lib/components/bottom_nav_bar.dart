import 'package:flutter/material.dart';
import 'package:money_mate/constants.dart';
import 'package:provider/provider.dart';
import 'package:money_mate/services/nav_provider.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final selectedIndex = navigationProvider.selectedIndex;

    void _onItemTapped(int index) {
      navigationProvider.setIndex(index);

      if (index == 0) {
        Navigator.pushNamed(context, '/home');
      } else if (index == 1) {
        Navigator.pushNamed(context, '/assets');
      } else if (index == 2) {
        Navigator.pushNamed(context, '/profile');
      }
    }

    return Container(
      height: 105.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
          ),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: kNavbarColor,
            selectedItemColor: const Color(0XFF2da4fe),
            unselectedItemColor: const Color(0xff788ea3),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 28,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_balance_wallet,
                  size: 27,
                ),
                label: 'Assets',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 27,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
