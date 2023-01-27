import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Serialization/iconDataSerialization.dart';
import 'package:page_transition/page_transition.dart';
import 'package:union/component/component/custom_progress_indicator.dart';
import 'package:union/component/component/empty_space.dart';
import 'package:union/component/component/get_username.dart';
import 'package:union/component/component/group_card.dart';
import 'package:union/component/const/colors.dart';
import 'package:union/view/group/add_group.dart';
import 'package:union/view/group/group_detail.dart';
import 'package:union/view/group/join_group.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, userSnapshot) {
          return Column(
            children: [
              _GerneralBanner(
                onPressedAdd: () {
                  Navigator.of(context).push(
                    PageTransition(
                      child: const AddGroup(),
                      type: PageTransitionType.fade,
                      curve: Curves.bounceInOut,
                      duration: const Duration(milliseconds: 200),
                    ),
                  );
                },
                onPressedJoin: () {
                  Navigator.of(context).push(
                    PageTransition(
                      child: const JoinGroup(),
                      type: PageTransitionType.fade,
                      curve: Curves.bounceInOut,
                      duration: const Duration(milliseconds: 200),
                    ),
                  );
                },
              ),
              Expanded(
                child: _GeneralCards(
                  groups: userSnapshot.data?['groups'] ?? [],
                ),
              ),
            ],
          );
        });
  }
}

class _GerneralBanner extends StatelessWidget {
  final void Function()? onPressedJoin;
  final void Function()? onPressedAdd;
  const _GerneralBanner({
    required this.onPressedJoin,
    required this.onPressedAdd,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0),
      child: Column(
        children: [
          SizedBox(
              height: 21,
              child: Divider(color: COLOR_GRAY_LIGHT, thickness: 0.5)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ImageIcon(
                  AssetImage('asset/img/UNION_logo_icon.jpeg'),
                  color: Colors.white,
                  size: 25,
                ),
                Text(
                  ' UNI-ON',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontFamily: 'Kodchasan',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(child: SizedBox()),
                IconButton(
                  onPressed: onPressedJoin,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  splashRadius: 15,
                  iconSize: 25,
                  icon: const Icon(
                    Icons.assignment_ind_outlined,
                    color: Colors.greenAccent,
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: onPressedAdd,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  splashRadius: 15,
                  iconSize: 25,
                  icon: const Icon(
                    Icons.add,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
              height: 22,
              child: Divider(color: COLOR_GRAY_LIGHT, thickness: 0.5)),
        ],
      ),
    );
  }
}

class _GeneralCards extends StatelessWidget {
  final List<dynamic> groups;
  const _GeneralCards({required this.groups, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('groups').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CustomProgressIndicator();
          }

          final allGroups = snapshot.data!.docs;
          List<Widget> groupCards = [];

          for (var group in allGroups) {
            if (groups.contains(group.data()['group_id'])) {
              final groupWidget = GroupCard(
                id: group.data()['group_id'],
                description: group.data()['description'],
                groupIcon:
                    deserializeIcon(group.data()['group_icon']) ?? Icons.group,
                groupName: group.data()['name'],
                favorite: false,
                member: group.data()['member'].length,
                tasks: group.data()['tasks'],
                adminMembers: group.data()['admin_member'],
                admin: group
                    .data()['admin_member']
                    .contains(FirebaseAuth.instance.currentUser!.uid),
                onTapAdmin: (_) {},
              );

              groupCards.add(groupWidget);
              groupCards.add(SizedBox(height: 8));
            }
          }

          return ListView(
            shrinkWrap: true,
            children: groupCards,
          );
        });
  }
}
