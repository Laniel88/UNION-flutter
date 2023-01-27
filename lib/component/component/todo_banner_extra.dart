import 'package:flutter/material.dart';
import 'package:union/component/const/colors.dart';

class TodoBannerExtra extends StatelessWidget {
  final DateTime selectedDay;
  final int? scheduleCount;
  final void Function()? groupPressed;
  final void Function()? addPressed;

  const TodoBannerExtra({
    required this.selectedDay,
    required this.scheduleCount,
    required this.groupPressed,
    required this.addPressed,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${selectedDay.year}.${selectedDay.month}.${selectedDay.day}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  scheduleCount != null
                      ? ' : $scheduleCount Tasks'
                      : ' : - Tasks',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      fontFamily: 'RobotoMono'),
                ),
                const Expanded(child: SizedBox()),
                IconButton(
                  onPressed: groupPressed,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 10,
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: addPressed,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 10,
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
              height: 23,
              child: Divider(color: COLOR_GRAY_LIGHT, thickness: 0.5)),
        ],
      ),
    );
  }
}
