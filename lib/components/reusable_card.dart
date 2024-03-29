import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  final Color colour;
  final Widget? cardChild;
  final double aspectRatio;

  ReusableCard({required this.colour, this.cardChild, double? aspectRatio})
      : aspectRatio = aspectRatio ?? 3.5;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxWidth / aspectRatio;

        return Container(
          height: height,
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: cardChild,
          ),
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: colour,
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }
}
