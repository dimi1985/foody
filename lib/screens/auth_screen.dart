import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:foody/screens/home_page.dart';
import 'package:foody/utils/http_service.dart';
import 'package:foody/utils/shared_preference.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  label: Text('Email'),
                ),
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  label: Text('Password'),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Material(
                child: MaterialButton(
                  onPressed: isLoading ? null : login,
                  child: const Text('Login'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  login() {
    setState(() {
      isLoading = true;
    });
    if (emailController.text.isNotEmpty || passwordController.text.isNotEmpty) {
      HttpService.loginUser(
              emailController.text.trim(), passwordController.text.trim())
          .then((value) {
        if (value.id.isNotEmpty) {
          setState(() {
            isLoading = false;
          });
          GlobalSharedPreference.setUserID(value.id);
          GlobalSharedPreference.setOneTimeLogin(true);
          log(value.id);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Homepage()),
            (Route<dynamic> route) => false,
          );
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }
}
