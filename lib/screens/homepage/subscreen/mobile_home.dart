import 'package:flutter/material.dart';
import 'package:foody/screens/addRecipe/add_recipe_page.dart';
import 'package:foody/screens/category/category_recipe_page.dart';
import 'package:foody/screens/homepage/subscreen/home_recipe.dart';
import 'package:foody/screens/profile/profile_screen.dart';

class MobileHome extends StatefulWidget {
  final String? id, email, username, userType, userImage;
  List? userFollowing;
  MobileHome(
      {super.key,
      this.id,
      this.email,
      this.username,
      this.userType,
      this.userImage,
      this.userFollowing});

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 255, 98, 7),
            bottom: TabBar(
              tabs: [
                const Tab(
                  icon: Icon(Icons.home),
                ),
                const Tab(
                  icon: Icon(Icons.add_box),
                ),
                const Tab(
                  icon: Icon(Icons.category),
                ),
                Tab(
                  text: widget.username ?? '',
                  icon: const Icon(Icons.account_circle_outlined),
                ),
              ],
            ),
            title: logo(),
          ),
          body: TabBarView(
            children: [
              const HomeRecipe(),
              const AddRecipePage(),
              const CategoryRecipePage(),
              ProfileScreen(
                email: widget.email ?? '',
                id: widget.id ?? '',
                userImage: widget.userImage ?? '',
                userType: widget.userImage ?? '',
                username: widget.username ?? '',
                userFollowing: widget.userFollowing,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget logo() {
    return Row(
      children: [
        SizedBox(
            height: 50,
            width: 50,
            child: Image.asset('assets/images/logo.png')),
        const SizedBox(
          width: 15,
        ),
        const Text(
          'Foody',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
