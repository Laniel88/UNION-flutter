import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:union/component/component/avatar_stack_form.dart';
import 'package:union/component/const/colors.dart';
import 'package:union/component/const/todo_type.dart';

class TodoCard extends StatefulWidget {
  bool complete;
  final String docId;
  final String groupId;
  final IconData groupIcon;
  final String groupName;
  final String content;
  final List finished;
  final TodoType type;

  TodoCard({
    required this.complete,
    required this.groupIcon,
    required this.docId,
    required this.groupId,
    required this.groupName,
    required this.content,
    required this.finished,
    this.type = TodoType.etc,
    Key? key,
  }) : super(key: key);

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    var finishedList = widget.finished;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: COLOR_BLACK(35),
        ),
        color: COLOR_BLACK(35),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(3, 11, 18, 11),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(width: 5.0),
              _Check(
                value: widget.complete,
                type: widget.type,
                onChecked: (changed) {
                  syncChangedData(changed!);
                  setState(() {
                    widget.complete = changed;
                    if (changed) {
                      finishedList.add(FirebaseAuth.instance.currentUser!.uid);
                    } else {
                      finishedList
                          .remove(FirebaseAuth.instance.currentUser!.uid);
                    }
                  });
                },
              ),
              const SizedBox(width: 6.0),
              _Content(
                groupIcon: widget.groupIcon,
                groupName: widget.groupName,
                content: widget.content,
              ),
              const SizedBox(width: 16.0),
              _Avatar(
                finished: finishedList,
              ),
            ],
          ),
        ),
      ),
    );
  }

  syncChangedData(bool value) async {
    late List finishedList;

    await FirebaseFirestore.instance
        .collection('_${widget.groupId}')
        .doc(widget.docId)
        .get()
        .then((data) {
      finishedList = data.data()?['finished'] ?? [];
    });
    if (value == true) {
      finishedList.add(FirebaseAuth.instance.currentUser!.uid);
    } else {
      finishedList.remove(FirebaseAuth.instance.currentUser!.uid);
    }

    await FirebaseFirestore.instance
        .collection('_${widget.groupId}')
        .doc(widget.docId)
        .update({
      'finished': finishedList,
    });
  }
}

class _Check extends StatelessWidget {
  final bool value;
  final TodoType type;
  final void Function(bool?)? onChecked;
  const _Check({
    required this.value,
    required this.type,
    required this.onChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        SizedBox(
          width: 30,
          height: 30,
          child: Transform.scale(
            scale: 1.45,
            child: Checkbox(
              activeColor: typeToColor(type),
              checkColor: Colors.white,
              value: value,
              onChanged: onChecked,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
              side: BorderSide(width: 2.5, color: typeToColor(type)),
            ),
          ),
        ),
        const SizedBox(height: 1),
        Text(
          typeToString(type),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: typeToColor(type),
            fontSize: 11,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  String typeToString(TodoType type) {
    switch (type) {
      case TodoType.meetings:
        return '회합';
      case TodoType.assignment:
        return '과제';
      default:
        return 'ETC';
    }
  }

  Color typeToColor(TodoType type) {
    switch (type) {
      case TodoType.meetings:
        return CHECK_1;
      case TodoType.assignment:
        return CHECK_2;
      default:
        return CHECK_3;
    }
  }
}

class _Content extends StatelessWidget {
  final IconData groupIcon;
  final String groupName;
  final String content;

  const _Content({
    required this.groupIcon,
    required this.groupName,
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                groupIcon,
                size: 18,
                color: Colors.grey,
              ),
              Text(
                ' $groupName',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.5,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 5, 0, 0),
            child: Text(
              content,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final List finished;

  const _Avatar({
    required this.finished,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ImageProvider<Object>>>(
        future: getAvatars(finished),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: AvatarStackForm(
                width: 100,
                borderColor: Colors.grey,
                infoColor: COLOR_MAIN_1,
                avatars: snapshot.data!,
              ),
            );
          } else {
            return SizedBox();
          }
        });
  }

  Future<List<ImageProvider<Object>>> getAvatars(List finished) async {
    List<ImageProvider<Object>> avatars = [];
    for (var id in finished) {
      final imgUrl = await FirebaseStorage.instance
          .ref('profile_image')
          .child(id)
          .getDownloadURL();
      avatars.add(Image.network(imgUrl).image);
    }
    return avatars;
  }
}