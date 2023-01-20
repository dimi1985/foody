import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:foody/screens/addRecipe/add_recipe_page.dart';
import 'package:foody/screens/dashboard/subscreen/admin_users.dart';

import 'subscreen/admin_categories.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  TextStyle globalTextSyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Admin Panel'),
            centerTitle: true,
          ),
          body: ListView(
            children: [
              GestureDetector(
                  onTap: () => _gotToPanels('Users'),
                  child: const ListTile(title: Text('Users'))),
              GestureDetector(
                  onTap: () => _gotToPanels('Recipes'),
                  child: const ListTile(title: Text('Recipes'))),
              GestureDetector(
                  onTap: () => _gotToPanels('Categories'),
                  child: const ListTile(title: Text('Categories')))
            ],
          )),
    );
  }

  _gotToPanels(String action) {
    switch (action) {
      case 'Users':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminUsers(),
          ),
        );
        break;
      case 'Recipes':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddRecipePage(),
          ),
        );
        break;
      case 'Categories':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminCategories(),
          ),
        );
        break;
    }
  }
}
