import "package:flutter/material.dart";

import "package:first_app/dice_roller.dart";

const startAlignment = Alignment.topCenter;

const endAlignment = Alignment.bottomCenter;

class GradientContainer extends StatelessWidget {
  const GradientContainer(this.color1, this.color2,
      {this.textColor, super.key});
  final Color color1;
  final Color color2;
  final Color? textColor;

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: startAlignment,
          end: endAlignment,
          colors: [color1, color2],
        ),
      ),
      child: const Center(child: DiceRoller()),
    );
  }
}
