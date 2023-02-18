import 'package:flutter/material.dart';
import 'package:foody/screens/auth_screen.dart';
import 'package:foody/screens/landing_page.dart';
import 'package:foody/utils/dark_theme_provider.dart';
import 'package:foody/utils/shared_preference.dart';
import 'package:foody/utils/styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  bool isOneTimeLogin = false;
  @override
  void initState() {
    getOneTimeLogin();
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            title: 'Flutter Demo',
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            // home: AdminPanel(),
            home: isOneTimeLogin ? const Landingpage() : const AuthScreen(),
          );
        },
      ),
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

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }
}
