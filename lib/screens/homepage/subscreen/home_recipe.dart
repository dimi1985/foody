import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foody/models/category.dart';
import 'package:foody/models/recipe.dart';
import 'package:foody/screens/homepage/subscreen/widgets/recipe_card.dart';
import 'package:foody/utils/http_service.dart';

class HomeRecipe extends StatefulWidget {
  const HomeRecipe({super.key});

  @override
  State<HomeRecipe> createState() => _HomeRecipeState();
}

class _HomeRecipeState extends State<HomeRecipe> {
  Future<Recipe>? getFutureRecipes;
  List<Recipe>? recipes = [];

  @override
  void initState() {
    getFutureRecipes = HttpService.getAllRecipies(recipes!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<Recipe>(
        future: getFutureRecipes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return !snapshot.data!.isApproved
                ? Container()
                : kIsWeb
                    ? gridLisview(size)
                    : mobileListview();
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget gridLisview(Size size) {
    return size.width < 600
        ? ListView.separated(
            itemCount: recipes!.length,
            shrinkWrap: true,
            itemBuilder: ((context, index) {
              var recipe = recipes![index];
              return RecipeCard(recipe);
            }),
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 10,
              );
            },
          )
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent:
                    defaultTargetPlatform == TargetPlatform.android ? 120 : 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: recipes?.length,
            itemBuilder: (BuildContext ctx, index) {
              var recipe = recipes![index];
              return RecipeCard(recipe);
            });
  }

  mobileListview() {
    return ListView.separated(
      itemCount: recipes!.length,
      shrinkWrap: true,
      itemBuilder: ((context, index) {
        var recipe = recipes![index];
        return RecipeCard(recipe);
      }),
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 10,
        );
      },
    );
  }
}
