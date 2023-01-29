import 'package:flutter/material.dart';
import 'package:foody/models/category.dart';
import 'package:foody/models/recipe.dart';
import 'package:foody/screens/widgets/recipe_card.dart';
import 'package:foody/utils/custom_scroll_behavior.dart';
import 'package:foody/utils/http_service.dart';

class RecipeByCategoryPage extends StatefulWidget {
  final CategoryModel category;
  const RecipeByCategoryPage(this.category, {super.key});

  @override
  State<RecipeByCategoryPage> createState() => _RecipeByCategoryPageState();
}

class _RecipeByCategoryPageState extends State<RecipeByCategoryPage> {
  final List<Recipe>? recipes = [];
  late Future<Recipe>? futureRecipe;

  @override
  void initState() {
    futureRecipe =
        HttpService.getRecipesByCategory(recipes!, widget.category.categoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: FutureBuilder<Recipe>(
            future: futureRecipe,
            builder: (context, snapshot) {
              return SafeArea(
                child: Column(
                  children: [
                    Text(widget.category.categoryName),
                    SizedBox(
                      width: double.infinity,
                      height: 330,
                      child: ScrollConfiguration(
                        behavior: MyCustomScrollBehavior(),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: recipes!.length,
                          shrinkWrap: true,
                          itemBuilder: ((context, index) {
                            var recipe = recipes![index];
                            return SizedBox(
                              width: 400,
                              child: RecipeCard(recipe),
                            );
                          }),
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              width: 15,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
