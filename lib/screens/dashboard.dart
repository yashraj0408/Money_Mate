import 'package:flutter/material.dart';
import 'package:money_mate/constants.dart';
import 'package:money_mate/components/reusable_card.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ReusableCard(
                aspectRatio: 6,
                colour: kBgColor,
                cardChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('images/dp.png'),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Hey, Yash",
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Welcome to back to Moneymate",
                          ),
                        ],
                      )
                    ]),
                  ],
                ),
              ),
              ReusableCard(
                colour: kCardColor,
                cardChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Total Balance :',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,

                                // color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              '₹ 120000',
                              style: TextStyle(
                                fontSize: 38.0,
                                fontWeight: FontWeight.w500,
                                // color: Colors.black,
                              ),
                            ),
                          ]),
                    )
                  ],
                ),
              ),
              ReusableCard(
                colour: kCardColor,
                cardChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Total Invested :',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,

                                // color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              '₹ 100000',
                              style: TextStyle(
                                fontSize: 38.0,
                                fontWeight: FontWeight.w500,
                                // color: Colors.black,
                              ),
                            ),
                          ]),
                    )
                  ],
                ),
              ),
              ReusableCard(
                colour: kCardColor,
                cardChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Total Profit :',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,

                                // color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              '₹ 20000',
                              style: TextStyle(
                                fontSize: 38.0,
                                fontWeight: FontWeight.w500,
                                // color: Colors.black,
                              ),
                            ),
                          ]),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          // backgroundColor: Color.fromRGBO(71, 76, 102, 0.49),
          backgroundColor: kCardColor,
          // selectedItemColor: Color.fromRGBO(141, 72, 228, 0.49),
          selectedItemColor: kLightBlue,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.money),
              label: 'Portfolio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
