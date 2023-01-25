import 'package:flutter/material.dart';
import 'package:foody/models/recipe.dart';
import 'package:foody/screens/widgets/recipe_details.dart';
import 'package:foody/utils/http_service.dart';

class AdminRecipesCard extends StatefulWidget {
  final Recipe recipe;
  final List<Recipe> recipies;
  const AdminRecipesCard(this.recipe, this.recipies, {super.key});

  @override
  State<AdminRecipesCard> createState() => _AdminRecipesCardState();
}

class _AdminRecipesCardState extends State<AdminRecipesCard> {
  bool isLoading = false;
  bool isApproved = false;
  @override
  void initState() {
    isLoading = false;
    isApproved = widget.recipe.isApproved;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: ListTile(
        key: UniqueKey(),
        leading: SizedBox(
            width: MediaQuery.of(context).size.width / 5,
            height: MediaQuery.of(context).size.height / 5,
            child: Image.network(
                '${HttpService.url}' '${widget.recipe.recipeImage}')),
        title: GestureDetector(
          onTap: () => _gotoDetailRecipeScreen(widget.recipe),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text(widget.recipe.recipeName)),
                  Expanded(child: Text('(${widget.recipe.recipeUserName})')),
                ],
              ),
              Text('(${widget.recipe.recipeId})'),
            ],
          ),
        ),
        trailing: !isApproved
            ? SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: !isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.cancel_outlined,
                              size: 30,
                              color: Color.fromARGB(255, 196, 15, 123),
                            ),
                            onPressed: () {
                              //Implemet no aprroval
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.check_outlined,
                              size: 30,
                              color: Color.fromARGB(255, 38, 229, 168),
                            ),
                            onPressed: () {
                              _approveRecipe(widget.recipe.recipeId);
                            },
                          )
                        ],
                      )
                    : const Text('loading'),
              )
            : Text(widget.recipe.isApproved
                ? 'already approved'
                : isApproved
                    ? 'ok'
                    : 'something went wrong'),
      ),
    );
  }

  void _gotoDetailRecipeScreen(Recipe recipeItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetails(
          recipe: recipeItem,
        ),
      ),
    );
  }

  _approveRecipe(String recipeId) async {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () async {
      await HttpService.approveRecipe(widget.recipe.recipeId, true)
          .then((value) {
        if (mounted) {
          setState(() {
            //value.serverMessage.contains('Recipe Approved'
            isApproved = true;
          });
        }
      });
    });
  }
}
