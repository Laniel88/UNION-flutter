import 'package:flutter/material.dart';
import 'package:union/component/const/colors.dart';

class TodoBanner extends StatelessWidget {
  final DateTime selectedDay;
  final int? scheduleCount;

  const TodoBanner({
    required this.selectedDay,
    required this.scheduleCount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0),
      child: Column(
        children: [
          const SizedBox(
              height: 22,
              child: Divider(color: COLOR_GRAY_LIGHT, thickness: 0.5)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedDay.year}.${selectedDay.month}.${selectedDay.day}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.w900),
                ),
                Row(
                  children: [
                    Text(
                      'From all Groups: ',
                      style: const TextStyle(
                          color: COLOR_GRAY_LIGHT,
                          fontSize: 12,
                          fontFamily: 'RobotoMono'),
                    ),
                    Text(
                      scheduleCount != null
                          ? '$scheduleCount Tasks'
                          : '- Tasks',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13.5,
                          fontFamily: 'RobotoMono'),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
              height: 23,
              child: Divider(color: COLOR_GRAY_LIGHT, thickness: 0.5)),
        ],
      ),
    );
  }
}
