import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:union/component/component/login_text_form.dart';
import 'package:union/component/const/colors.dart';
import 'package:union/component/component/logo.dart';
import 'package:union/component/provider/auth_provider.dart';
import 'package:union/view/common/checkerror_screen.dart';
import 'package:union/view/login/login_picker.dart';
import 'package:union/view/root/root_tab.dart';
import 'package:union/view/login/sign_up.dart';

class SignIn extends StatefulWidget {
  final AuthProvider authProvider;
  const SignIn({
    required this.authProvider,
    super.key,
  });

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String? emailField;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              backgroundColor: COLOR_BACKGROUND,
              body: SafeArea(
                top: true,
                bottom: false,
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 3 / 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _Header(onPressed: () {
                          Navigator.of(context).pushReplacement(
                            PageTransition(
                              child: const LoginPicker(),
                              type: PageTransitionType.fade,
                              curve: Curves.bounceInOut,
                            ),
                          );
                        }),
                        const Spacer(flex: 10),
                        const LogoFull(),
                        const Spacer(flex: 2),
                        _InputField(
                          authProvider: widget.authProvider,
                          onChangedEmail: onChangedEmail,
                          onChangedPassword: onChangedPassword,
                        ),
                        const Spacer(flex: 3),
                        _ButtonSignIn(onPressedSignIn: onPressedSignIn),
                        const SizedBox(height: 15),
                        _Footer(onPressedMoveToSignUp: onPressedMoveToSignUp),
                        const Spacer(flex: 5),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const CheckErrorScreen(
              backgroundColor: COLOR_BACKGROUND,
              route: RootTab(),
              sucess: true,
            );
          }
        });
  }

  //  ============= onChanged functions ============== //

  void onChangedEmail(String value) {
    emailField = value;
    if (emailField == null || emailField == '') {
      widget.authProvider.setFieldState(true);
    } else {
      widget.authProvider.setFieldState(false);
    }
  }

  void onChangedPassword(String value) {}

  //  ============= onPressed functions ============== //

  void onPressedSignIn() {
    widget.authProvider.signIn();
  }

  void onPressedMoveToSignUp() {
    widget.authProvider.setFieldState(true);
    widget.authProvider.setAuthType(AuthType.signUp);
    Navigator.of(context).pushReplacement(
      PageTransition(
        child: SignUp(
          authProvider: widget.authProvider,
        ),
        type: PageTransitionType.fade,
        curve: Curves.bounceInOut,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onPressed;
  const _Header({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Icons.arrow_back_ios_new_outlined,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final AuthProvider? authProvider;
  final ValueChanged<String>? onChangedEmail;
  final ValueChanged<String>? onChangedPassword;

  const _InputField({
    required this.onChangedEmail,
    required this.onChangedPassword,
    this.authProvider,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoginTextFormField(
            controller: authProvider?.signInEmailController,
            hintText: 'Email Address',
            onChanged: onChangedEmail,
          ),
          const SizedBox(height: 10.0),
          LoginTextFormField(
            controller: authProvider?.signInPasswordController,
            hintText: 'Password',
            onChanged: onChangedPassword,
            obscureText: true,
          ),
          const SizedBox(height: 10.0),
          const Text(
            'Forgot password?',
            textAlign: TextAlign.right,
            style: TextStyle(
                color: COLOR_GRAY_LIGHT, fontSize: 10, fontFamily: 'Lato'),
          )
        ],
      ),
    );
  }
}

class _ButtonSignIn extends StatelessWidget {
  final VoidCallback onPressedSignIn;
  const _ButtonSignIn({required this.onPressedSignIn, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 7),
      child: ElevatedButton(
          onPressed: onPressedSignIn,
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: const Color.fromARGB(255, 73, 73, 81),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 11)),
          child: const Text(
            'SIGN IN',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w700,
            ),
          )),
    );
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback onPressedMoveToSignUp;
  const _Footer({required this.onPressedMoveToSignUp, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(
            color: COLOR_GRAY_LIGHT,
            fontSize: 13.0,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w400,
          ),
        ),
        TextButton(
          onPressed: onPressedMoveToSignUp,
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.all(1),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            '  Sign up  ',
            style: TextStyle(
              color: COLOR_MAIN_6,
              fontSize: 13.0,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w900,
            ),
          ),
        )
      ],
    );
  }
}
