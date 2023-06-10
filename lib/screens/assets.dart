import 'package:flutter/material.dart';
import 'package:money_mate/components/reusable_card.dart';
import 'package:money_mate/constants.dart';

class Assets extends StatefulWidget {
  @override
  State<Assets> createState() => _AssetsState();
}

class _AssetsState extends State<Assets> {
  List<String> portfolioItems = [];

  void _showInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String inputText = '';

        return Dialog(
          backgroundColor: kCardColor, // Set the background color of the dialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10.0), // Apply rounded corners to the dialog
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Create Portfolio',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  onChanged: (value) {
                    inputText = value;
                  },
                  decoration: kInputTextDecoration.copyWith(
                    hintText: '',
                    labelText: 'Portfolio Name',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  // InputDecoration(
                  //   border: OutlineInputBorder(),
                  //   labelText: 'Portfolio Name',
                  // ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: kLightBlue),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          portfolioItems.add(inputText);
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Create',
                        style: TextStyle(color: kLightBlue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
                        ? "Seems like you don’t have any portfolio.\nCreate one.\n\n👇"
                        : "Your Portfolio:",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  if (portfolioItems.isEmpty)
                    ElevatedButton(
                      onPressed: _showInputDialog,
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
                            onPressed: _showInputDialog,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 25,
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
                                  vertical: 14, horizontal: 24),
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
