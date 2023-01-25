import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:foody/models/recipe.dart';
import 'package:foody/screens/widgets/recipe_details.dart';
import 'package:foody/utils/http_service.dart';
import 'package:foody/utils/shared_preference.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;

  const RecipeCard(this.recipe, {super.key});

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool isFavorite = false;
  bool isMe = false;
  String? loggedId;

  @override
  void initState() {
    isItMe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RecipeDetails(recipe: widget.recipe)),
        );
      },
      child: Card(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                userNameProfile(),
                Spacer(flex: size.width < 600 ? 1 : 2),
                dateRecipeCreated(),
              ],
            ),
            mainRecipeImageStacked(size)
          ],
        ),
      ),
    );
  }

  Widget userNameProfile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          ClipOval(
              child: Image.network(
            recipeUserImage(),
            fit: BoxFit.cover,
            width: 35.0,
            height: 35.0,
          )),
          const SizedBox(
            width: 12,
          ),
          Text(
            widget.recipe.recipeUserName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  String recipeUserImage() {
    return '${HttpService.url}' '${widget.recipe.recipeUserImagePath}'
        .replaceAll(r'\', '/');
  }

  Widget dateRecipeCreated() {
    return SizedBox(
      width: 200,
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                overflow: TextOverflow.ellipsis,
                widget.recipe.createdAt,
                style: const TextStyle(
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
              ),
            ),
          ),
          if (isMe)
            IconButton(
              onPressed: () {
                showBottomMenu();
              },
              icon: const Icon(Icons.menu),
            )
        ],
      ),
    );
  }

  Widget mainRecipeImageStacked(Size size) {
    return Stack(
      children: [
        imageContainer(size),
        recipeName(),
        likeButton(),
      ],
    );
  }

  Widget imageContainer(Size size) {
    return Container(
      height: 250,
      width: size.width,
      foregroundDecoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Color.fromARGB(141, 28, 44, 53),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 0.7],
        ),
      ),
      child: Hero(
        tag: widget.recipe,
        child: Image.network(
          recipeImage(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  String recipeImage() {
    return '${HttpService.url}' '${widget.recipe.recipeImage}'
        .replaceAll(r'\', '/');
  }

  Widget recipeName() {
    return Positioned(
      bottom: 20,
      left: 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textAlign: TextAlign.center,
            widget.recipe.recipeCategoryname,
            style: TextStyle(
              background: Paint()
                ..color = Colors.deepOrange
                ..strokeWidth = 18
                ..strokeJoin = StrokeJoin.round
                ..strokeCap = StrokeCap.round
                ..style = PaintingStyle.stroke,
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            textAlign: TextAlign.center,
            widget.recipe.recipeName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget likeButton() {
    return Positioned(
      bottom: 10,
      right: 10,
      child: InkWell(
        onTap: () {
          setState(() {
            isFavorite = !isFavorite;
          });
        },
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite
              ? const Color.fromARGB(255, 254, 140, 106)
              : Colors.deepOrange,
        ),
      ),
    );
  }

  void isItMe() {
    GlobalSharedPreference.getUserID().then((value) {
      setState(() {
        loggedId = value;
      });
      if (loggedId!.contains(widget.recipe.userId)) {
        setState(() {
          isMe = true;
        });
      }
    });
  }

  void showBottomMenu() {
    Scaffold.of(context).showBottomSheet<void>(
      (BuildContext context) {
        return SingleChildScrollView(
          child: SizedBox(
            height: 500,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.cancel))
                    ],
                  ),
                  const Center(
                      child: Text(
                    'Edit Recipe',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color.fromARGB(255, 243, 65, 33),
                                  width: 1),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            child: TextFormField(
                              cursorColor:
                                  const Color.fromARGB(255, 148, 0, 86),
                              //  controller: usernameController,
                              decoration: InputDecoration(
                                labelText: widget.recipe.recipeName,
                                // labelStyle: labelTextStyle,
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color.fromARGB(255, 243, 65, 33),
                                  width: 1),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            child: TextFormField(
                              cursorColor:
                                  const Color.fromARGB(255, 148, 0, 86),
                              //  controller: usernameController,
                              decoration: InputDecoration(
                                labelText:
                                    widget.recipe.recipeDuration.toString(),
                                // labelStyle: labelTextStyle,
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color.fromARGB(255, 243, 65, 33),
                                  width: 1),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            child: TextFormField(
                              cursorColor:
                                  const Color.fromARGB(255, 148, 0, 86),
                              //  controller: usernameController,
                              decoration: InputDecoration(
                                labelText: widget.recipe.ingredients.toString(),
                                // labelStyle: labelTextStyle,
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    child: const Text('Update'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
