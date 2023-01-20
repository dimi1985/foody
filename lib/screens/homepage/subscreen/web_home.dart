import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:foody/models/menuModel.dart';
import 'package:foody/screens/addRecipe/add_recipe_page.dart';
import 'package:foody/screens/category/category_recipe_page.dart';
import 'package:foody/screens/homepage/subscreen/home_recipe.dart';
import 'package:foody/screens/homepage/subscreen/widgets/menu_items.dart';
import 'package:foody/screens/profile/profile_screen.dart';

import 'package:foody/screens/team_page.dart';
import 'package:foody/utils/http_service.dart';

class WebHome extends StatefulWidget {
  final String? username, id, email, userType, userImage;
  List? userFollowing;

  WebHome({
    super.key,
    this.username,
    this.id,
    this.email,
    this.userType,
    this.userImage,
    this.userFollowing,
  });

  @override
  State<WebHome> createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> {
  List<MenuModel> menuName = [
    MenuModel(title: 'Home', page: const HomeRecipe()),
    MenuModel(title: 'Add Recipe', page: const AddRecipePage()),
    MenuModel(title: 'Categories', page: const CategoryRecipePage()),
    MenuModel(title: 'Team', page: const TeamPage()),
  ];

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    log(size.toString());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color.fromARGB(255, 243, 58, 33),
                Color.fromARGB(255, 233, 30, 30)
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    logo(size),
                    if (size.width > 800)
                      const SizedBox(
                        width: 300,
                      ),
                    if (size.width < 550)
                      const SizedBox(
                        width: 20,
                      ),
                    if (size.width < 800 && size.width > 560)
                      const SizedBox(
                        width: 150,
                      ),
                    menuItems(size),
                    searchButton(),
                    profileIconName(size)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: PageView.builder(
          controller: pageController,
          itemCount: menuName.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: const BoxDecoration(color: Colors.white60),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: menuName[index].page,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget logo(Size size) {
    return Row(
      children: [
        SizedBox(
          height: size.width <= 800 ? 20 : 50,
          width: size.width <= 800 ? 20 : 50,
          child: Image.asset('assets/images/logo.png'),
        ),
        SizedBox(
          width: size.width <= 800 ? 5 : 15,
        ),
        Text(
          'Foody',
          style: TextStyle(
            color: Colors.white,
            fontSize: size.width <= 800 ? 20 : 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget searchButton() {
    return IconButton(
      icon: const Icon(
        Icons.search,
        size: 20,
      ),
      color: Colors.white,
      onPressed: () {},
    );
  }

  Widget menuItems(Size size) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        width: size.width <= 800 ? 300 : 800,
        height: 50,
        child: ListView.separated(
          itemCount: menuName.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: ((context, index) {
            return MenuItems(menuName, index, pageController);
          }),
          separatorBuilder: (context, index) => SizedBox(
            width: size.width <= 800 ? 10 : 30,
          ),
        ),
      ),
    );
  }

  profileIconName(Size size) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => ProfileScreen(
                  email: widget.email ?? '',
                  id: widget.id ?? '',
                  userImage: widget.userImage ?? '',
                  userType: widget.userImage ?? '',
                  username: widget.username ?? '',
                  userFollowing: widget.userFollowing,
                )),
          ),
        );
      },
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: size.width <= 800 ? 16 : 28,
            backgroundImage: NetworkImage(
              ('${HttpService.url}${(widget.userImage ?? '').replaceAll(r'\', '/')}'),
            ),
          ),
          Text(
            widget.username ?? 'Username',
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width <= 800 ? 16 : 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
