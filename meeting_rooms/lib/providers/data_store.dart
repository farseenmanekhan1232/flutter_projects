import 'package:flutter/material.dart';
import 'package:meeting_rooms/models/mydateformat.dart';

class DataStore extends ChangeNotifier {
  bool _isPresent = false;
  bool get isDataPresent => _isPresent;
  Map<String, dynamic> _data = {'Date': MyDateFormat.dateFrmt(DateTime.now())};
  Map<String, dynamic> get data => _data;

  void addData(String name, dynamic value) {
    _data.addAll({name: value});
    if (_data.containsKey('Date') && _data.containsKey('Duration')) {
      _isPresent = true;
    } else {
      _isPresent = false;
    }
    notifyListeners();
  }

  void clearData() {
    _data = {'Date': MyDateFormat.dateFrmt(DateTime.now())};
    _isPresent = false;
    notifyListeners();
  }
}
