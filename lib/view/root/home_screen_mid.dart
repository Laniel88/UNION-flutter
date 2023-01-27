import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union/component/component/calander.dart';
import 'package:union/component/component/custom_progress_indicator.dart';
import 'package:union/component/component/todo_banner.dart';
import 'package:union/component/component/todo_banner_extra.dart';
import 'package:union/component/component/todo_card.dart';
import 'package:union/component/component/todo_card_only.dart';
import 'package:union/component/const/todo_type.dart';
import 'package:union/component/provider/drag_format.dart';
import 'package:union/view/group/load_group_todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scroll = ScrollController(keepScrollOffset: false);

  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    DragFormat dragFormat = Provider.of<DragFormat>(context, listen: false);

    int? todoCnt;
    return Column(
      children: [
        Listener(
          onPointerMove: (details) {
            if (details.delta.dy < -15) {
              dragFormat.dragUp();
            } else if (details.delta.dy > 15) {
              dragFormat.dragDw();
            }
          },
          child: Calander(
            selectedDay: selectedDay,
            onDaySelected: onDaySelected,
          ),
        ),
        FutureBuilder<List<Map>>(
            future: loadGroupTodo(selectedDay),
            builder: (context, snapshot) {
              todoCnt = snapshot.data?.length;
              if (snapshot.hasData) {
                return Expanded(
                  child: Column(
                    children: [
                      TodoBanner(
                        selectedDay: selectedDay,
                        scheduleCount: todoCnt,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ListView.separated(
                            controller: scroll,
                            itemCount: todoCnt ?? 0,
                            separatorBuilder: ((context, index) =>
                                const SizedBox(height: 10)),
                            itemBuilder: (context, index) {
                              if (snapshot.data == null) {
                                return const SizedBox();
                              }
                              Map singleData = snapshot.data![index];

                              return TodoCard(
                                docId: singleData['doc_id'],
                                groupId: singleData['group_id'],
                                groupName: singleData['group_name'],
                                groupIcon: singleData['icon'],
                                complete: singleData['complete'] ?? false,
                                content: singleData['content'],
                                  finished: singleData['finished'],
                                type: singleData['type'],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Expanded(
                    child: Center(child: CustomProgressIndicator()));
              }
            })
      ],
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
    });
  }
}
