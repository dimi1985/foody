import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:foody/models/recipe.dart';
import 'package:foody/screens/profile_screen.dart';
import 'package:foody/utils/http_service.dart';
import 'package:foody/utils/shared_preference.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeDetails extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetails({super.key, required this.recipe});

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  var top = 0.0;
  late ScrollController controller;
  bool isCollapsed = false;
  String actionRoute = 'detailsPage';
  bool isMe = false;
  late String loggedUserId;
  late String recipeID;
  List finalIngredients = [];

  @override
  void initState() {
    //List<Widget> widgets = list.map((name) => new Text(name)).toList();
    controller = ScrollController()..addListener(onScroll);
    isMyRecipe();
    String joinedList = widget.recipe.ingredients.join(', ');
    finalIngredients = joinedList.split(',');
    super.initState();
  }

  void onScroll() {
    if (mounted) {
      if (controller.position.pixels >= 300) {
        setState(() {
          isCollapsed = true;
        });
      } else {
        setState(() {
          isCollapsed = false;
        });
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(
                  recipeImage(),
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                          widget.recipe.userId, loggedUserId)));
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 8,
                                  backgroundImage: NetworkImage(
                                    ('${HttpService.url}'
                                        '${widget.recipe.recipeUserImagePath}'),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.recipe.recipeUserName,
                                  style: TextStyle(
                                      fontFamily: GoogleFonts.getFont(
                                              widget.recipe.categoryGoogleFont)
                                          .fontFamily),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Text(
                            widget.recipe.recipeName,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.getFont(
                                        widget.recipe.categoryGoogleFont)
                                    .fontFamily),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                        child: Text(
                          widget.recipe.recipeCategoryname,
                          style: TextStyle(
                              fontSize: 16,
                              color: HexColor(widget.recipe.categoryHexColor),
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.getFont(
                                      widget.recipe.categoryGoogleFont)
                                  .fontFamily),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    widget.recipe.createdAt,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: GoogleFonts.getFont(
                                widget.recipe.categoryGoogleFont)
                            .fontFamily),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Divider(
                  color: Colors.grey.shade500,
                  height: 1,
                ),
                const SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Text(
                    "INGREDIENTS",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                        fontFamily: GoogleFonts.getFont(
                                widget.recipe.categoryGoogleFont)
                            .fontFamily),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ingredients(size),
                ),
                const SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    "DESCRIPTION",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                        fontFamily: GoogleFonts.getFont(
                                widget.recipe.categoryGoogleFont)
                            .fontFamily),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    widget.recipe.recipePreparation,
                    style: TextStyle(
                        fontFamily: GoogleFonts.getFont(
                                widget.recipe.categoryGoogleFont)
                            .fontFamily),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 40),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black87.withOpacity(0.7),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String recipeImage() {
    return '${HttpService.url}'
            '${widget.recipe.recipeImage}'
        .replaceAll(r'\', '/');
  }

  Widget durationPreparation() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.alarm,
          color: Colors.deepOrange,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          '${widget.recipe.recipeDuration.toString()} mins',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget ingredients(Size size) {
    return SizedBox(
      height: size.height / 4,
      child: ListView.builder(
        itemCount: finalIngredients.length,
        itemBuilder: (context, index) {
          var ingredient = finalIngredients[index];
          return ListTile(
            title: Text(
              ingredient,
              style: TextStyle(
                  fontFamily:
                      GoogleFonts.getFont(widget.recipe.categoryGoogleFont)
                          .fontFamily),
            ),
          );
        },
      ),
    );
  }

  void isMyRecipe() async {
    GlobalSharedPreference.getUserID().then((value) {
      setState(() {
        loggedUserId = value;

        if (widget.recipe.userId == loggedUserId) {
          isMe = true;
        }
      });
      return value;
    });
  }
}
