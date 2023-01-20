import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foody/models/recipe.dart';
import 'package:foody/utils/http_service.dart';

class RecipeDetails extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetails({super.key, required this.recipe});

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  String? recipeImage;

  @override
  void initState() {
    recipeImage = '${HttpService.url}'
            '${widget.recipe.recipeImage}'
        .replaceAll(r'\', '/');
    //List<Widget> widgets = list.map((name) => new Text(name)).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: defaultTargetPlatform == TargetPlatform.android ? AppBar() : null,
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            //recipe title
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Text(
                widget.recipe.recipeName,
                style: const TextStyle(
                  fontSize: 50,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //recipe time and duration
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Duration: ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(text: widget.recipe.recipeDuration.toString()),
                      const TextSpan(
                        text: ' mins',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const Text(' | '),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Difficulty: ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(text: widget.recipe.recipeDifficulty),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.5,
              child: size.width < 600
                  ? SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Image.network(recipeImage!),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Ingredients'),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.recipe.ingredients
                                      .toString()
                                      .replaceAll("[", "")
                                      .replaceAll("]", ""),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Preparation'),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.recipe.recipePreparation,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Ingredients'),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.recipe.ingredients
                                    .toString()
                                    .replaceAll("[", "")
                                    .replaceAll("]", ""),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Preparation'),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.recipe.recipePreparation,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: Image.network(recipeImage!),
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
