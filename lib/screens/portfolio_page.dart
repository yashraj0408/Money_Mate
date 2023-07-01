import 'package:flutter/material.dart';
import 'package:money_mate/constants.dart';
import 'package:money_mate/components/reusable_card.dart';

class PortfolioPage extends StatefulWidget {
  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  String portfolioName = '';
  List<String> AssetsItems = [];
  ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    portfolioName = arguments['portfolioName'] as String;
  }

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
                  'Add Assets',
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
                    labelText: 'Asset Name',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
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
                          AssetsItems.add(inputText);
                        });
                        Navigator.of(context).pop();
                        //scroll to the end
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        });
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
        title: Text(portfolioName),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      AssetsItems.isEmpty
                          ? "Seems like you don’t have any asset in $portfolioName Portfolio.\nAdd one.\n👇"
                          : "Your Assets:",
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.7,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  if (AssetsItems.isEmpty)
                    ElevatedButton(
                      onPressed: _showInputDialog,
                      child: Icon(Icons.add),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(16),
                        backgroundColor: kPurple,
                      ),
                    ),
                  if (AssetsItems.isNotEmpty)
                    Column(
                      children: [
                        for (String item in AssetsItems)
                          ReusableCard(
                            aspectRatio: 4,
                            colour: kCardColor,
                            cardChild: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 0, bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  SizedBox(
                    height: 15,
                  ),
                  if (AssetsItems.isNotEmpty)
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
                                Text("Add asset"),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15), // Adjust the radius as needed
                              ),
                              padding: const EdgeInsets.symmetric(
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
    );
  }
}
