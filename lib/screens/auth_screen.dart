import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:foody/screens/home_page.dart';
import 'package:foody/utils/http_service.dart';
import 'package:foody/utils/shared_preference.dart';
import 'package:intl/intl.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool isLoading = false;
  bool isRegister = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
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
              if (isRegister)
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    label: Text('Username'),
                  ),
                ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Material(
                    child: MaterialButton(
                      onPressed: isLoading
                          ? null
                          : isRegister
                              ? register
                              : login,
                      child: Text(isRegister ? 'Register' : 'Login'),
                    ),
                  ),
                  Checkbox(
                      value: isRegister,
                      onChanged: ((value) {
                        setState(() {
                          isRegister = value!;
                        });
                      }))
                ],
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

  register() {
    var imageDummyPath = r'user-images\dummy-image\dummy-image.jpg';
    String createdAt =
        DateFormat("MMM, EEE, yyyy, kk:mm").format(DateTime.now());
    String userType = 'user';

    setState(() {
      isLoading = true;
    });
    if (emailController.text.isNotEmpty ||
        passwordController.text.isNotEmpty ||
        usernameController.text.isNotEmpty) {
      HttpService.registerUser(
              emailController.text.trim(),
              passwordController.text.trim(),
              usernameController.text.trim(),
              imageDummyPath,
              userType,
              createdAt)
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
