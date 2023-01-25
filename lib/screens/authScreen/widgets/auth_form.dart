import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foody/screens/homepage/landing_page.dart';
import 'package:foody/utils/http_service.dart';
import 'package:foody/utils/shared_preference.dart';
import 'package:intl/intl.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool isLoading = false;
  bool isRegister = false;
  bool rememberMe = false;

  TextStyle labelTextStyle =
      const TextStyle(color: Color.fromARGB(255, 209, 47, 6));

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
    Size size = MediaQuery.of(context).size;
    log(size.toString());
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10, left: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: const Color.fromARGB(255, 243, 65, 33), width: 1),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: TextFormField(
                  cursorColor: const Color.fromARGB(255, 148, 0, 86),
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: labelTextStyle,
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding: const EdgeInsets.only(top: 10, left: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: const Color.fromARGB(255, 243, 65, 33), width: 1),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: TextFormField(
                  cursorColor: const Color.fromARGB(255, 148, 0, 86),
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: labelTextStyle,
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              if (isRegister)
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromARGB(255, 243, 65, 33),
                        width: 1),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: TextFormField(
                    cursorColor: const Color.fromARGB(255, 148, 0, 86),
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: labelTextStyle,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                          value: rememberMe,
                          onChanged: ((value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          })),
                      const Text('Remember me')
                    ],
                  ),
                  const Text(
                    'Forgot Password ?',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      color: const Color.fromARGB(255, 80, 167, 0),
                      child: SizedBox(
                        height: 30,
                        width: size.width * 0.6,
                        child: MaterialButton(
                          onPressed: isLoading
                              ? null
                              : isRegister
                                  ? register
                                  : login,
                          child: Text(isRegister ? 'Register' : 'Login'),
                        ),
                      ),
                    ),
                  ),
                  const Spacer()
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                          text: isRegister
                              ? 'Already a member?'
                              : 'Don\'t have an account?',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          children: <TextSpan>[
                            TextSpan(
                                text: isRegister ? ' Login' : ' Register',
                                style: const TextStyle(
                                    color: Colors.blueAccent, fontSize: 18),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    setState(() {
                                      isRegister = !isRegister;
                                    });
                                  })
                          ]),
                    ),
                  ))
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
          GlobalSharedPreference.setOneTimeLogin(rememberMe);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Landingpage()),
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
    const dummyPath = "user-images\\dummy-image\\dummy-image.png";
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
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        imgagePath: dummyPath,
        userType: userType,
        createdAt: createdAt,
      ).then((value) {
        if (value.id.isNotEmpty) {
          setState(() {
            isLoading = false;
          });
          GlobalSharedPreference.setUserID(value.id);
          GlobalSharedPreference.setOneTimeLogin(rememberMe);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Landingpage()),
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
