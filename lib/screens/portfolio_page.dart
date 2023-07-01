import 'package:flutter/material.dart';

class PortfolioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String portfolioName = arguments['portfolioName'] as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(portfolioName),
      ),
      body: Center(
        child: Text('Portfolio Details'),
      ),
    );
  }
}
