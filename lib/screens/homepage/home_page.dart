import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foody/models/menuModel.dart';
import 'package:foody/models/user.dart';
import 'package:foody/screens/addRecipe/add_recipe_page.dart';
import 'package:foody/screens/category/category_recipe_page.dart';
import 'package:foody/screens/homepage/subscreen/home_recipe.dart';
import 'package:foody/screens/homepage/subscreen/mobile_home.dart';
import 'package:foody/screens/homepage/subscreen/web_home.dart';

import 'package:foody/screens/team_page.dart';
import 'package:foody/utils/http_service.dart';

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
  String? userType;
  List? userFollowing;

  TextEditingController searchController = TextEditingController();

  static var baseUrl = defaultTargetPlatform == TargetPlatform.android
      ? Uri.parse(HttpService.baseUrlMobile)
      : Uri.parse(HttpService.baseUrlWeb);

  @override
  void initState() {
    getUserProfile();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  List<MenuModel> menuName = [
    MenuModel(title: 'Home', page: const HomeRecipe()),
    MenuModel(title: 'Add Recipe', page: const AddRecipePage()),
    MenuModel(title: 'Categories', page: const CategoryRecipePage()),
    MenuModel(title: 'Team', page: const TeamPage()),
  ];

  bool isHovered = false;
  bool isHovering = false;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder<User>(
        future: getUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return defaultTargetPlatform == TargetPlatform.android
                  ? MobileHome(
                      id: id,
                      email: email,
                      username: username,
                      userType: userType,
                      userImage: userImage,
                      userFollowing: userFollowing,
                    )
                  : WebHome(
                      id: id,
                      email: email,
                      username: username,
                      userType: userType,
                      userImage: userImage,
                      userFollowing: userFollowing,
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
        userType = value.userType;
        userFollowing = value.following;
      });
      return Future.value(value);
    });
  }
}
