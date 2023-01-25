import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foody/models/menuModel.dart';
import 'package:foody/models/user.dart';
import 'package:foody/screens/addRecipe/add_recipe_page.dart';
import 'package:foody/screens/discovery/discovery_page.dart';
import 'package:foody/screens/feedpage/feed_recipe.dart';
import 'package:foody/screens/profile/profile_screen.dart';
import 'package:foody/screens/team_page.dart';
import 'package:foody/utils/http_service.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class Landingpage extends StatefulWidget {
  const Landingpage({
    super.key,
  });

  @override
  State<Landingpage> createState() => _LandingState();
}

class _LandingState extends State<Landingpage> {
  late Future<User> getUser;
  String? id;
  String? username;
  String? email;
  String? userImage;
  String? userType;
  List? userFollowing;
  String? sendID;

  TextEditingController searchController = TextEditingController();

  int selectedIndex = 0;
  @override
  void initState() {
    getUserProfile();
    sendID = '';
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  List<Widget> pages = [
    const FeedRecipe(),
    const DiscoveryPage(),
    const AddRecipePage(),
    const TeamPage(),
    ProfileScreen(''),
  ];

  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<User>(
          future: getUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                // return defaultTargetPlatform == TargetPlatform.android
                return Center(
                  child: pages.elementAt(selectedIndex),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      bottomNavigationBar: ConvexAppBar(
        height: size.width > 800 ? 80 : 50,
        backgroundColor: Colors.white,
        onTap: onItemTapped,
        initialActiveIndex: 0,
        color: Colors.deepOrange,
        activeColor: Colors.orange,
        items: [
          const TabItem(icon: Icons.home, title: 'Home'),
          const TabItem(icon: Icons.map, title: 'Discovery'),
          const TabItem(icon: Icons.add, title: 'Add'),
          const TabItem(icon: Icons.people_alt, title: 'Team'),
          TabItem(icon: Icons.people, title: '$username'),
        ],
      ),
    );
  }

  getUserProfile() async {
    getUser = HttpService.getUserById('').then((value) {
      setState(() {
        id = value.id;
        username = value.username;
        email = value.email;
        userImage = value.userImage;
        userType = value.userType;
        userFollowing = value.following;
      });
      return Future.value(value);
    });
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
