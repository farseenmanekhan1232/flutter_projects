import 'package:flutter/material.dart';

class UIProvider extends ChangeNotifier {
  String _currentSlot = "";

  get currentSlot => _currentSlot;

  void setSlotBorder(String key) {
    _currentSlot = key;
    notifyListeners();
  }

  void clearSlotBorder() {
    _currentSlot = "";
    notifyListeners();
  }
}
