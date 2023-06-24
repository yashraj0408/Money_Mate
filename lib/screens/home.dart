import 'package:flutter/material.dart';
import 'package:money_mate/constants.dart';
import 'package:money_mate/components/reusable_card.dart';
import 'package:money_mate/models/models.dart';
import 'package:money_mate/services/firebase.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserData userData = UserData(
    uid: 'initial value',
    userName: 'initial value',
    email: 'initial value',
    imageUrl: 'initial value',
  );

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    FirebaseServices.getUserData(userData).then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //to get the first name of the user
    String firstName = userData.userName;
    if (firstName.contains(' ')) {
      firstName = firstName.substring(0, firstName.indexOf(' '));
    }

    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
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
                            CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  userData.imageUrl != 'initial value'
                                      ? NetworkImage(userData.imageUrl)
                                      : AssetImage("images/dp.png")
                                          as ImageProvider<Object>?,
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hey, ${firstName}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Welcome to Moneymate",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
