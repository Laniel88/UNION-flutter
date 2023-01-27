import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:union/component/keys.dart';

class AuthProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  TextEditingController signInEmailController = TextEditingController();
  TextEditingController signInPasswordController = TextEditingController();

  bool _fieldState = true; // if textField is empty, this value is true
  bool get fieldState => _fieldState;

  late AuthType _authType;
  AuthType get authType => _authType;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  setFieldState(bool state) {
    _fieldState = state;
    notifyListeners();
  }

  setAuthType(AuthType type) {
    _authType = type;
    notifyListeners();
  }

  signUp(File? file) async {
    assert(_authType == AuthType.signUp);

    UserCredential userCredential;
    try {
      userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      firebaseFirestore.collection('users').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        'uid': userCredential.user!.uid,
        'user_name': userNameController.text,
        'groups': [],
      });

      if (file == null) return;
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_image/')
          .child(userCredential.user!.uid);
      await ref.putFile(file).whenComplete(() => print('upload finished!'));
    } on FirebaseAuthException catch (e) {
      Keys.scaffoldMessengerKey.currentState!
          .showSnackBar(authSnackBar(e.code));
    } catch (e) {
      Keys.scaffoldMessengerKey.currentState!
          .showSnackBar(authSnackBar(e.toString()));
    }
  }

  signIn() async {
    assert(_authType == AuthType.signIn);

    // ignore: unused_local_variable
    UserCredential userCredential;

    try {
      userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: signInEmailController.text,
          password: signInPasswordController.text);
    } on FirebaseAuthException catch (e) {
      Keys.scaffoldMessengerKey.currentState!
          .showSnackBar(authSnackBar(e.code));
    } catch (e) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(authSnackBar(
          e.toString() != "Null check operator used on a null value"
              ? e.toString()
              : 'wrong input'));
    }
  }

  GoogleSignIn googleSignIn = GoogleSignIn();

  signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      try {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        await firebaseAuth.signInWithCredential(authCredential);

        var collectionDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        if (!collectionDoc.exists) {
          firebaseFirestore
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({
            'email': googleSignInAccount.email,
            'uid': FirebaseAuth.instance.currentUser!.uid,
            'user_name': googleSignInAccount.displayName,
            'groups': [],
          });
        }
      } on FirebaseAuthException catch (e) {
        Keys.scaffoldMessengerKey.currentState!
            .showSnackBar(googleSnackBar(e.toString()));
      }
    } else {
      Keys.scaffoldMessengerKey.currentState!
          .showSnackBar(googleSnackBar("Account not selected"));
    }
  }

  logOut() async {
    try {
      await firebaseAuth.signOut();
      await googleSignIn.signOut();
    } catch (e) {
      Keys.scaffoldMessengerKey.currentState!
          .showSnackBar(authSnackBar(e.toString()));
    }
  }

  SnackBar authSnackBar(String error) {
    return SnackBar(
      content: Text(
        fieldState ? 'Enter valid text' : error,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17.0,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
      duration: const Duration(milliseconds: 750),
      backgroundColor: const Color(0xB3FA8072),
    );
  }

  SnackBar googleSnackBar(String error) {
    return SnackBar(
      content: Text(
        error,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17.0,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
      duration: const Duration(milliseconds: 750),
      backgroundColor: const Color(0xB3FA8072),
    );
  }
}

enum AuthType {
  signUp,
  signIn,
}
