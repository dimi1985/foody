import 'package:flutter/material.dart';
import 'package:foody/screens/authScreen/widgets/auth_form.dart';
import 'package:foody/screens/authScreen/widgets/auth_inage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: size.width > 600
          ? Row(
              children: [
                Flexible(
                  flex: size.width < 1050 ? 3 : 2,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AuthForm(),
                  ),
                ),
                Flexible(
                  flex: size.width < 1050 ? 2 : 3,
                  child: const AuthImage(),
                ),
              ],
            )
          : Column(
              children: [
                Flexible(
                  flex: size.width < 800 ? 3 : 2,
                  child: const AuthImage(),
                ),
                Flexible(
                  flex: size.width < 800 ? 2 : 3,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: AuthForm(),
                  ),
                ),
              ],
            ),
    );
  }
}
