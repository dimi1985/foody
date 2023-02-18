import 'package:flutter/material.dart';
import 'package:foody/models/recipe.dart';
import 'package:foody/screens/widgets/recipe_card.dart';
import 'package:foody/utils/http_service.dart';
import 'package:foody/utils/size_screen.dart';

class FeedRecipe extends StatefulWidget {
  const FeedRecipe({super.key});

  @override
  State<FeedRecipe> createState() => _FeedRecipeState();
}

class _FeedRecipeState extends State<FeedRecipe> {
  Future<Recipe>? getFutureRecipes;
  List<Recipe>? recipes = [];

  @override
  void initState() {
    getFutureRecipes = HttpService.getRecipiesSortBy(recipes!);
    super.initState();
  }

  MaterialColor mainColor = Colors.deepOrange;
  TextStyle appBarTextStyle = const TextStyle(color: Colors.deepOrange);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Foody',
          style: appBarTextStyle,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: mainColor,
              )),
        ],
      ),
      body: FutureBuilder<Recipe>(
        future: getFutureRecipes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return listviewRecipe(size);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget listviewRecipe(Size size) {
    return Center(
      child: SizedBox(
        width: SizeScreen.isMobile(context) ? size.width : 600,
        child: ListView.builder(
          itemCount: recipes!.length,
          shrinkWrap: true,
          itemBuilder: ((context, index) {
            var recipe = recipes![index];
            return RecipeCard(recipe);
          }),
        ),
      ),
    );
  }
}
