import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:union/component/keys.dart';
import 'package:union/component/provider/auth_provider.dart';
import 'package:union/firebase_options.dart';
import 'package:union/view/common/splash_screen.dart';
import 'package:union/view/login/login_picker.dart';
import 'package:union/view/root/root_tab.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: ((_) => AuthProvider()))],
      child: MaterialApp(
        scaffoldMessengerKey: Keys.scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              // // If app cannot logout normally
              // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
              // GoogleSignIn googleSignIn = GoogleSignIn();
              // firebaseAuth.signOut();
              // googleSignIn.signOut();
              return const SplashScreen(targetWidget: RootTab());
            } else {
              return const SplashScreen(targetWidget: LoginPicker());
            }
          }),
        ),
      ),
    ),
  );
}
