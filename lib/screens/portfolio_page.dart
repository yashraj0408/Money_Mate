import 'package:flutter/material.dart';
import 'package:money_mate/components/reusable_card.dart';
import 'package:money_mate/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Asset {
  final String name;
  final String symbol;
  final double amount;
  final double buyingPrice;

  Asset({
    required this.name,
    required this.symbol,
    required this.amount,
    required this.buyingPrice,
  });
}

class PortfolioPage extends StatefulWidget {
  @override
  final String portfolioName;
  final String assetId;

  const PortfolioPage({required this.portfolioName, required this.assetId});

  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  List<Asset> assets = [];
  ScrollController _scrollController = ScrollController();
  TextEditingController assetNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController buyingPriceController = TextEditingController();
  int selectedAssetIndex = 0;

  late User? currentUser; // Current user
  late DocumentReference assetDocument; // Asset collection reference

  @override
  void initState() {
    super.initState();
    // Get the current user
    currentUser = FirebaseAuth.instance.currentUser;
    // Get the asset collection reference
    String assetId = widget.assetId;
    if (currentUser != null) {
      assetDocument = FirebaseFirestore.instance
          .collection('portfolio')
          .doc(currentUser!.uid)
          .collection('items')
          .doc(assetId);
    }
  }

  List<Asset> topAssets = [
    Asset(
      name: 'Bitcoin',
      symbol: 'BTC',
      amount: 0.0,
      buyingPrice: 0.0,
    ),
    Asset(
      name: 'Ethereum',
      symbol: 'ETH',
      amount: 0.0,
      buyingPrice: 0.0,
    ),
    Asset(
      name: 'Litecoin',
      symbol: 'LTC',
      amount: 0.0,
      buyingPrice: 0.0,
    ),
    Asset(
      name: 'Ripple',
      symbol: 'XRP',
      amount: 0.0,
      buyingPrice: 0.0,
    ),
    Asset(
      name: 'Cardano',
      symbol: 'ADA',
      amount: 0.0,
      buyingPrice: 0.0,
    ),
    Asset(
      name: 'Polkadot',
      symbol: 'DOT',
      amount: 0.0,
      buyingPrice: 0.0,
    ),
    Asset(
      name: 'Chainlink',
      symbol: 'LINK',
      amount: 0.0,
      buyingPrice: 0.0,
    ),
    Asset(
      name: 'Stellar',
      symbol: 'XLM',
      amount: 0.0,
      buyingPrice: 0.0,
    ),
    Asset(
      name: 'VeChain',
      symbol: 'VET',
      amount: 0.0,
      buyingPrice: 0.0,
    ),
    Asset(
      name: 'Tron',
      symbol: 'TRX',
      amount: 0.0,
      buyingPrice: 0.0,
    ),
    Asset(
      name: 'EOS',
      symbol: 'EOS',
      amount: 0.0,
      buyingPrice: 0.0,
    ),
    // Add more assets here
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    assetNameController.dispose();
    amountController.dispose();
    buyingPriceController.dispose();
    super.dispose();
  }

  void _addAssetToFirestore() {
    final asset = Asset(
      name: topAssets[selectedAssetIndex].name,
      symbol: topAssets[selectedAssetIndex].symbol,
      amount: double.parse(amountController.text),
      buyingPrice: double.parse(buyingPriceController.text),
    );
    FirebaseFirestore.instance
        .collection('portfolio')
        .doc(currentUser!.uid)
        .collection('items')
        .doc(widget.assetId)
        .collection('asset')
        .add({
      'name': asset.name,
      'symbol': asset.symbol,
      'amount': asset.amount,
      'buyingPrice': asset.buyingPrice,
    });
    amountController.clear();
    buyingPriceController.clear();
    selectedAssetIndex = 0;
  }

  void _showInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: kCardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Add Asset',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  DropdownButtonFormField<int>(
                    iconEnabledColor: kLightBlue,
                    value: selectedAssetIndex,
                    onChanged: (index) {
                      setState(() {
                        selectedAssetIndex = index!;
                      });
                    },
                    items: topAssets.asMap().entries.map((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key,
                        child:
                            Text('${entry.value.name} (${entry.value.symbol})'),
                      );
                    }).toList(),
                    decoration: kInputTextDecoration.copyWith(
                      hintText: '',
                      labelText: 'Select Asset',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    dropdownColor: kCardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: kInputTextDecoration.copyWith(
                      hintText: '',
                      labelText: 'Amount',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: buyingPriceController,
                    keyboardType: TextInputType.number,
                    decoration: kInputTextDecoration.copyWith(
                      hintText: '',
                      labelText: 'Buying Price',
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
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            String assetName =
                                topAssets[selectedAssetIndex].name;
                            String symbol =
                                topAssets[selectedAssetIndex].symbol;
                            double amount = double.parse(amountController.text);
                            double buyingPrice =
                                double.parse(buyingPriceController.text);
                            assets.add(
                              Asset(
                                name: assetName,
                                symbol: symbol,
                                amount: amount,
                                buyingPrice: buyingPrice,
                              ),
                            );
                            _addAssetToFirestore();
                            // amountController.clear();
                            // buyingPriceController.clear();
                            // selectedAssetIndex = 0;
                          });
                          Navigator.of(context).pop();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          });
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.blue),
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
        title: Text('${widget.portfolioName} Portfolio'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: assetDocument.collection('asset').snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          final assetsList = snapshot.data!.docs.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            return Asset(
                              name: data['name'],
                              symbol: data['symbol'],
                              amount: data['amount'],
                              buyingPrice: data['buyingPrice'],
                            );
                          }).toList();
                          bool isAssetEmpty = assetsList.isEmpty;
                          return Column(
                            children: [
                              Text(
                                isAssetEmpty
                                    ? "You don't have any Asset.\nCreate one.\n👇"
                                    : "Your Asset:",
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.7,
                                  color: kfadedText,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              for (var asset in assetsList)
                                GestureDetector(
                                  onLongPress: () {
                                    // _showDeleteConfirmationDialog(document.id);
                                  },
                                  child: ReusableCard(
                                    colour: kCardColor,
                                    aspectRatio: 3.6,
                                    cardChild: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          25, 21, 25, 21),
                                      child: Row(
                                        children: [
                                          Column(
                                            // mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    asset
                                                        .symbol, //name will go here
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Text(
                                                      asset.amount.toStringAsFixed(
                                                          2), //amount data will go here
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: kfadedText,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                'Avg. Buy ₹${asset.buyingPrice.toStringAsFixed(2)}',
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: kfadedText,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    '₹ ${asset.amount.toStringAsFixed(2)}', //current ammount
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 22,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '-500', //total profit/gain
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      '-50%', //percentage change
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14,
                                                        color: kfadedText,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(height: 20),
                              if (isAssetEmpty)
                                ElevatedButton(
                                  onPressed: _showInputDialog,
                                  child: Icon(Icons.add),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(16),
                                    backgroundColor: kPurple,
                                  ),
                                ),
                              if (!isAssetEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17),
                                  child: ElevatedButton(
                                    onPressed: _showInputDialog,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: 25,
                                        ),
                                        Text(
                                          'Add Asset',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
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
                        }),
                  ],
                ),
                SizedBox(
                  height: 27,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
