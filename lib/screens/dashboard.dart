import 'package:flutter/material.dart';
import 'package:money_mate/constants.dart';
import 'package:money_mate/components/reusable_card.dart';
import 'package:money_mate/components/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:money_mate/services/nav_provider.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    navigationProvider.setIndex(0);
    return Scaffold(
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
                        children: [
                          const Text(
                            'Total Balance :',
                            style: TextStyle(
                              fontSize: 18.0,

                              // color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Icon(Icons.currency_rupee),
                                height: 34,
                              ),
                              const Text(
                                '120000',
                                style: TextStyle(
                                  fontSize: 38.0,
                                  fontWeight: FontWeight.w500,
                                  // color: Colors.black,
                                ),
                              ),
                            ],
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
                        children: [
                          const Text(
                            'Total Invested :',
                            style: TextStyle(
                              fontSize: 18.0,

                              // color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Icon(Icons.currency_rupee),
                                height: 34,
                              ),
                              const Text(
                                '100000',
                                style: TextStyle(
                                  fontSize: 38.0,
                                  fontWeight: FontWeight.w500,
                                  // color: Colors.black,
                                ),
                              ),
                            ],
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
                        children: [
                          Text(
                            'Total Profit :',
                            style: TextStyle(
                              fontSize: 18.0,

                              // color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Icon(Icons.currency_rupee),
                                height: 34,
                              ),
                              Text(
                                '20000',
                                style: TextStyle(
                                  fontSize: 38.0,
                                  fontWeight: FontWeight.w500,
                                  // color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ]),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
