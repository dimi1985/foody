import 'package:flutter/material.dart';
import 'package:foody/models/recipe.dart';
import 'package:foody/screens/discovery/widgets/category_card.dart';
import 'package:foody/screens/recipeByCategoryPage/recipe_by_category_page.dart';
import 'package:foody/screens/widgets/recipe_card.dart';
import 'package:foody/utils/custom_scroll_behavior.dart';
import 'package:foody/utils/http_service.dart';

import '../../models/category.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  final List<CategoryModel>? categories = [];
  late Future<CategoryModel>? futureCategory;
  final List<Recipe>? recipes = [];
  late Future<Recipe>? futureRecipe;
  List<Recipe> uniqueRecipelist = [];

  // ScrollBehavior can be set for a specific widget.
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    futureCategory = HttpService.getAllCategories(categories!);
    futureRecipe = HttpService.getAllRecipies(recipes!);
    var seen = <String>{};
    uniqueRecipelist =
        recipes!.where((recipe) => seen.add(recipe.recipeName)).toList();
//output list: John Cena, Jack Sparrow, Harry Potter
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<CategoryModel>(
          future: futureCategory,
          builder: (context, snapshot) {
            return SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: size.width,
                    height: size.height * 0.5 / 2,
                    child: Center(
                      child: ScrollConfiguration(
                        behavior: MyCustomScrollBehavior(),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories!.length,
                          shrinkWrap: true,
                          itemBuilder: ((context, index) {
                            var category = categories![index];
                            return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RecipeByCategoryPage(category)),
                                  );
                                },
                                child: CategoryCard(category));
                          }),
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              width: 15,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Latest Recipes',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<Recipe>(
                      future: futureRecipe,
                      builder: ((context, snapshot) {
                        return ScrollConfiguration(
                          behavior: MyCustomScrollBehavior(),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: recipes!.length,
                            shrinkWrap: true,
                            itemBuilder: ((context, index) {
                              var recipe = recipes![index];
                              return SizedBox(
                                height: size.height,
                                width: size.width,
                                child: RecipeCard(recipe),
                              );
                            }),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(
                                width: 15,
                              );
                            },
                          ),
                        );
                      })),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Latest Users',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<Recipe>(
                      future: futureRecipe,
                      builder: ((context, snapshot) {
                        return ScrollConfiguration(
                          behavior: MyCustomScrollBehavior(),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: uniqueRecipelist.length,
                            shrinkWrap: true,
                            itemBuilder: ((context, index) {
                              var uniqueRecipelistItem =
                                  uniqueRecipelist[index];
                              return SizedBox(
                                height: size.height / 2,
                                width: size.width / 3,
                                child: Container(
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child:
                                      Text(uniqueRecipelistItem.recipeUserName),
                                ),
                              );
                            }),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(
                                width: 15,
                              );
                            },
                          ),
                        );
                      })),
                ),
              ],
            ));
          }),
    );
  }
}
