import 'package:flutter/material.dart';
import 'package:money_mate/components/reusable_card.dart';
import 'package:money_mate/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_mate/models/models.dart';
import 'package:money_mate/Asset Data/supported_crypto_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PortfolioPage extends StatefulWidget {
  @override
  final String portfolioName;
  final String portfolioId;

  const PortfolioPage({required this.portfolioName, required this.portfolioId});

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

  Map<String, double> cryptoDataMap = {};
  bool isLoadingCryptoData = true;

  @override
  void initState() {
    super.initState();
    fetchCryptoData();
    // Get the current user
    currentUser = FirebaseAuth.instance.currentUser;
    // Get the asset collection reference
    String portfolioId = widget.portfolioId;
    if (currentUser != null) {
      assetDocument = FirebaseFirestore.instance.collection('portfolio').doc(currentUser!.uid).collection('items').doc(portfolioId);
    }
  }

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
      id: topAssets[selectedAssetIndex].id,
      name: topAssets[selectedAssetIndex].name,
      symbol: topAssets[selectedAssetIndex].symbol,
      amount: double.parse(amountController.text),
      buyingPrice: double.parse(buyingPriceController.text),
    );
    FirebaseFirestore.instance.collection('portfolio').doc(currentUser!.uid).collection('items').doc(widget.portfolioId).collection('asset').add({
      'id': asset.id,
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
                        child: Text('${entry.value.name} (${entry.value.symbol})'),
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
                            String cryptoId = topAssets[selectedAssetIndex].id;
                            String assetName = topAssets[selectedAssetIndex].name;
                            String symbol = topAssets[selectedAssetIndex].symbol;
                            double amount = double.parse(amountController.text);
                            double buyingPrice = double.parse(buyingPriceController.text);
                            assets.add(
                              Asset(
                                id: cryptoId,
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

  void _showDeleteConfirmationDialog(String assetId) {
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
                      'Delete Asset',
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
                      'Are you sure you want to delete this Asset?',
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
                          _deleteAssetFromFirestore(assetId);
                          Navigator.of(context).pop();
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

  void _deleteAssetFromFirestore(String assetId) {
    FirebaseFirestore.instance.collection('portfolio').doc(currentUser!.uid).collection('items').doc(widget.portfolioId).collection('asset').doc(assetId).delete();
  }

  Future<void> fetchCryptoData() async {
    final cryptoId = topAssets.map((asset) => asset.id).toList();
    final url = Uri.parse('https://api.coingecko.com/api/v3/simple/price?ids=${cryptoId.join(',')}&vs_currencies=inr');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      for (final asset in topAssets) {
        final crypId = asset.id;
        if (data.containsKey(crypId)) {
          final price = data[crypId]['inr'];
          cryptoDataMap[crypId] = price.toDouble();
        }
      }
      setState(() {
        isLoadingCryptoData = false;
      });
    } else {
      throw Exception('Failed to fetch crypto data');
    }
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
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (isLoadingCryptoData) {
                            return CircularProgressIndicator();
                          }
                          final assetsList = snapshot.data!.docs.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            final cryptoId = data['id'];
                            final name = data['name'];
                            final symbol = data['symbol'];
                            final amount = data['amount'];
                            final buyingPrice = data['buyingPrice'];
                            final currentValue = amount * (cryptoDataMap[cryptoId] ?? 0.0);
                            final priceChange = currentValue - (amount * buyingPrice);
                            final percentageChange = (priceChange / (amount * buyingPrice)) * 100;

                            return {
                              'id': doc.id,
                              'name': name,
                              'symbol': symbol,
                              'amount': amount,
                              'buyingPrice': buyingPrice,
                              'currentValue': currentValue,
                              'priceChange': priceChange,
                              'percentageChange': percentageChange,
                            };
                          }).toList();
                          bool isAssetEmpty = assetsList.isEmpty;

                          String calculateTotalValue(List<Map<String, dynamic>> assetsList) {
                            double totalValue = 0.0;
                            for (var asset in assetsList) {
                              totalValue += asset["currentValue"];
                            }
                            return totalValue.toStringAsFixed(2);
                          }

                          String calculateTotalValueInDollar(List<Map<String, dynamic>> assetsList) {
                            double totalValue = 0.0;
                            for (var asset in assetsList) {
                              totalValue += asset["currentValue"];
                            }
                            totalValue /= 90;
                            return totalValue.toStringAsFixed(2);
                          }

                          return isAssetEmpty
                              ? SingleChildScrollView(
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height / 4),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20, right: 20),
                                            child: Text(
                                              "You don’t have any assets in \n${widget.portfolioName} Portfolio.\nAdd one.\n👇",
                                              style: TextStyle(
                                                fontSize: 18,
                                                height: 1.7,
                                                color: kFadedText,
                                              ),
                                              textAlign: TextAlign.center,
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
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    ReusableCard(
                                        colour: kBgColor,
                                        aspectRatio: 3.5,
                                        cardChild: Padding(
                                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            Text(
                                              "Total Balance (INR)",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '₹${calculateTotalValue(assetsList)}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 36,
                                                color: Colors.white,
                                              ),
                                              //sum of all current value from all below cards],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '≈\$${(calculateTotalValueInDollar(assetsList))}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 17,
                                                color: kFadedText,
                                              ),
                                              //sum of all current value from all below cards],
                                            ),
                                          ]),
                                        )),
                                    for (var asset in assetsList)
                                      GestureDetector(
                                        onLongPress: () {
                                          _showDeleteConfirmationDialog(asset["id"]);
                                        },
                                        child: ReusableCard(
                                          colour: kCardColor,
                                          aspectRatio: 3.5,
                                          cardChild: Padding(
                                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Row(
                                                children: [
                                                  Column(
                                                    // mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 4),
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text(
                                                              asset["symbol"], //name will go here | left
                                                              style: const TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 27,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.all(2.0),
                                                              child: Text(
                                                                asset["amount"].toStringAsFixed(2), //amount data will go here | left
                                                                style: const TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 16,
                                                                  color: kFadedText,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 13,
                                                      ),
                                                      Text(
                                                        'Avg. Buy:  ₹${asset["buyingPrice"].toStringAsFixed(2)}', //left
                                                        textAlign: TextAlign.start,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 14,
                                                          color: kFadedText,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(2.0),
                                                          child: Text(
                                                            '₹${(asset["currentValue"]).toStringAsFixed(2)}', //current ammount
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 22,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Text(
                                                              '${asset["priceChange"] >= 0 ? '+' : '-'}${(asset["priceChange"]).abs().toStringAsFixed(2)}', //total profit/gain
                                                              textAlign: TextAlign.start,
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 14,
                                                                color: (asset["priceChange"]) >= 0 ? kLightGreen : kLightRed,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.fromLTRB(4, 4, 8, 4),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(6),
                                                                color: ((asset["percentageChange"])) > 0
                                                                    ? kDarkGreen
                                                                    : ((asset["percentageChange"])) < 0
                                                                        ? kDarkRed
                                                                        : kFadedText,
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    asset["percentageChange"] >= 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                                                    size: 18,
                                                                    color: asset["percentageChange"] >= 0 ? kLightGreen : kLightRed,
                                                                  ),
                                                                  Text(
                                                                    '${(asset["percentageChange"]).abs().toStringAsFixed(1)}%', //percentage change
                                                                    textAlign: TextAlign.start,
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: 14,
                                                                      color: asset["percentageChange"] >= 0 ? kLightGreen : kLightRed,
                                                                    ),
                                                                  ),
                                                                ],
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
                                      ),
                                    SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 17),
                                      child: ElevatedButton(
                                        onPressed: _showInputDialog,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                            borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
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
