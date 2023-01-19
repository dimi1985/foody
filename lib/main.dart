import 'package:flutter/material.dart';
import 'package:foody/screens/authScreen/auth_screen.dart';
import 'package:foody/screens/homepage/home_page.dart';
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
        primarySwatch: Colors.blue,
      ),
      // home: AdminPanel(),
      home: isOneTimeLogin ? const Homepage() : const AuthScreen(),
    );
  }

  Future getOneTimeLogin() async {
    GlobalSharedPreference.getOneTimeLogin().then((value) {
      setState(() {
        isOneTimeLogin = value;
      });
    });
  }
}
