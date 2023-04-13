import 'package:chat_app/constant.dart';
import 'package:chat_app/view/profile_page.dart';
import 'package:chat_app/widgets/helping_functions.dart';
import 'package:chat_app/view/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'view/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSigndIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
    HelpingFunctions.getImage().then((value) {
      setState(() {
        url = value;
      });
    });
  }

  getUserLoggedInStatus() async {
    await HelpingFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSigndIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: constants().primaryColor,
          scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: _isSigndIn ? const HomeScreen() : const LoginPage(),
    );
  }
}
