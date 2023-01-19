import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foody/models/menuModel.dart';
import 'package:foody/models/user.dart';
import 'package:foody/screens/addRecipe/add_recipe_page.dart';
import 'package:foody/screens/category_recipe_page.dart';
import 'package:foody/screens/homepage/menupages/home_recipe.dart';
import 'package:foody/screens/homepage/widgets/menu_items.dart';
import 'package:foody/screens/profile_screen.dart';
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
    // Clean up the controller when the widget is disposed.
    searchController.dispose();

    super.dispose();
  }

  List<MenuModel> menuName = [
    MenuModel(title: 'Home', page: const HomeRecipe()),
    MenuModel(title: 'Add Recipe', page:  AddRecipePage()),
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
    log(size.toString());
    return FutureBuilder<User>(
        future: getUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(size.width < 600 ? 110 : 150),
                  child: Container(
                    color: const Color.fromARGB(255, 224, 52, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: size.width < 600 ? 10 : 100),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/logo.png',
                                        fit: BoxFit.contain,
                                        height: 50,
                                        width: 50,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text(
                                        'Foodie',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: size.width < 600
                                            ? size.width * 0.4
                                            : size.width * 0.6,
                                        height: size.width < 600 ? 40 : 60,
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 243, 65, 33),
                                              width: 1),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(4),
                                          ),
                                        ),
                                        child: TextFormField(
                                          cursorColor: const Color.fromARGB(
                                              255, 148, 0, 86),
                                          controller: searchController,
                                          decoration: const InputDecoration(
                                            labelText: 'Search',
                                            labelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 209, 47, 6)),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      SizedBox(
                                        width: size.width < 600
                                            ? size.width * 0.4
                                            : size.width * 0.8,
                                        height: size.width < 600 ? 40 : 60,
                                        child: Center(
                                          child: ListView.separated(
                                            itemCount: menuName.length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: ((context, index) {
                                              return MenuItems(menuName, index,
                                                  isHovered, onAddButtonTapped);
                                            }),
                                            separatorBuilder:
                                                (context, index) => SizedBox(
                                              width:
                                                  size.width < 600 ? 10 : 100,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: size.width < 600 ? 10 : 25,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProfileScreen(
                                                  id: id,
                                                  username: username,
                                                  email: email,
                                                  userImage: userImage,
                                                  userType: userType,
                                                )),
                                      );
                                    },
                                    onHover: (value) {
                                      setState(() {
                                        isHovering = value;
                                        isHovering = !isHovering;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff7c94b6),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  '$baseUrl${(userImage)!.replaceAll(r'\', '/')}'),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(50.0)),
                                            border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              width: 4.0,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          snapshot.data!.username,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
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
                          decoration:
                              const BoxDecoration(color: Colors.white60),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: menuName[index].page,
                          ),
                        );
                      },
                    )),
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
      });
      return Future.value(value);
    });
  }

  void onAddButtonTapped(int index) {
    pageController.jumpToPage(index);
  }
}
