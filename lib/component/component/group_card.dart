import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';
import 'package:union/component/component/admin_button.dart';
import 'package:union/component/component/custom_progress_indicator.dart';
import 'package:union/component/component/get_username.dart';
import 'package:union/component/const/colors.dart';
import 'package:union/view/group/group_detail.dart';

class GroupCard extends StatelessWidget {
  final String id;
  final String description;
  final IconData groupIcon;
  final String groupName;
  final bool favorite;
  final bool admin;
  final int member;
  final int tasks;
  final List<dynamic> adminMembers;
  void Function(BuildContext)? onTapAdmin;

  GroupCard({
    required this.id,
    required this.description,
    required this.groupIcon,
    required this.groupName,
    required this.favorite,
    required this.member,
    required this.tasks,
    required this.adminMembers,
    required this.onTapAdmin,
    this.admin = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration = BoxDecoration(
      border: Border.all(
        width: 0,
      ),
      color: COLOR_BLACK(35),
      borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(15), right: Radius.circular(10)),
    );

    return Slidable(
      enabled: admin,
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
              onPressed: onTapAdmin,
              backgroundColor: const Color(0xFFBDB76B),
              foregroundColor: Colors.black54,
              icon: Icons.admin_panel_settings,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              label: 'ADMIN')
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              PageTransition(
                child: GroupDetailScreen(
                  name: groupName,
                  id: id,
                  icon: Icon(
                    groupIcon,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
                type: PageTransitionType.fade,
                curve: Curves.bounceInOut,
                duration: const Duration(milliseconds: 100),
              ),
            );
          },
          child: Container(
            decoration: decoration,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(11, 15, 10, 15),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Avatar(id: id),
                            const SizedBox(width: 10.0),
                            _Description(
                              groupIcon: groupIcon,
                              groupName: groupName,
                              groupColor: Colors.white,
                              description: description,
                              admin: admin,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        SizedBox(
                          child: _Content(
                            id: id,
                            member: member,
                            tasks: tasks,
                            adminMembers: adminMembers,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<bool>(
                      future: ifFavorite(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return DynamicButton(
                            iconColor: const Color(0xFFFA8072),
                            iconSize: 40,
                            isDynamic: snapshot.data,
                            icon: Icons.favorite,
                            valueChanged: (bool value) {
                              applyFavorite(value);
                            },
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                  const SizedBox(width: 14)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> ifFavorite() async {
    late List favoriteList;
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((data) {
      favoriteList = data.data()?['favorites'] ?? [];
    });
    if (favoriteList.contains(id)) {
      return true;
    } else {
      return false;
    }
  }

  applyFavorite(bool value) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    late List favoriteList;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((data) {
      favoriteList = data.data()?['favorites'] ?? [];
      if (value == true) {
        if (favoriteList.contains(id)) return;
        favoriteList.add(id);
      } else {
        if (!favoriteList.contains(id)) return;
        favoriteList.remove(id);
      }
      FirebaseFirestore.instance.collection("users").doc(uid).update({
        'favorites': favoriteList,
      }).catchError((error) {
        return;
      });
    });
  }
}

class _Avatar extends StatefulWidget {
  final String id;
  _Avatar({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  State<_Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<_Avatar> {
  Widget avatar = Container(color: Colors.white24);

  @override
  Widget build(BuildContext context) {
    groupImg();
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      child: SizedBox(
          width: 40,
          height: 40,
          child: ClipOval(
            child: avatar,
          )),
    );
  }

  groupImg() async {
    try {
      final imgUrl = await FirebaseStorage.instance
          .ref('group_image')
          .child(widget.id)
          .getDownloadURL();
      setState(() {
        avatar = Image.network(imgUrl);
      });
    } catch (e) {
      // debugPrint(e.toString());
    }
  }
}

class _Description extends StatelessWidget {
  final IconData groupIcon;
  final String groupName;
  final Color groupColor;
  final String description;
  final bool admin;

  const _Description({
    required this.groupIcon,
    required this.groupName,
    required this.groupColor,
    required this.description,
    required this.admin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 3),
          Row(children: [
            Icon(
              groupIcon,
              size: 18,
              color: groupColor,
            ),
            Text(
              ' $groupName  ',
              style: TextStyle(
                  color: groupColor,
                  fontSize: 14.3,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w900),
            ),
            Visibility(
              visible: admin,
              child: const Icon(
                Icons.admin_panel_settings,
                size: 16,
                color: Color(0xFFBDB76B),
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(3, 2, 0, 0),
            child: Text(
              description,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontFamily: 'Lato',
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final String id;
  final int member;
  final int tasks;
  final List adminMembers;
  const _Content({
    required this.id,
    required this.member,
    required this.tasks,
    required this.adminMembers,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RichData(
              title: 'id           ',
              data: '@$id',
              width: 250,
            ),
            _RichData(
              title: 'member',
              data: member.toString(),
              width: 250,
            ),
            const SizedBox(height: 5),
            _RichData(
              title: 'tasks     ',
              data: tasks.toString(),
              width: 250,
            ),
            const SizedBox(height: 5),
            FutureBuilder<List>(
                future: getUsername(adminMembers),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return _RichData(
                      title: 'admin    ',
                      data: snapshot.data!.join(', '),
                      width: 250,
                    );
                  } else {
                    return const _RichData(
                      title: 'admin    ',
                      data: 'loading..',
                      width: 250,
                    );
                  }
                }),
          ],
        ));
  }
}

class _RichData extends StatelessWidget {
  final String title;
  final String data;
  final double width;

  const _RichData({
    required this.title,
    required this.data,
    this.width = 150,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      color: COLOR_BLACK(150),
      fontSize: 13,
      fontFamily: 'Kodchasan',
      fontWeight: FontWeight.w600,
    );
    final dataStyle = TextStyle(
      color: COLOR_BLACK(200),
      fontSize: 12,
      fontFamily: 'Kodchasan',
      fontWeight: FontWeight.w800,
    );
    return SizedBox(
      width: width,
      child: RichText(
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          text: '$title  ',
          style: titleStyle,
          children: <TextSpan>[
            TextSpan(text: '$data ', style: dataStyle),
          ],
        ),
      ),
    );
  }
}
