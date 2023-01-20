import 'dart:io';
import 'package:foody/models/recipe.dart';
import 'package:foody/screens/homepage/subscreen/widgets/recipe_card.dart';

import 'package:foody/screens/settings/settings.dart';
import 'package:foody/utils/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:foody/utils/shared_preference.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final String id;
  final String email;
  final String userImage;
  final String userType;
  final List? userFollowing;

  const ProfileScreen({
    super.key,
    required this.username,
    required this.id,
    required this.email,
    required this.userImage,
    required this.userType,
    required this.userFollowing,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<Recipe>? getUserFutureRecipes;
  List<Recipe>? recipes = [];

  String? loggedUserID;
  String? userImage;

  bool isMe = false;
  File mobileImage = File("zz");
  String pickedImagePathName = 'zz';
  Uint8List webImage = Uint8List(10);
  static var baseUrl = defaultTargetPlatform == TargetPlatform.android
      ? Uri.parse(HttpService.baseUrlMobile)
      : Uri.parse(HttpService.baseUrlWeb);

  @override
  void initState() {
    checkIfMe();
    userImage = '$baseUrl${widget.userImage}';
    getUserFutureRecipes = HttpService.getUserRecipes(recipes!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<Recipe>(
        future: getUserFutureRecipes,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              title: defaultTargetPlatform == TargetPlatform.android
                  ? const Text('')
                  : const Text(
                      'back',
                      style: TextStyle(color: Colors.black),
                    ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SettingPage(userType: widget.userType)),
                      );
                    },
                    icon: const Icon(Icons.settings))
              ],
            ),
            body: kIsWeb && size.width > 600
                ? webProfileView(size)
                : mobileProfileView(size),
          );
        });
  }

  Future checkIfMe() async {
    GlobalSharedPreference.getUserID().then((value) {
      setState(() {
        loggedUserID = value;
      });
      if (loggedUserID == widget.id) {
        setState(() {
          isMe = true;
        });
      }
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

  webProfileView(Size size) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: profileContainer(),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(flex: 1, child: recipeSocialCountContainer(recipes)),
          const SizedBox(
            height: 30,
          ),
          Expanded(flex: 1, child: userRecipes(size)),
        ],
      ),
    );
  }

  mobileProfileView(Size size) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: profileContainer(),
          ),
          const SizedBox(
            height: 30,
          ),
          recipeSocialCountContainer(recipes),
          const SizedBox(
            height: 30,
          ),
          userRecipes(size),
        ],
      ),
    );
  }

  Widget profileContainer() {
    return Column(children: [
      CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 28,
        backgroundImage: NetworkImage(
          ('$userImage'),
        ),
      ),
      Text(widget.username),
    ]);
  }

  Widget recipeSocialCountContainer(List<Recipe>? recipes) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              recipes!.length.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Recipes',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        const Text('|'),
        const SizedBox(
          width: 25,
        ),
        Column(
          children: [
            Text(
              widget.userFollowing!.length.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Following',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }

  Widget userRecipes(Size size) {
    return SizedBox(
      width: defaultTargetPlatform == TargetPlatform.android
          ? size.width * 0.2
          : size.width * 0.6,
      height: defaultTargetPlatform == TargetPlatform.android
          ? size.height * 0.4
          : size.width * 0.3,
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent:
                  defaultTargetPlatform == TargetPlatform.android ? 60 : 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemCount: recipes!.length,
          itemBuilder: (BuildContext ctx, index) {
            var recipe = recipes![index];
            return RecipeCard(recipe);
          }),
    );
  }
}

// Center(

//             //#################Later USe For Edit####################
//             // ClipRRect(
//             //   child: mobileImage.path == "zz" || userImage!.isEmpty
//             //       ? const Center(
//             //           child: Text(
//             //             'Please Select an Image',
//             //             style: TextStyle(
//             //                 color: Colors.grey,
//             //                 fontWeight: FontWeight.w600,
//             //                 fontSize: 16),
//             //           ),
//             //         )
//             //       : (kIsWeb)
//             //           ? Image.memory(webImage)
//             //           : Image.file(
//             //               mobileImage,
//             //               fit: BoxFit.cover,
//             //             ),
//             // ),
//             if (isMe)
//               IconButton(
//                 onPressed: pickImage,
//                 icon: const Icon(Icons.edit),
//               )
//           ],
//         ),
//       )
