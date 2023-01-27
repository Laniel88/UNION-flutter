import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DragFormat with ChangeNotifier {
  var _dragFormat = CalendarFormat.month;
  CalendarFormat get dragFormat => _dragFormat;

  void dragUp() {
    _dragFormat = CalendarFormat.twoWeeks;
    notifyListeners();
  }

  void dragDw() {
    _dragFormat = CalendarFormat.month;
    notifyListeners();
  }
}

