import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foody/models/category.dart';
import 'package:foody/models/recipe.dart';
import 'package:foody/models/user.dart';
import 'package:foody/screens/dashboard/subscreen/admin_recipies.dart';
import 'package:foody/screens/dashboard/subscreen/admin_users.dart';
import 'package:foody/utils/http_service.dart';

import 'subscreen/admin_categories.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  late Future<User> getUser;
  List<User> listUsers = [];
  final List<Recipe> listRecipies = [];
  late Future<Recipe> getFutureRecipes;
  late Future<CategoryModel> getCategories;
  List<CategoryModel> listCategories = [];
  TextStyle globalTextSyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  late Recipe recipe;

  @override
  void initState() {
    getAllUsers();
    getAllRecipies();
    getAllCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: kIsWeb
              ? null
              : AppBar(
                  title: const Text('Admin Panel'),
                  centerTitle: true,
                ),
          body: Center(
            child: SizedBox(
              width: 600,
              height: 500,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: cardUsers(),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: cardRecipes(),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: cardCategories(),
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget cardUsers() {
    return FutureBuilder<User>(
        future: getUser,
        builder: (context, snapshot) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminUsers(snapshot.data, listUsers),
                ),
              );
            },
            child: SizedBox(
              height: 250,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Users'),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text('Total users: ${listUsers.length.toString()}')
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget cardRecipes() {
    return FutureBuilder<Recipe>(
        future: getFutureRecipes,
        builder: (context, snapshot) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AdminRecipes(snapshot.data, listRecipies),
                ),
              );
            },
            child: SizedBox(
              height: 250,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Recipies'),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text('Total recipies: ${listRecipies.length.toString()}')
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget cardCategories() {
    return FutureBuilder<CategoryModel>(
        future: getCategories,
        builder: (context, snapshot) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminCategories(
                      snapshot.data, listCategories, listRecipies),
                ),
              );
            },
            child: SizedBox(
              height: 250,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Categories'),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                        'Total categories: ${listCategories.length.toString()}')
                  ],
                ),
              ),
            ),
          );
        });
  }

  getAllUsers() async {
    getUser = HttpService.getAllUsers(listUsers).then((value) {
      return Future.value(value);
    });
  }

  getAllRecipies() async {
    getFutureRecipes =
        HttpService.getRecipiesSortBy(listRecipies).then((value) {
      return Future.value(value);
    });
  }

  getAllCategories() async {
    getCategories = HttpService.getAllCategories(listCategories).then((value) {
      return Future.value(value);
    });
  }
}
