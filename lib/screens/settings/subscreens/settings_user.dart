import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:foody/models/user.dart';
import 'package:foody/screens/authScreen/auth_screen.dart';
import 'package:foody/utils/http_service.dart';
import 'package:foody/utils/shared_preference.dart';

class SettingsUser extends StatefulWidget {
  const SettingsUser({super.key});

  @override
  State<SettingsUser> createState() => _SettingsUserState();
}

class _SettingsUserState extends State<SettingsUser> {
  bool isSwitched = false;
  late Future<User> getUser;

  @override
  void initState() {
    getSwitchState();
    getUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultTargetPlatform == TargetPlatform.android
          ? AppBar(
              title: const Text('User Settings'),
            )
          : null,
      body: FutureBuilder<User>(
          future: getUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.login),
                        title: const Text('User Credentials'),
                        subtitle: Text(isSwitched
                            ? 'Save user credentials for one time login(Enabled)'
                            : 'Save user credentials for one time login(Currently Disabled)'),
                        enabled: true,
                        trailing: Switch(
                          value: isSwitched,
                          activeColor: Colors.green,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = !isSwitched;
                              value = isSwitched;
                              saveSwitchState(value);
                            });
                          },
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.account_circle_outlined),
                        title: Text('Username(${snapshot.data!.username})'),
                        subtitle: const Text(
                            'Change your username to what ever you want'),
                        enabled: true,
                      ),
                      ListTile(
                        leading: const Icon(Icons.login),
                        title: const Text('Sign out'),
                        subtitle: const Text('All Setting will be Removed!'),
                        enabled: true,
                        trailing: MaterialButton(
                          hoverColor: Colors.deepPurple,
                          onPressed: signout,
                          textColor: Colors.redAccent,
                          child: const Text('Sign out'),
                        ),
                      ),
                    ],
                  )
                ],
              );
            }
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.deepPurple,
            ));
          }),
    );
  }

  Future<bool> getSwitchState() async {
    isSwitched = await GlobalSharedPreference.getOneTimeLogin().then((value) {
      setState(() {
        isSwitched = value;
      });
      return isSwitched;
    });

    return isSwitched;
  }

  Future<bool> saveSwitchState(bool value) async {
    await GlobalSharedPreference.setOneTimeLogin(value);
    log('saveSwitchState:$isSwitched');
    return value;
  }

  signout() {
    GlobalSharedPreference.clearUserId();
    GlobalSharedPreference.clearOneTimeLogin();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AuthScreen()));
  }

  getUserProfile() {
    getUser = HttpService.getUserById();
  }
}
