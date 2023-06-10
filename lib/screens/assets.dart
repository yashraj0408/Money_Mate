import 'package:flutter/material.dart';
import 'package:money_mate/components/reusable_card.dart';
import 'package:money_mate/constants.dart';

class Assets extends StatefulWidget {
  @override
  State<Assets> createState() => _AssetsState();
}

class _AssetsState extends State<Assets> {
  List<String> portfolioItems = [];

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
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    portfolioItems.isEmpty
                        ? "Seems like you don’t have any portfolio. Create one."
                        : "Your Portfolio:",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  if (portfolioItems.isEmpty)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          portfolioItems.add("New Portfolio Item");
                        });
                      },
                      child: Icon(Icons.add),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(16),
                        backgroundColor: kPurple,
                      ),
                    ),
                  if (portfolioItems.isNotEmpty)
                    Column(
                      children: [
                        for (String item in portfolioItems)
                          ReusableCard(
                            aspectRatio: 4,
                            colour: kCardColor,
                            cardChild: ListTile(
                              title: Text(item),
                            ),
                          ),
                        // Card(
                        //   child: ListTile(
                        //     title: Text(item),
                        //   ),
                        // ),
                      ],
                    ),
                  SizedBox(
                    height: 15,
                  ),
                  if (portfolioItems.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 17, right: 17),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                portfolioItems.add("New Portfolio Item");
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Add portfolio"),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15), // Adjust the radius as needed
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 24),
                              backgroundColor: kPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavBar(),
    );
  }
}
