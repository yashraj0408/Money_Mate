import 'package:flutter/material.dart';
import 'package:money_mate/constants.dart';
import 'package:money_mate/components/reusable_card.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                        radius: 20,
                        backgroundImage: AssetImage('images/dp.png'),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Hey, Yash",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Welcome back to Moneymate",
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
      ),
      // bottomNavigationBar: BottomNavBar(),
    );
  }
}
