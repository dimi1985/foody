import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:foody/utils/shared_preference.dart';

class ProfileScreen extends StatefulWidget {
  String? username;
  String? id;
  String? email;
  String? userImage;
  ProfileScreen(
      {super.key, this.username, this.id, this.email, this.userImage});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? loggedUserID;
  bool isMe = false;
  static var baseUrl = defaultTargetPlatform == TargetPlatform.android
      ? Uri.parse('http://10.0.2.2:3000/')
      : Uri.parse('http://localhost:3000/');

  @override
  void initState() {
    checkIfMe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username ?? 'No username at this time'),
      ),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage('$baseUrl${widget.userImage}'),
            ),
            if (isMe)
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit),
              )
          ],
        ),
      ),
    );
  }

  Future checkIfMe() async {
    GlobalSharedPreference.getUserID().then((value) {
      setState(() {
        loggedUserID = value;
      });
      if (loggedUserID == widget.id) {
        setState(() {
          isMe = true;
        });
      }
    });
  }
}
