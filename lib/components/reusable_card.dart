import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  final Color colour;
  Widget? cardChild;
  ReusableCard({required this.colour, this.cardChild});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: cardChild,
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colour,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
