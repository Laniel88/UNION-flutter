import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:union/component/component/error_snackbar.dart';
import 'package:union/component/component/group_text_form.dart';
import 'package:union/component/const/colors.dart';

class JoinGroup extends StatefulWidget {
  const JoinGroup({super.key});

  @override
  State<JoinGroup> createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_BLACK(30),
      body: SafeArea(
        top: true,
        bottom: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 6 / 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _Header(onPressed: () {
                    Navigator.of(context).pop();
                  }),
                  SizedBox(height: 20),
                  _Input(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onPressed;
  const _Header({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
            size: 24,
          ),
          splashRadius: 10,
          padding: EdgeInsets.zero,
        ),
        const Spacer(),
        const Text(
          'JOIN UNION GROUP',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        const SizedBox(width: 50)
      ],
    );
  }
}

class _Input extends StatefulWidget {
  const _Input({Key? key}) : super(key: key);

  @override
  State<_Input> createState() => _InputState();
}

class _InputState extends State<_Input> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();
  bool isLoading = false;
  bool joined = false;

  @override
  Widget build(BuildContext context) {
    String currentMember = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentMember)
            .snapshots(),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GroupTextFormField(
                  controller: idController,
                  title: 'GROUP ID',
                  prefix: '@',
                  onChanged: (_) {},
                ),
                GroupTextFormField(
                  controller: pwdController,
                  title: 'GROUP PASSWORD',
                  obscureText: true,
                  onChanged: (_) {},
                ),
                // Text('IMAGE (DUMMY)'),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 30),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            try {
                              firebaseJoinGroup(currentMember, snapshot);
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.of(context).pop();
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(errorSnackBar(e.toString()));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Color.fromARGB(255, 58, 51, 76),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
                          child: const Text(
                            'JOIN GROUP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          );
        });
  }

  firebaseJoinGroup(String currentMember, snapshot) async {
    setState(() {
      isLoading = true;
    });

    final groupId = idController.text;
    final groupPwd = pwdController.text;
    late List memberList;

    final joinSucess = await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .get()
        .then((data) {
      if (!data.exists) return false;
      if (data.data()!["password"] != groupPwd) return false;
      memberList = data.data()!["member"];
      if (memberList.contains(currentMember)) return false;
      memberList = memberList..add(currentMember);
      return true;
    });

    if (joinSucess == false) return;

    FirebaseFirestore.instance.collection("groups").doc(groupId).update({
      "member": memberList,
    }).catchError((error) {
      return;
    });
    // add group to userdata
    List<dynamic> groupList = snapshot.data['groups'];
    if (!groupList.contains(idController.text)) {
      groupList = groupList..add(idController.text);
    }
    FirebaseFirestore.instance.collection("users").doc(currentMember).update({
      'groups': groupList,
    }).catchError((error) {
      return;
    });
    joined = true;
  }
}
