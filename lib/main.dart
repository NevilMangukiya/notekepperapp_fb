import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:note_kepper_app/screens/add_data_page.dart';
import 'package:note_kepper_app/screens/homePage.dart';
import 'package:note_kepper_app/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "intro_Screen",
      routes: {
        '/': (context) => HomePage(),
        'intro_Screen': (context) => IntroScreen(),
        'add_note': (context) => AddDataPage(),
      },
    ),
  );
}
