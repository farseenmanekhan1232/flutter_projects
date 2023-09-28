import 'package:flutter/material.dart';

class TextFieldReturn {
  static Text textField(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  static Text textFieldMeduim(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
