import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:union/component/component/custom_progress_indicator.dart';
import 'package:union/component/const/colors.dart';
import 'package:union/component/provider/auth_provider.dart';
import 'package:union/view/login/login_picker.dart';

class OverallScreen extends StatefulWidget {
  OverallScreen({super.key});

  @override
  State<OverallScreen> createState() => _OverallScreenState();
}

class _OverallScreenState extends State<OverallScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  Widget avatar = Container(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (contex, model, _) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CustomProgressIndicator();
            } else {
              downloadImg();
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 17, horizontal: 11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Profile(
                      userName: snapshot.data!['user_name'],
                      avatar: avatar,
                      logout: () {
                        model.logOut();
                      },
                    ),
                    const SizedBox(height: 30),
                    const _GeneralSettings(),
                    const SizedBox(height: 30),
                    const _ETC()
                  ],
                ),
              );
            }
          });
    });
  }

  downloadImg() async {
    try {
      final imgUrl = await FirebaseStorage.instance
          .ref('profile_image')
          .child(uid)
          .getDownloadURL();
      setState(() {
        avatar = Image.network(imgUrl);
      });
    } catch (e) {
      // debugPrint(e.toString());
    }
  }
}

class _Profile extends StatelessWidget {
  final String userName;
  final Widget? avatar;
  final void Function()? logout;
  const _Profile({
    required this.logout,
    required this.userName,
    required this.avatar,
  });
// iwG4pV56XeYWb8E6PKGwdeOh1HO2
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 35,
            child: ClipOval(
              child: avatar,
            ),
          ),
          const SizedBox(width: 17),
          Text(
            userName,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
          IconButton(
              onPressed: logout,
              splashRadius: 0.5,
              iconSize: 19,
              padding: const EdgeInsets.only(left: 10.0),
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              )),
          const Expanded(child: SizedBox()),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Edit profile',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.5,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _GeneralSettings extends StatelessWidget {
  const _GeneralSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'General Settings',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 19),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Theme (Closed)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                ),
              ),
              IconButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 0.5,
                  iconSize: 19,
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ))
            ],
          ),
          const SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Alarm (Closed)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                ),
              ),
              IconButton(
                  onPressed: () {},
                  splashRadius: 0.5,
                  iconSize: 19,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ))
            ],
          )
        ],
      ),
    );
  }
}

class _ETC extends StatelessWidget {
  const _ETC({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ETC',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 19),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'App version',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '0.9.0',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 19,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Inquiry',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'laniel8177@gmail.com',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 19,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'License',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      PageTransition(
                        child: license(),
                        type: PageTransitionType.fade,
                        curve: Curves.bounceInOut,
                      ),
                    );
                  },
                  splashRadius: 0.5,
                  iconSize: 19,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ))
            ],
          )
        ],
      ),
    );
  }

  Widget license() {
    var whiteText = const TextStyle(
      color: Colors.white,
    );
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(color: COLOR_BLACK(20)),
        cardColor: COLOR_BACKGROUND,
      ),
      child: const LicensePage(),
    );
  }
}
