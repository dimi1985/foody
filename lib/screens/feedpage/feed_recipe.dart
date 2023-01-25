import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:foody/models/recipe.dart';
import 'package:foody/screens/widgets/recipe_card.dart';
import 'package:foody/utils/http_service.dart';

class FeedRecipe extends StatefulWidget {
  const FeedRecipe({super.key});

  @override
  State<FeedRecipe> createState() => _FeedRecipeState();
}

class _FeedRecipeState extends State<FeedRecipe> {
  Future<Recipe>? getFutureRecipes;
  List<Recipe>? recipes = [];
  List<String> listTitles = ['Following', 'Related'];

  @override
  void initState() {
    getFutureRecipes = HttpService.getAllRecipies(recipes!);
    super.initState();
  }

  MaterialColor mainColor = Colors.deepOrange;
  TextStyle appBarTextStyle = const TextStyle(color: Colors.deepOrange);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    log('$size');
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
              color: mainColor,
            ),
          ),
          title: appBarTitles(),
          centerTitle: true,
          actions: [
            searchIcon(),
          ],
        ),
      ),
      body: FutureBuilder<Recipe>(
        future: getFutureRecipes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              width: size.width,
              height: size.height,
              child: size.width < 600
                  ? listviewMobileStyle()
                  : listviewWebStyle(size),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget appBarTitles() {
    return Text(
      'Following',
      style: appBarTextStyle,
    );
  }

  Widget listviewMobileStyle() {
    return ListView.builder(
        itemCount: recipes!.length,
        shrinkWrap: true,
        itemBuilder: ((context, index) {
          var recipe = recipes![index];
          return RecipeCard(recipe);
        }));
  }

  Widget listviewWebStyle(Size size) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: size.width > 550
              ? size.width < 1300
                  ? size.width * 0.5
                  : size.width * 0.4
              : size.width * 0.5,
        ),
        child: ListView.builder(
            itemCount: recipes!.length,
            shrinkWrap: true,
            itemBuilder: ((context, index) {
              var recipe = recipes![index];
              return RecipeCard(recipe);
            })),
      ),
    );
  }

  Widget searchIcon() {
    return IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.search,
          color: mainColor,
        ));
  }
}
