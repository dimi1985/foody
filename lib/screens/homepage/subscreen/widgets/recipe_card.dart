import 'package:flutter/material.dart';
import 'package:foody/models/recipe.dart';
import 'package:foody/screens/widgets/recipe_details.dart';
import 'package:foody/utils/http_service.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  const RecipeCard(this.recipe, {super.key});

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        goDetails(widget.recipe);
      },
      child: Container(
        height: size.width < 600 ? 200 : null,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    '${HttpService.url}' '${widget.recipe.recipeImage}'
                        .replaceAll(r'\', '/')),
                fit: BoxFit.cover),
            color: const Color.fromARGB(255, 105, 105, 105),
            borderRadius: BorderRadius.circular(15)),
        child: Text(
          widget.recipe.recipeName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void goDetails(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipeDetails(recipe: recipe)),
    );
  }
}
