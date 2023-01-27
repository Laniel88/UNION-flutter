import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:union/component/const/colors.dart';
import 'package:union/component/component/empty_space.dart';
import 'package:union/component/component/logo.dart';
import 'package:union/component/provider/auth_provider.dart';
import 'package:union/view/common/checkerror_screen.dart';
import 'package:union/view/login/sign_in.dart';
import 'package:union/view/login/sign_up.dart';
import 'package:union/view/root/root_tab.dart';

class LoginPicker extends StatefulWidget {
  const LoginPicker({super.key});
  @override
  State<LoginPicker> createState() => _LoginPickerState();
}

class _LoginPickerState extends State<LoginPicker> {
  late AuthProvider apModel;
  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Consumer<AuthProvider>(
              builder: ((context, model, _) {
                apModel = model;
                return Scaffold(
                  backgroundColor: COLOR_BACKGROUND,
                  body: SafeArea(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: mediaWidth / 9),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(flex: 16),
                        const LogoFull(),
                        const Spacer(flex: 3),
                        _UnionLoginButtons(
                          onPressedSignIn: onPressedSignIn,
                          onPressedCreateAccount: onPressedCreateAccount,
                        ),
                        const Spacer(),
                        const _Cautions(),
                        const Spacer(),
                        const Divider(color: COLOR_GRAY_LIGHT, thickness: 1),
                        const Spacer(),
                        _GoogleLoginButton(
                          onPressed: () {
                            model.signInWithGoogle();
                          },
                        ),
                        const Spacer(flex: 14)
                      ],
                    ),
                  )),
                );
              }),
            );
          } else {
            return const CheckErrorScreen(
              route: RootTab(),
              backgroundColor: COLOR_BACKGROUND,
              sucess: true,
            );
          }
        });
  }

  //  ============= onPressed functions ============== //

  void onPressedSignIn() {
    apModel.setAuthType(AuthType.signIn);
    Navigator.of(context).pushReplacement(
      PageTransition(
        child: SignIn(authProvider: apModel),
        type: PageTransitionType.fade,
        curve: Curves.bounceInOut,
      ),
    );
  }

  void onPressedCreateAccount() {
    apModel.setAuthType(AuthType.signUp);
    Navigator.of(context).pushReplacement(
      PageTransition(
        child: SignUp(authProvider: apModel),
        type: PageTransitionType.fade,
        curve: Curves.bounceInOut,
      ),
    );
  }
}

/// ***************************************************** ///

class _UnionLoginButtons extends StatelessWidget {
  final VoidCallback onPressedSignIn;
  final VoidCallback onPressedCreateAccount;

  const _UnionLoginButtons({
    required this.onPressedSignIn,
    required this.onPressedCreateAccount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _centerButton(onPressedSignIn, 'SIGN IN'),
        const EmptySpace(size: 1 / 25),
        _centerButton(onPressedCreateAccount, 'CREATE ACCOUNT'),
      ],
    );
  }

  ElevatedButton _centerButton(VoidCallback onPressed, String text) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Color.fromARGB(255, 73, 73, 81),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13.5,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Cautions extends StatelessWidget {
  const _Cautions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var text = RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(
          fontFamily: 'Lato',
          fontSize: 10.0,
          color: Colors.white,
          fontWeight: FontWeight.w300,
          height: 1.7,
        ),
        children: <TextSpan>[
          TextSpan(
              text: 'Notice that by creating an account or signing in,'
                  '\nyou agree and accept our'),
          TextSpan(
              text: ' Terms of Service',
              style: TextStyle(fontWeight: FontWeight.w400)),
          TextSpan(text: ' and '),
          TextSpan(
              text: 'Privacy Policy.',
              style: TextStyle(fontWeight: FontWeight.w400)),
        ],
      ),
    );
    return SizedBox(child: text);
  }
}

class _GoogleLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _GoogleLoginButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/Google_logo.png',
              height: 18,
            ),
            const SizedBox(
              width: 11,
            ),
            const Text(
              'Continue with Google',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ));
  }
}
