import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_mate/components/reusable_card.dart';
import 'package:money_mate/constants.dart';
import 'package:money_mate/screens/portfolio_page.dart';

class Assets extends StatefulWidget {
  @override
  State<Assets> createState() => _AssetsState();
}

class _AssetsState extends State<Assets> {
  final ScrollController _scrollController = ScrollController();
  CollectionReference? _portfolioCollection;
  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    _initializeCurrentUser();
  }

  void _initializeCurrentUser() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _currentUser = user;
        if (_currentUser != null) {
          _portfolioCollection = FirebaseFirestore.instance
              .collection('portfolio')
              .doc(_currentUser!.uid)
              .collection('items');
        }
      });
    });
  }

  void _navigateToPortfolioPage(String portfolioName, String assetId) {
    // Navigator.pushNamed(context, '/portfolio',
    //     arguments: {'portfolioName': portfolioName, 'assetId': assetId});
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PortfolioPage(portfolioName: portfolioName, assetId: assetId),
      ),
    );
  }

  void _showInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String inputText = '';

        return Dialog(
          backgroundColor: kCardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
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
                      onPressed: () async {
                        if (_currentUser != null &&
                            _portfolioCollection != null) {
                          await _portfolioCollection!.add({
                            'name': inputText,
                          });
                          Navigator.of(context).pop();
                          // Scroll to the end
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          });
                        }
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

  void _showDeleteConfirmationDialog(String portfolioId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: kCardColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Delete Portfolio',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Are you sure you want to delete this portfolio?',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: kLightBlue),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          if (_portfolioCollection != null) {
                            await _portfolioCollection!
                                .doc(portfolioId)
                                .delete();
                          }
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
        title: const Text('Money Mate'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: _portfolioCollection?.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Failed to fetch portfolio items.');
                      } else {
                        List<QueryDocumentSnapshot> documents =
                            snapshot.data?.docs ?? [];
                        bool isPortfolioEmpty = documents.isEmpty;

                        return Column(
                          children: [
                            Text(
                              isPortfolioEmpty
                                  ? "You don't have any portfolio.\nCreate one.\n👇"
                                  : "Your Portfolio:",
                              style: const TextStyle(
                                fontSize: 18,
                                height: 1.7,
                                color: kfadedText,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            for (var document in documents)
                              GestureDetector(
                                onTap: () {
                                  _navigateToPortfolioPage(
                                      document['name'], document.id);
                                },
                                onLongPress: () {
                                  _showDeleteConfirmationDialog(document.id);
                                },
                                child: ReusableCard(
                                  aspectRatio: 4,
                                  colour: kCardColor,
                                  cardChild: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 0,
                                          bottom: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            document['name'],
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
                              ),
                            SizedBox(height: 20),
                            if (isPortfolioEmpty)
                              ElevatedButton(
                                onPressed: _showInputDialog,
                                child: Icon(Icons.add),
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(16),
                                  backgroundColor: kPurple,
                                ),
                              ),
                            if (!isPortfolioEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 17, right: 17),
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 24),
                                    backgroundColor: kPurple,
                                  ),
                                ),
                              ),
                          ],
                        );
                      }
                    },
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
