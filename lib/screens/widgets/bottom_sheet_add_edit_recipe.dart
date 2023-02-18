// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foody/models/category.dart';
import 'package:foody/models/recipe.dart';
import 'package:foody/utils/shared_preference.dart';
import 'package:foody/utils/size_screen.dart';

class BottomSheetAddEditRecipe extends StatefulWidget {
  final File? mobileImage;
  final String? Function() recipeImage;
  final Uint8List? webImage;
  final void Function(StateSetter setModalState)? selectImage;
  final Future<CategoryModel>? futureCategory;
  final List<CategoryModel>? categories;
  int? selectedIndex;
  Color? widgetColor;
  Recipe? recipe;
  TextEditingController? durationController;
  TextEditingController? ingredController;
  TextEditingController? preparationController;
  TextEditingController? nameController;
  void Function()? updateRecipe;
  BottomSheetAddEditRecipe(
      this.mobileImage,
      this.recipeImage,
      this.webImage,
      this.selectImage,
      this.futureCategory,
      this.categories,
      this.selectedIndex,
      this.widgetColor,
      this.recipe,
      this.durationController,
      this.ingredController,
      this.preparationController,
      this.nameController,
      this.updateRecipe,
      {super.key});

  @override
  State<BottomSheetAddEditRecipe> createState() =>
      _BottomSheetAddEditRecipeState();
}

class _BottomSheetAddEditRecipeState extends State<BottomSheetAddEditRecipe> {
  @override
  Widget build(BuildContext context) {
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
                          (widget.mobileImage!.path == "zz")
                              ? Expanded(
                                  child: Image.network(
                                    widget.recipeImage() ?? '',
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : (kIsWeb)
                                  ? Image.memory(
                                      widget.webImage!,
                                      width: SizeScreen.isMobile(context)
                                          ? 50
                                          : 300,
                                      height: SizeScreen.isMobile(context)
                                          ? 50
                                          : 300,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      widget.mobileImage!,
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
                                widget.selectImage!(setState);
                              },
                              child: Text(
                                "Change Image",
                                style: TextStyle(
                                    fontSize:
                                        SizeScreen.isMobile(context) ? 12 : 16),
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
                        future: widget.futureCategory,
                        builder: (context, snapshot) {
                          return SizedBox(
                            height: 40,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.categories!.length,
                                itemBuilder: ((context, index) {
                                  var categoryItem = widget.categories![index];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        widget.selectedIndex = index;
                                        if (widget.selectedIndex == index) {
                                          setState(() {
                                            widget.widgetColor = Colors.black;
                                            GlobalSharedPreference
                                                .setCategoryID(
                                                    categoryItem.categoryId);
                                            GlobalSharedPreference
                                                .setCategoryName(
                                                    categoryItem.categoryName);
                                          });
                                        }
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 5.0),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, //20
                                        vertical: 10.0, //5
                                      ),
                                      decoration: BoxDecoration(
                                          color: widget.selectedIndex == index
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
                                            color: categoryItem.categoryName ==
                                                    widget.recipe!
                                                        .recipeCategoryname
                                                ? widget.widgetColor
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
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color.fromARGB(255, 243, 65, 33),
                                  width: 1),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            child: TextFormField(
                              controller: widget.nameController,
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
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color.fromARGB(255, 243, 65, 33),
                                  width: 1),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            child: TextFormField(
                              controller: widget.durationController,
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
                            itemCount: widget.recipe!.ingredients.length,
                            itemBuilder: ((context, index) {
                              for (int i = 0;
                                  i < widget.recipe!.ingredients.length;
                                  i++) {
                                widget.ingredController = TextEditingController(
                                    text: widget.recipe!.ingredients[index]);
                              }
                              return Container(
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
                                  controller: widget.ingredController,
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
                              );
                            }),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color.fromARGB(255, 243, 65, 33),
                                  width: 1),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            child: TextFormField(
                              controller: widget.preparationController,
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
                      onPressed: widget.updateRecipe,
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
