import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:union/component/const/colors.dart';
import 'package:union/component/provider/drag_format.dart';

class Calander extends StatelessWidget {
  final DateTime selectedDay;
  final OnDaySelected onDaySelected;
  final HeaderStyle headerStyle;
  final bool headerVisible;
  final DateTime? focusedDay;
  final Function(DateTime)? onPageChanged;
  // final CalendarFormat formatStyle;
  const Calander({
    required this.selectedDay,
    required this.onDaySelected,
    this.focusedDay,
    this.headerVisible = true,
    this.headerStyle = const HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
      titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w900,
          height: 1.1),
      leftChevronVisible: false,
      rightChevronVisible: false,
    ),
    this.onPageChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      headerVisible: headerVisible,
      calendarFormat: Provider.of<DragFormat>(context).dragFormat,
      focusedDay: focusedDay ?? selectedDay,
      firstDay: DateTime(1945),
      lastDay: DateTime(2100),
      calendarStyle: CalendarStyle(
        selectedDecoration: const BoxDecoration(
          color: Color.fromARGB(255, 118, 120, 167),
          shape: BoxShape.circle,
        ),
        defaultTextStyle: const TextStyle(
          color: Color.fromARGB(255, 222, 222, 222),
          fontSize: 15.3,
          fontFamily: 'Kodchasan',
        ),
        selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'Kodchasan',
            fontSize: 18.3,
            fontWeight: FontWeight.w900),
        todayDecoration: BoxDecoration(
          color: COLOR_BLACK(80),
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: headerStyle,
      onDaySelected: onDaySelected,
      selectedDayPredicate: (DateTime date) {
        return date.year == selectedDay.year &&
            date.month == selectedDay.month &&
            date.day == selectedDay.day;
      },
      onPageChanged: onPageChanged,
    );
  }
}
