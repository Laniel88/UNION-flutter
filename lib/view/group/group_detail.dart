import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union/component/component/calander.dart';
import 'package:union/component/component/custom_progress_indicator.dart';
import 'package:union/component/component/todo_banner_extra.dart';
import 'package:union/component/component/todo_card_only.dart';
import 'package:union/component/const/colors.dart';
import 'package:union/component/const/todo_type.dart';
import 'package:union/component/provider/drag_format.dart';
import 'package:union/component/provider/month_picker.dart';
import 'package:union/view/group/group_bottom_sheet.dart';
import 'package:union/view/group/load_group_todo.dart';

class GroupDetailScreen extends StatefulWidget {
  final String id;
  final String name;
  final Icon icon;
  const GroupDetailScreen({
    required this.id,
    required this.name,
    required this.icon,
    super.key,
  });

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  int month = DateTime.now().month;

  late DateTime focusedDay = selectedDay;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DragFormat()),
        ChangeNotifierProvider(create: (_) => MonthPicker()),
      ],
      child: Scaffold(
        backgroundColor: COLOR_BLACK(25),
        body: SafeArea(
          child: Column(children: [
            _Header(
              name: widget.name,
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: widget.icon,
            ),
            const SizedBox(height: 15),
            _Body(
              groupId: widget.id,
              onDaySelected: onDaySelected,
              selectedDay: selectedDay,
            ),
          ]),
        ),
      ),
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
    });
  }
}

class _Header extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;
  final Icon icon;
  const _Header({
    required this.name,
    required this.onPressed,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            onPressed: onPressed,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 15,
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
              size: 25,
            ),
          ),
          Expanded(child: SizedBox()),
          icon,
          Text(
            name,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w600),
          ),
          Expanded(child: SizedBox()),
          SizedBox(
            width: 35,
            child: Text(
              '${Provider.of<MonthPicker>(context).monthPicker}月',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final groupId;
  final onDaySelected;
  final selectedDay;
  const _Body({
    required this.groupId,
    required this.onDaySelected,
    this.selectedDay,
  });

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  var scroll = ScrollController(keepScrollOffset: false);

  int? todoCnt;

  Widget buildAddBottomSheet(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: GroupBottomSheet(
        groupId: widget.groupId,
      ),
    );
  }

  Widget buildGroupBottomSheet(BuildContext context) {
    return Container(
      color: COLOR_BLACK(50),
      height: MediaQuery.of(context).size.height * 3 / 7,
    );
  }

  @override
  Widget build(BuildContext context) {
    DragFormat dragFormat = Provider.of<DragFormat>(context, listen: false);

    return Expanded(
      child: Column(
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
              selectedDay: widget.selectedDay,
              onDaySelected: widget.onDaySelected,
              headerVisible: false,
              onPageChanged: (date) {
                MonthPicker monthPicker =
                    Provider.of<MonthPicker>(context, listen: false);
                monthPicker.monthChanged(date.month);
              },
            ),
          ),
          FutureBuilder<List<Map>>(
              future: loadSingleGroupTodo(widget.selectedDay, widget.groupId),
              builder: (context, snapshot) {
                todoCnt = snapshot.data?.length;
                if (snapshot.hasData) {
                  return Expanded(
                    child: Column(
                      children: [
                        TodoBannerExtra(
                          selectedDay: widget.selectedDay,
                          scheduleCount: todoCnt,
                          groupPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: buildGroupBottomSheet);
                          },
                          addPressed: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: buildAddBottomSheet);
                          },
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ListView.separated(
                              controller: scroll,
                              itemCount: todoCnt ?? 0,
                              separatorBuilder: ((context, index) =>
                                  const SizedBox(height: 10)),
                              itemBuilder: (context, index) {
                                if (snapshot.data == null)
                                  return const SizedBox();
                                Map singleData = snapshot.data![index];
                                return TodoCardOnly(
                                  docId: singleData['doc_id'],
                                  groupId: singleData['group_id'],
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
      ),
    );
  }
}
