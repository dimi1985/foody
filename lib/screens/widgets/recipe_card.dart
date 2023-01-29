import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foody/models/category.dart';
import 'package:foody/models/recipe.dart';
import 'package:foody/screens/widgets/recipe_details.dart';
import 'package:foody/utils/http_service.dart';
import 'package:foody/utils/shared_preference.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/size_screen.dart';

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
      child: SizedBox(
        height: size.height / 1.5,
        width: size.width,
        child: Card(
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(child: userNameProfile()),
                    Spacer(flex: size.width < 600 ? 1 : 2),
                    Flexible(child: dateRecipeCreated()),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: mainRecipeImageStacked(size),
              )
            ],
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
    final List<CategoryModel> categories = [];
    late Future<CategoryModel> futureCategory;
    int selectedIndex = 0;
    futureCategory = HttpService.getAllCategories(categories);

    Color widgetColor = const Color.fromARGB(220, 255, 5, 105);

    Scaffold.of(context).showBottomSheet<void>(
      (BuildContext context) {
        return SingleChildScrollView(
          child: StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
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
                          height: 25,
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              (mobileImage.path == "zz")
                                  ? Expanded(
                                      child: Image.network(
                                        recipeImage(),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : (kIsWeb)
                                      ? Image.memory(
                                          webImage,
                                          width: SizeScreen.isMobile(context)
                                              ? 50
                                              : 300,
                                          height: SizeScreen.isMobile(context)
                                              ? 50
                                              : 300,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          mobileImage,
                                          width: 50,
                                          height: 50,
                                        ),
                              const SizedBox(
                                height: 20,
                                width: double.infinity,
                              ),
                              SizedBox(
                                width: SizeScreen.isMobile(context) ? 100 : 130,
                                height: SizeScreen.isMobile(context) ? 50 : 60,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red),
                                  ),
                                  onPressed: () {
                                    selectImage(setState);
                                  },
                                  child: Text(
                                    "Change Image",
                                    style: TextStyle(
                                        fontSize: SizeScreen.isMobile(context)
                                            ? 12
                                            : 16),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FutureBuilder<CategoryModel>(
                            future: futureCategory,
                            builder: (context, snapshot) {
                              return SizedBox(
                                height: 40,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: categories.length,
                                    itemBuilder: ((context, index) {
                                      var categoryItem = categories[index];
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = index;
                                            if (selectedIndex == index) {
                                              setState(() {
                                                widgetColor = Colors.black;
                                                GlobalSharedPreference
                                                    .setCategoryID(categoryItem
                                                        .categoryId);
                                                GlobalSharedPreference
                                                    .setCategoryName(
                                                        categoryItem
                                                            .categoryName);
                                              });
                                            }
                                          });
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 5.0),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0, //20
                                            vertical: 10.0, //5
                                          ),
                                          decoration: BoxDecoration(
                                              color: selectedIndex == index
                                                  ? const Color.fromARGB(
                                                      255, 226, 130, 138)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(8.0)),
                                          child: Center(
                                            child: Text(
                                              categoryItem.categoryName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: categoryItem
                                                            .categoryName ==
                                                        widget.recipe
                                                            .recipeCategoryname
                                                    ? widgetColor
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    })),
                              );
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        Form(
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 243, 65, 33),
                                      width: 1),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: nameController,
                                  cursorColor:
                                      const Color.fromARGB(255, 148, 0, 86),
                                  //  controller: usernameController,
                                  decoration: const InputDecoration(
                                    // labelStyle: labelTextStyle,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                    enabledBorder: OutlineInputBorder(
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
                                padding:
                                    const EdgeInsets.only(top: 10, left: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 243, 65, 33),
                                      width: 1),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: durationController,
                                  cursorColor:
                                      const Color.fromARGB(255, 148, 0, 86),
                                  //  controller: usernameController,
                                  decoration: const InputDecoration(
                                    // labelStyle: labelTextStyle,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.recipe.ingredients.length,
                                itemBuilder: ((context, index) {
                                  for (int i = 0;
                                      i < widget.recipe.ingredients.length;
                                      i++) {
                                    ingredController = TextEditingController(
                                        text: widget.recipe.ingredients[index]);
                                  }
                                  return Container(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 243, 65, 33),
                                          width: 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: ingredController,
                                      cursorColor:
                                          const Color.fromARGB(255, 148, 0, 86),
                                      //  controller: usernameController,
                                      decoration: const InputDecoration(
                                        // labelStyle: labelTextStyle,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 243, 65, 33),
                                      width: 1),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: preparationController,
                                  cursorColor:
                                      const Color.fromARGB(255, 148, 0, 86),
                                  //  controller: usernameController,
                                  decoration: const InputDecoration(
                                    // labelStyle: labelTextStyle,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                          child: const Text('Update'),
                          onPressed: updateRecipe,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
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
    ).whenComplete(() {
      HttpService.updateRecipeImage(
          mobileImage, webImage, widget.recipe.recipeId);
    });
  }
}
