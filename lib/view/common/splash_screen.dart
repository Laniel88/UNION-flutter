import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:union/component/const/colors.dart';
import 'package:union/component/component/logo.dart';
import 'package:union/view/login/login_picker.dart';

class SplashScreen extends StatefulWidget {
  final Widget targetWidget;
  const SplashScreen({required this.targetWidget, Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.initState();
    // TODO : create auto-login algorithm
    Timer(const Duration(milliseconds: 1300), () {
      Navigator.of(context).pushAndRemoveUntil(
        PageTransition(
          child: widget.targetWidget,
          type: PageTransitionType.scale,
          alignment: Alignment.bottomCenter,
          curve: Curves.easeInOutCirc,
          duration: const Duration(milliseconds: 400),
        ),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Expanded(
                flex: 2,
                child: SizedBox(),
              ),
              Expanded(
                flex: 18,
                child: LogoImg(size: 27),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  '@HYU_EOS \n2022',
                  style: TextStyle(
                    color: COLOR_GRAY_DARK,
                    fontFamily: 'RobotoMono',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
