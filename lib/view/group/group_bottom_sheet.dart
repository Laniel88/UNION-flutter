import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:union/component/const/colors.dart';

class GroupBottomSheet extends StatefulWidget {
  final String groupId;
  GroupBottomSheet({
    required this.groupId,
    super.key,
  });

  @override
  State<GroupBottomSheet> createState() => _GroupBottomSheetState();
}

class _GroupBottomSheetState extends State<GroupBottomSheet> {
  late DateTime todoDateTime;
  late String todoContent;
  int todoType = 0;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: COLOR_BLACK(50),
      height: 400,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'ADD TODO',
                style: TextStyle(
                    color: COLOR_GRAY_LIGHT, fontSize: 15, fontFamily: 'Lato'),
              ),
            ),
            const SizedBox(
                height: 23,
                child: Divider(color: COLOR_GRAY_LIGHT, thickness: 0.5)),
            // DATE
            SizedBox(
              height: 80,
              child: Row(
                children: [
                  const Text(
                    'DATE ',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontFamily: 'Lato'),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: CupertinoTheme(
                        data: const CupertinoThemeData(
                            brightness: Brightness.dark),
                        child: CupertinoDatePicker(
                          minimumYear: 2000,
                          maximumYear: DateTime.now().year + 50,
                          initialDateTime: DateTime.now(),
                          maximumDate: DateTime.utc(2030, 12, 31),
                          onDateTimeChanged: (DateTime selected) {
                            todoDateTime = selected;
                          },
                          mode: CupertinoDatePickerMode.date,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            SizedBox(
              height: 80,
              child: Row(
                children: [
                  Text(
                    'TEXT ',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontFamily: 'Lato'),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: TextFormField(
                          cursorColor: COLOR_GRAY_MID,
                          onChanged: (context) {
                            todoContent = context;
                          },
                          obscureText: false,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            filled: false,
                            focusColor: Colors.white,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: COLOR_GRAY_LIGHT,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            // Type
            SizedBox(
              height: 80,
              child: Row(
                children: [
                  const Text(
                    'TYPE ',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontFamily: 'Lato'),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: CupertinoTheme(
                          data: const CupertinoThemeData(
                              brightness: Brightness.dark),
                          child: CupertinoPicker(
                            scrollController:
                                FixedExtentScrollController(initialItem: 1),
                            itemExtent: 28,
                            children: const [
                              Text(
                                '회합',
                                style: TextStyle(color: CHECK_1),
                              ),
                              Text(
                                '과제',
                                style: TextStyle(color: CHECK_2),
                              ),
                              Text(
                                'ETC',
                                style: TextStyle(color: CHECK_3),
                              ),
                            ],
                            onSelectedItemChanged: (index) {
                              todoType = index;
                            },
                          )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            !loading
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        addTodo();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Color.fromARGB(255, 109, 109, 109),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'ADD TODO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 170.0),
                    child: SizedBox(
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.8,
                            color: Color.fromARGB(255, 130, 90, 143))),
                  ),
          ],
        ),
      ),
    );
  }

  addTodo() async {
    try {
      String doc = DateFormat('yyyyMMddHHmmss_').format(DateTime.now()) +
          FirebaseAuth.instance.currentUser!.uid;

      // ignore: unused_local_variable
      final groupResponse = await FirebaseFirestore.instance
          .collection('_${widget.groupId}')
          .doc(doc)
          .set({
        "date": Timestamp.fromDate(todoDateTime),
        "content": todoContent,
        "type": todoType,
        "finished": [],
      });
    } catch (e) {
      print('error writing todo - $e');
    }
  }
}
