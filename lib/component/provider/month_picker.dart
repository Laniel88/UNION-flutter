import 'package:flutter/material.dart';

class MonthPicker with ChangeNotifier {
  var _monthPicker = DateTime.now().month;

  int get monthPicker => _monthPicker;

  void monthChanged(int month) {
    _monthPicker = month;
    notifyListeners();
  }
}
