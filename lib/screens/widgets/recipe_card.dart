import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foody/models/category.dart';
import 'package:foody/models/recipe.dart';
import 'package:foody/screens/widgets/bottom_sheet_add_edit_recipe.dart';
import 'package:foody/screens/widgets/recipe_details.dart';
import 'package:foody/utils/http_service.dart';
import 'package:foody/utils/shared_preference.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hexcolor/hexcolor.dart';

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
  File mobileImage = File("zz");
  Uint8List webImage = Uint8List(10);
  TextEditingController nameController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController ingredController = TextEditingController();
  TextEditingController preparationController = TextEditingController();

  @override
  void initState() {
    isItMe();
    nameController = TextEditingController(text: widget.recipe.recipeName);
    durationController =
        TextEditingController(text: widget.recipe.recipeDuration.toString());
    preparationController =
        TextEditingController(text: widget.recipe.recipePreparation);
    super.initState();
  }

  @override
  void dispose() {
    nameController.clear();
    durationController.clear();
    preparationController.clear();

    super.dispose();
  }

  // Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => RecipeDetails(recipe: widget.recipe)),

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecipeDetails(recipe: widget.recipe)));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: SizedBox(
          height: size.height / 2.5,
          width: size.width,
          child: Card(
            color: HexColor(widget.recipe.categoryHexColor),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            elevation: 3.0,
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    SizedBox(
                      height: size.height < 1000
                          ? size.height / 4.0
                          : size.height / 3.0,
                      width: size.width,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.network(
                          recipeImage(),
                          fit: BoxFit.cover,
                          height: size.height,
                          width: size.width,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6.0,
                      right: 6.0,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            widget.recipe.recipeDifficulty,
                            style: TextStyle(
                                fontSize: 10.0,
                                fontFamily: GoogleFonts.getFont(
                                        widget.recipe.categoryGoogleFont)
                                    .fontFamily),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6.0,
                      left: 6.0,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            widget.recipe.recipeCategoryname,
                            style: TextStyle(
                                fontSize: 10.0,
                                color: HexColor(widget.recipe.categoryHexColor),
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.getFont(
                                        widget.recipe.categoryGoogleFont)
                                    .fontFamily),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7.0),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      widget.recipe.recipeName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w800,
                          fontFamily: GoogleFonts.getFont(
                                  widget.recipe.categoryGoogleFont)
                              .fontFamily),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                const SizedBox(height: 7.0),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      widget.recipe.recipeUserName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w300,
                          fontFamily: GoogleFonts.getFont(
                                  widget.recipe.categoryGoogleFont)
                              .fontFamily),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
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
          Expanded(
            flex: 2,
            child: Text(
              widget.recipe.recipeUserName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
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
            flex: 2,
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
            Flexible(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  showBottomMenu();
                },
                icon: const Icon(Icons.menu),
              ),
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
      height: 150,
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
    final List<CategoryModel> categories = [];
    late Future<CategoryModel> futureCategory;
    int selectedIndex = 0;
    futureCategory = HttpService.getAllCategories(categories);

    Color widgetColor = const Color.fromARGB(220, 255, 5, 105);

    nameController = TextEditingController();

    Scaffold.of(context).showBottomSheet<void>(
      (BuildContext context) {
        return BottomSheetAddEditRecipe(
            mobileImage,
            recipeImage,
            webImage,
            selectImage,
            futureCategory,
            categories,
            selectedIndex,
            widgetColor,
            widget.recipe,
            durationController,
            ingredController,
            preparationController,
            nameController,
            updateRecipe);
      },
    );
  }

  void selectImage(StateSetter setModalState) async {
    // MOBILE
    if (!kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);

        setModalState(() {
          mobileImage = selected;
        });
      } else {
        // showToast("No file selected");
      }
    }
    // WEB
    else if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setModalState(() {
          mobileImage = File("a");
          webImage = f;
        });
      } else {
        // showToast("No file selected");
      }
    } else {
      // showToast("Permission not granted");
    }
  }

  void updateRecipe() async {
    String categoryName = await GlobalSharedPreference.getCategoryName();
    String categoryId = await GlobalSharedPreference.getCategoryID();
    HttpService.updateRecipe(
            widget.recipe.recipeId,
            nameController.text.trim(),
            durationController.text.trim(),
            ingredController.text.trim(),
            preparationController.text.trim(),
            categoryName,
            categoryId,
            widget.recipe.categoryHexColor,
            widget.recipe.categoryGoogleFont)
        .whenComplete(() {
      HttpService.updateRecipeImage(
          mobileImage, webImage, widget.recipe.recipeId);
    });
  }
}
