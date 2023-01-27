import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<String>> getUsername(List idList) async {
  List<String> userList = [];
  for (var id in idList) {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get()
        .then((data) {
      userList.add(data.data()?['user_name'] ?? '');
    });
  }
  return userList;
}
