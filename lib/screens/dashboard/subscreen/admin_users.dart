import 'package:flutter/material.dart';
import 'package:foody/models/user.dart';
import 'package:foody/utils/http_service.dart';

class AdminUsers extends StatefulWidget {
  const AdminUsers({super.key});

  @override
  State<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  late Future<User> getUser;
  List<User> listUsers = [];

  @override
  void initState() {
    getAllUsers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: getUser,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Users'),
            ),
            body: SizedBox(
              width: 400,
              height: 400,
              child: ListView.builder(
                  itemCount: listUsers.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var user = listUsers[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(flex: 1, child: Text('UserID: ${user.id}')),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.info_outline),
                        ),
                      ],
                    );
                  }),
            ),
          );
        });
  }

  getAllUsers() {
    getUser = HttpService.getAllUsers(listUsers).then((value) {
      return Future.value(value);
    });
  }
}
