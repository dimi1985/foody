import 'package:flutter/material.dart';
import 'package:foody/models/user.dart';
import 'package:foody/utils/http_service.dart';

class AdminUsers extends StatefulWidget {
  final User? user;
  final List<User> listUsers;
  const AdminUsers(this.user, this.listUsers, {super.key});

  @override
  State<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: SizedBox(
        width: 400,
        height: 400,
        child: ListView.builder(
            itemCount: widget.listUsers.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var user = widget.listUsers[index];
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
  }
}
