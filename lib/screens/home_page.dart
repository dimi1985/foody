import 'package:flutter/material.dart';
import 'package:foody/models/user.dart';
import 'package:foody/screens/auth_screen.dart';
import 'package:foody/screens/profile_screen.dart';
import 'package:foody/utils/http_service.dart';
import 'package:foody/utils/shared_preference.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    super.key,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<User> getUser;
  String? id;
  String? username;
  String? email;
  String? userImage;
  @override
  void initState() {
    getUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: getUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  title: const Text('HomePage'),
                  actions: [
                    IconButton(
                      onPressed: () {
                        GlobalSharedPreference.clearOneTimeLogin();
                        GlobalSharedPreference.clearUserId();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AuthScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      icon: const Icon(
                        Icons.exit_to_app,
                      ),
                    ),
                    Material(
                      color: const Color.fromARGB(255, 47, 5, 116),
                      child: MaterialButton(
                        onPressed: (() {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                id: id,
                                email: email,
                                username: username,
                                userImage: userImage,
                              ),
                            ),
                          );
                        }),
                        child: Text(
                          snapshot.data?.email ?? 'No email at this time',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  getUserProfile() {
    getUser = HttpService.getUserById().then((value) {
      setState(() {
        id = value.id;
        username = value.username;
        email = value.email;
        userImage = value.userImage;
      });
      return Future.value(value);
    });
  }
}
