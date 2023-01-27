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

class AddGroup extends StatefulWidget {
  const AddGroup({super.key});

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
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
                  _Input(
                    idValid: true,
                  ),
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
          'CREATE UNION GROUP',
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
  final bool idValid;

  _Input({required this.idValid, Key? key}) : super(key: key);

  @override
  State<_Input> createState() => _InputState();
}

class _InputState extends State<_Input> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();
  bool isLoading = false;
  late Map iconData;

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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      imageProcess(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Color.fromARGB(255, 58, 58, 58),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: const Text(
                      'UPLOAD GROUP IMAGE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: () async {
                      var icon = await FlutterIconPicker.showIconPicker(context,
                          backgroundColor: COLOR_BLACK(40),
                          iconColor: Colors.white,
                          closeChild: const Text(
                            'Close',
                            textScaleFactor: 1.25,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          searchIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ));
                      iconData = icon != null
                          ? serializeIcon(icon)!
                          : {"pack": "material", "key": "group_outlined"};
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Color.fromARGB(255, 58, 58, 58),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: const Text(
                      'SELECT GROUP ICON',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                GroupTextFormField(
                  controller: nameController,
                  title: 'NAME',
                  onChanged: (_) {},
                ),
                GroupTextFormField(
                  controller: idController,
                  title: 'GROUP ID',
                  prefix: '@',
                  onChanged: (_) {},
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: widget.idValid
                      ? ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Color.fromARGB(255, 46, 44, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text(
                            'CHECK ID VALIDITY',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : const Center(
                          child: Text(
                            'VALID',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                ),
                GroupTextFormField(
                  controller: descriptionController,
                  title: 'DESCRIPTION',
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
                  padding: const EdgeInsets.all(15.0),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            try {
                              sendGroupOnFirebase(currentMember, snapshot);
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.of(context).pop();
                            } catch (e) {
                              errorSnackBar(e.toString());
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
                            'CREATE GROUP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                )
              ],
            ),
          );
        });
  }

  File? _photoFile;

  sendGroupOnFirebase(String currentMember, snapshot) async {
    setState(() {
      isLoading = true;
    });

    uploadImage();

    List<dynamic> groupList = snapshot.data['groups'];
    groupList = groupList..add(idController.text);

    // create group document and add currentUser to member & admin_member
    final groupResponse = await FirebaseFirestore.instance
        .collection("groups")
        .doc(idController.text)
        .set({
      "name": nameController.text,
      "group_id": idController.text,
      "group_icon": iconData,
      "description": descriptionController.text,
      "tasks": 0,
      "password": pwdController.text,
      "member": [currentMember],
      "admin_member": [currentMember],
    });

    await FirebaseFirestore.instance.collection('_${idController.text}');

    // add group to userdata
    final userResponse = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentMember)
        .update({
      'groups': groupList,
    }).catchError((error) {
      print("error");
    });
  }

  imageProcess(BuildContext context) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      // check if image is picked
      setState(() {
        if (image != null) {
          _photoFile = File(image.path);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(errorSnackBar('No image selected'));
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  uploadImage() async {
    if (_photoFile == null) {
      return;
    }
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('group_image/')
          .child(idController.text);
      await ref
          .putFile(_photoFile!)
          .whenComplete(() => print('upload finished!'));
    } catch (e) {
      print(e.toString());
    }
  }
}
