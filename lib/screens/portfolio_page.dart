import 'package:flutter/material.dart';
import 'package:money_mate/constants.dart';
import 'package:money_mate/components/reusable_card.dart';

class PortfolioPage extends StatefulWidget {
  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class Asset {
  final String name;
  final String symbol;

  Asset({required this.name, required this.symbol});
}

class _PortfolioPageState extends State<PortfolioPage> {
  String portfolioName = '';
  List<Asset> assets = [];
  ScrollController _scrollController = ScrollController();
  TextEditingController assetNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController buyingPriceController = TextEditingController();
  Asset? selectedAsset;

  List<Asset> topAssets = [
    Asset(name: 'Bitcoin', symbol: 'BTC'),
    Asset(name: 'Ethereum', symbol: 'ETH'),
    Asset(name: 'Binance Coin', symbol: 'BNB'),
    Asset(name: 'Cardano', symbol: 'ADA'),
    Asset(name: 'XRP', symbol: 'XRP'),
    Asset(name: 'Dogecoin', symbol: 'DOGE'),
    Asset(name: 'Polkadot', symbol: 'DOT'),
    Asset(name: 'Litecoin', symbol: 'LTC'),
    Asset(name: 'Bitcoin Cash', symbol: 'BCH'),
    Asset(name: 'Chainlink', symbol: 'LINK'),
  ];

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
                  'Add Asset',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<Asset>(
                  value: selectedAsset,
                  onChanged: (asset) {
                    setState(() {
                      selectedAsset = asset;
                    });
                  },
                  dropdownColor: kCardColor,
                  items: topAssets.map((Asset asset) {
                    return DropdownMenuItem<Asset>(
                      value: asset,
                      child: Text('${asset.name} (${asset.symbol})'),
                    );
                  }).toList(),
                  decoration: kInputTextDecoration.copyWith(
                    labelText: 'Asset Name',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: amountController,
                  decoration: kInputTextDecoration.copyWith(
                    labelText: 'Amount',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: buyingPriceController,
                  decoration: kInputTextDecoration.copyWith(
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
                        style: TextStyle(color: kLightBlue),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          String assetName = selectedAsset?.name ?? '';
                          String symbol = selectedAsset?.symbol ?? '';
                          String amount = amountController.text;
                          String buyingPrice = buyingPriceController.text;
                          assets.add(Asset(name: assetName, symbol: symbol));
                          amountController.clear();
                          buyingPriceController.clear();
                          selectedAsset = null;
                        });
                        Navigator.of(context).pop();
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        });
                      },
                      child: const Text(
                        'Add',
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
        title: Text('$portfolioName Portfolio'),
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
                      assets.isEmpty
                          ? "Seems like you don’t have any assets in $portfolioName Portfolio.\nAdd one.\n👇"
                          : "Your Assets:",
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.7,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  if (assets.isEmpty)
                    ElevatedButton(
                      onPressed: _showInputDialog,
                      child: Icon(Icons.add),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(16),
                        backgroundColor: kPurple,
                      ),
                    ),
                  if (assets.isNotEmpty)
                    Column(
                      children: [
                        for (Asset asset in assets)
                          ReusableCard(
                            aspectRatio: 4,
                            colour: kCardColor,
                            cardChild: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, right: 4, top: 2, bottom: 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ListTile(
                                      title: Text(
                                        asset.symbol,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 27,
                                        ),
                                      ),
                                      subtitle: Text(
                                        asset.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
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
                  if (assets.isNotEmpty)
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
