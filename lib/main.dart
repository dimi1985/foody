import 'package:flutter/material.dart';
import 'package:foody/screens/authScreen/auth_screen.dart';
import 'package:foody/screens/homepage/landing_page.dart';
import 'package:foody/screens/profile/profile_screen.dart';
import 'package:foody/utils/shared_preference.dart';

import 'screens/dashboard/admin_panel.dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isOneTimeLogin = false;
  @override
  void initState() {
    getOneTimeLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      // home: ProfileScreen(),
      home: isOneTimeLogin ? const Landingpage() : const AuthScreen(),
    );
  }

  Future getOneTimeLogin() async {
    GlobalSharedPreference.getOneTimeLogin().then((value) {
      if (isOneTimeLogin == null) {
        GlobalSharedPreference.setOneTimeLogin(false);
      }
      setState(() {
        isOneTimeLogin = value;
      });
    });
  }
}
