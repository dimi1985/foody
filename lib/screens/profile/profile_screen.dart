import 'dart:developer';
import 'dart:io';
import 'package:foody/models/recipe.dart';
import 'package:foody/models/user.dart';

import 'package:foody/screens/settings/settings.dart';
import 'package:foody/screens/widgets/recipe_card.dart';
import 'package:foody/utils/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final String? id, loggedUserId;
  const ProfileScreen(
    this.id,
    this.loggedUserId, {
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<Recipe>? getUserFutureRecipes;
  List<Recipe>? recipes = [];
  Future<User>? getUser;
  List<User>? users = [];

  String? loggedUserID;

  bool isMe = false;
  bool f = false;
  File mobileImage = File("zz");
  String pickedImagePathName = 'zz';
  Uint8List webImage = Uint8List(10);
  static var baseUrl = defaultTargetPlatform == TargetPlatform.android
      ? Uri.parse(HttpService.baseUrlMobile)
      : Uri.parse(HttpService.baseUrlWeb);

  @override
  void initState() {
    getUserFutureRecipes = HttpService.getUserRecipes(recipes!, widget.id!);
    getUser = HttpService.getUserById(widget.id!);

    if (widget.id == widget.loggedUserId) {
      setState(() {
        isMe = true;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<Recipe>(
        future: getUserFutureRecipes,
        builder: (context, snapshotRecipe) {
          return FutureBuilder<User>(
              future: getUser,
              builder: (context, snapshotUser) {
                if (snapshotUser.hasData && snapshotRecipe.hasData) {
                  var userImage = ('$baseUrl' '${snapshotUser.data?.userImage}')
                      .replaceAll(r'\', '/');
                  return Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      elevation: 0,
                      iconTheme: const IconThemeData(color: Colors.black),
                      backgroundColor: Colors.white,
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshotUser.data?.username ??
                                        'An Error has Occured!',
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    snapshotUser.data?.userType ??
                                        'An Error has Occured!',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 28,
                                backgroundImage: NetworkImage(
                                  (userImage),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshotUser.data!.recipies.length
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text(
                                    'Recipes',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  )
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshotUser.data!.following.length
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text(
                                    'Followers',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  )
                                ],
                              ),
                              const Spacer(),
                              OutlinedButton(
                                style: ButtonStyle(
                                    side: MaterialStateProperty.all(
                                        const BorderSide(
                                            color: Color.fromARGB(
                                                255, 243, 33, 33),
                                            width: 1.0,
                                            style: BorderStyle.solid))),
                                onPressed: () {
                                  isMe
                                      ? gotoSettingsPage(snapshotUser)
                                      : follow();
                                },
                                child: Text(
                                  isMe ? 'Settings' : 'Follow',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 245, 43, 43)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: size.height,
                              width: size.width,
                              child: ListView.builder(
                                  itemCount: recipes!.length,
                                  shrinkWrap: true,
                                  itemBuilder: ((context, index) {
                                    var recipe = recipes![index];
                                    return RecipeCard(recipe);
                                  })),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              });
        });
  }

  pickImage() async {
    // MOBILE
    if (!kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);

        setState(() {
          mobileImage = selected;
        });
      } else {
        //Something went wrong
      }
    }
    // WEB
    else if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          mobileImage = File(image.path);
          webImage = f;
          pickedImagePathName = image.path;
          HttpService.updateUserImageWeb(webImage);
        });
      } else {
        //Something went wrong
      }
    }
  }

  follow() {}

  gotoSettingsPage(AsyncSnapshot<User> snapshotUser) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SettingPage(
                userType: snapshotUser.data!.userType,
              )),
    );
  }
}
