import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union/component/const/colors.dart';
import 'package:union/view/login/login_picker.dart';
import 'package:union/view/root/group_screen.dart';
import 'package:union/view/root/home_screen_mid.dart';
import 'package:union/view/root/overall_screen.dart';

import '../../component/provider/drag_format.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller;

  int index = 0;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 3, vsync: this);
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: Scaffold(
                backgroundColor: COLOR_BLACK(20),
                bottomNavigationBar: BottomNavigationBar(
                  iconSize: 25,
                  backgroundColor: COLOR_BLACK(30),
                  showSelectedLabels: true,
                  selectedFontSize: 11,
                  showUnselectedLabels: false,
                  onTap: (int index) {
                    controller.animateTo(index);
                  },
                  currentIndex: index,
                  items: [
                    BottomNavigationBarItem(
                      icon: ImageIcon(
                        AssetImage('asset/img/UNION_logo_icon.jpeg'),
                      ),
                      label: 'UNION',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.group_outlined),
                      label: 'GROUPS',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.menu),
                      label: 'OVERALL',
                    ),
                  ],
                  selectedItemColor: Colors.white,
                  unselectedItemColor: COLOR_GRAY_MID,
                ),
                body: SafeArea(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller,
                    children: [
                      MultiProvider(
                        providers: [
                          ChangeNotifierProvider(create: (_) => DragFormat())
                        ],
                        child: const HomeScreen(),
                      ),
                      const GroupScreen(),
                      OverallScreen(),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return LoginPicker();
          }
        });
  }
}
