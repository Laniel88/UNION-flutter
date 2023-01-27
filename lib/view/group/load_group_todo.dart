import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Serialization/iconDataSerialization.dart';
import 'package:union/component/const/todo_type.dart';

Future<List<Map>> loadSingleGroupTodo(
    DateTime selectedDate, String groupId) async {
  List<Map> data = [];

  late final List groupList;
  await FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((data) {
    groupList = data.data()?['groups'] ?? [];
  });

  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('_$groupId').get();
  print(snapshot.docs);

  for (var doc in snapshot.docs) {
    if (doc['date'] == null) continue;
    Timestamp timestamp = doc['date'];
    DateTime date = timestamp.toDate();
    if (date.isSameDate(selectedDate)) {
      data.add({
        "doc_id": doc.reference.id,
         "group_id": groupId,
        "content": doc['content'],
        "finished": doc['finished'],
        "complete":
            doc['finished'].contains(FirebaseAuth.instance.currentUser!.uid),
        "type": convertTodoType(doc['type']),
      });
    }
  }

  return data;
}

Future<List<Map>> loadGroupTodo(DateTime selectedDate) async {
  List<Map> data = [];

  late final List groupList;
  await FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((data) {
    groupList = data.data()?['groups'] ?? [];
  });

  for (var group in groupList) {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('_$group').get();

    IconData? icon;
    String? groupName;
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(group)
        .get()
        .then((data) {
      icon = deserializeIcon(data.data()!['group_icon']);
      groupName = data.data()!['name'];
    });

    for (var doc in snapshot.docs) {
      if (doc['date'] == null) continue;
      Timestamp timestamp = doc['date'];
      DateTime date = timestamp.toDate();
      if (date.isSameDate(selectedDate)) {
        data.add({
          "doc_id": doc.reference.id,
          "group_name": groupName ?? '',
          "group_id": group,
          "icon": icon ?? Icons.group,
          "content": doc['content'],
          "finished": doc['finished'],
          "complete":
              doc['finished'].contains(FirebaseAuth.instance.currentUser!.uid),
          "type": convertTodoType(doc['type']),
        });
      }
    }
  }
  return data;
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
