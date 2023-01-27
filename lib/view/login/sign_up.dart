import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:union/component/component/error_snackbar.dart';
import 'package:union/component/component/login_text_form.dart';
import 'package:union/component/const/colors.dart';
import 'package:union/component/component/logo.dart';
import 'package:union/component/provider/auth_provider.dart';
import 'package:union/view/common/checkerror_screen.dart';
import 'package:union/view/login/login_picker.dart';
import 'package:union/view/login/sign_in.dart';
import 'package:union/view/root/root_tab.dart';

class SignUp extends StatefulWidget {
  final AuthProvider authProvider;

  const SignUp({required this.authProvider, super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? emailField;
  String? password;
  String? passwordConfirm;
  bool? ifPasswordConfirmed;

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
                        const Spacer(flex: 5),
                        const LogoFull(),
                        const Spacer(flex: 1),
                        _InputField(
                          authProvider: widget.authProvider,
                          onChangedUsername: onChangedUsername,
                          onChangedEmail: onChangedEmail,
                          onChangedPassword: onChangedPassword,
                          onChangedPasswordConfirm: onChangedPasswordConfirm,
                          ifPasswordConfirmed: ifPasswordConfirmed,
                          imageFunction: () {
                            imageProcess(context);
                          },
                        ),
                        const Spacer(flex: 1),
                        _ButtonSignUp(onPressedSignUp: onPressedSignUp),
                        const SizedBox(height: 11),
                        _Footer(onPressedMoveToSignIn: onPressedMoveToSignIn),
                        const Spacer(flex: 2),
                      ],
                    ),
                  ),
                ),
              ),
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

  File? _photoFile;

  imageProcess(BuildContext context) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      // check if image is picked
      if (image != null) {
        _photoFile = File(image.path);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(errorSnackBar('No image selected'));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //  ============= onPressed functions ============== //

  void onPressedSignUp() {
    widget.authProvider.signUp(_photoFile);
  }

  void onPressedMoveToSignIn() {
    widget.authProvider.setFieldState(true);
    widget.authProvider.setAuthType(AuthType.signIn);
    Navigator.of(context).pushReplacement(
      PageTransition(
        child: SignIn(
          authProvider: widget.authProvider,
        ),
        type: PageTransitionType.fade,
        curve: Curves.bounceInOut,
      ),
    );
  }

  //  ============= onChanged functions ============== //
  void onChangedUsername(String value) {}
  void onChangedEmail(String value) {
    emailField = value;
    if (emailField == null || emailField == '') {
      widget.authProvider.setFieldState(true);
    } else {
      widget.authProvider.setFieldState(false);
    }
  }

  void onChangedPassword(String value) {
    password = value;
    setState(() {
      checkPasswordConfirm();
    });
  }

  void onChangedPasswordConfirm(String value) {
    passwordConfirm = value;
    setState(() {
      checkPasswordConfirm();
    });
  }

  void checkPasswordConfirm() {
    if (password == null || passwordConfirm == null) {
      ifPasswordConfirmed = null;
    } else if (password == "" || passwordConfirm == "") {
      ifPasswordConfirmed = null;
    } else if (password != passwordConfirm) {
      ifPasswordConfirmed = false;
    } else {
      ifPasswordConfirmed = true;
    }
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
          )),
    );
  }
}

class _InputField extends StatelessWidget {
  final AuthProvider? authProvider;
  final ValueChanged<String>? onChangedUsername;
  final ValueChanged<String>? onChangedEmail;
  final ValueChanged<String>? onChangedPassword;
  final ValueChanged<String>? onChangedPasswordConfirm;
  final bool? ifPasswordConfirmed;
  final void Function()? imageFunction;

  const _InputField({
    required this.onChangedUsername,
    required this.onChangedEmail,
    required this.onChangedPassword,
    required this.onChangedPasswordConfirm,
    required this.ifPasswordConfirmed,
    required this.imageFunction,
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
            controller: authProvider?.emailController,
            hintText: 'Email Address',
            onChanged: onChangedEmail,
          ),
          LoginTextFormField(
            controller: authProvider?.userNameController,
            hintText: 'User Name',
            onChanged: onChangedUsername,
          ),
          LoginTextFormField(
            controller: authProvider?.passwordController,
            hintText: 'Password',
            onChanged: onChangedPassword,
            obscureText: true,
            borderColor: confirmedColor(ifPasswordConfirmed),
            focusedBorderColor: confirmedColor(ifPasswordConfirmed),
          ),
          const SizedBox(height: 10.0),
          LoginTextFormField(
            hintText: 'Confirm Password',
            onChanged: onChangedPasswordConfirm,
            obscureText: true,
            borderColor: confirmedColor(ifPasswordConfirmed),
            focusedBorderColor: confirmedColor(ifPasswordConfirmed),
          ),
          const SizedBox(height: 13.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: imageFunction,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Color.fromARGB(255, 58, 58, 58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: const Text(
                'UPLOAD PROFILE IMAGE',
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
        ],
      ),
    );
  }

  Color confirmedColor(bool? confirmed) {
    if (confirmed == null) return COLOR_GRAY_LIGHT;
    if (confirmed) {
      return COLOR_MAIN_3;
    } else {
      return COLOR_MAIN_7;
    }
  }
}

class _ButtonSignUp extends StatelessWidget {
  final VoidCallback onPressedSignUp;
  const _ButtonSignUp({required this.onPressedSignUp, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 7),
      child: ElevatedButton(
          onPressed: onPressedSignUp,
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: const Color.fromARGB(255, 73, 73, 81),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 11)),
          child: const Text(
            'SIGN UP',
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
  final VoidCallback onPressedMoveToSignIn;
  const _Footer({required this.onPressedMoveToSignIn, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have and account?",
          style: TextStyle(
            color: COLOR_GRAY_LIGHT,
            fontSize: 13.0,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w400,
          ),
        ),
        TextButton(
          onPressed: onPressedMoveToSignIn,
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.all(1),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            '  Sign in  ',
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
