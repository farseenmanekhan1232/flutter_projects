import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  final String text;
  final Color? textColor;

  const StyledText(this.text, {this.textColor, super.key});

  @override
  Widget build(context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor ?? Colors.white,
      ),
    );
  }
}
