import 'package:flutter/material.dart';
import 'package:money_mate/constants.dart';
import 'package:money_mate/components/reusable_card.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ReusableCard(
                colour: kCardColor,
                cardChild: Column(
                  children: [Text('Total Balance'), Text('Rs 100000')],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
