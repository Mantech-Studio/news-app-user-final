import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news_app_user/HomePage.dart';
import 'package:news_app_user/OpeningScreenUi.dart';
import 'package:news_app_user/Screens/LoginPage.dart';
import 'package:news_app_user/Screens/PageControllerScreen.dart';
import 'package:news_app_user/Screens/PhoneAuth.dart';
import 'package:news_app_user/Theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //runApp(OpeningScreen()); //new starting screen
  if (FirebaseAuth.instance.currentUser?.uid == null) {
    runApp(MaterialApp(
      theme: ThemeNotifier().darkTheme ? dark : light,
      debugShowCheckedModeBanner: false,
      home: OpeningScreen(),
    ));
  } else {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PageControllerScreen(),
    ));
  }
}
