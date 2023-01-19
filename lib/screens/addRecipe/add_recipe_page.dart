import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:foody/utils/shared_preference.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:foody/models/category.dart';
import 'package:foody/models/recipe.dart';
import 'package:foody/utils/http_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({Key? key}) : super(key: key);

  @override
  State<AddRecipePage> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final scaffoldState = GlobalKey<ScaffoldState>();
  final nameController = TextEditingController();
  final durationController = TextEditingController();
  final preparationController = TextEditingController();
  late File _pickedImage = File('');
  bool isLoading = false;
  bool isUploaded = false;

  final List<CategoryModel> _categories = [];
  late Future<CategoryModel> _futureCategory;

  int selectedIndex = 0;

  var nameRecipe = '';
  var durationRecipe = '';
  var durationPreparation = '';

  final List<String> ingredientList = [];

  final List<TextEditingController> _controllers = [];
  final List<TextFormField> _fields = [];

  List<DropdownMenuItem<String>> get dropdownItemsDifficulty {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: const Text("Easy"), value: "Easy"),
      DropdownMenuItem(child: const Text("Advanded"), value: "Advanded"),
      DropdownMenuItem(child: const Text("Hard"), value: "Hard"),
    ];
    return menuItems;
  }

  String selectedValueDiffiCulty = "Easy";

  @override
  void initState() {
    _futureCategory =
        HttpService.getAllCategories(_categories).then((value) async {
      return Future.value(value);
    });

    super.initState();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    durationController.dispose();
    preparationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CategoryModel>(
        future: _futureCategory,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: kIsWeb
                  ? null
                  : AppBar(
                      elevation: 0,
                      backgroundColor:
                          HexColor(_getCategoryColor(selectedIndex)),
                      actions: [
                        Container(
                          margin: const EdgeInsets.all(12),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                HexColor(
                                  _getCategoryColor(selectedIndex),
                                ),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _showSheet(context);
                              });
                            },
                            child: const Text(
                              'Preview',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                      title: const Text(
                        'Add Recipe',
                        style: TextStyle(
                            fontFamily: 'Caudex',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
              body: AnimatedContainer(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      HexColor(_getCategoryColor(selectedIndex)),
                      Colors.white,
                    ],
                  ),
                ),
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: ListView(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          _pickedImage.path.isEmpty
                              ? Container(
                                  height: 150,
                                )
                              : Image.file(
                                  _pickedImage,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.fitWidth,
                                ),
                          Positioned(
                            bottom: 10,
                            left: 130,
                            child: ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  HexColor(
                                    _getCategoryColor(selectedIndex),
                                  ),
                                ),
                              ),
                              onPressed: _imgFromGallery,
                              icon: const Icon(
                                Icons.photo_album_outlined,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Add Photo',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: SizedBox(
                          height: 40.0, // 35
                          child: FutureBuilder<CategoryModel>(
                              future: _futureCategory,
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _categories.length,
                                      itemBuilder: (context, index) {
                                        return listCategoryItems(index);
                                      });
                                }
                                return const Text('Loading...');
                              })),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: const Text('Difficulty:')),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                                underline: Container(), //empty line
                                value: selectedValueDiffiCulty,
                                isExpanded: true,
                                dropdownColor: Colors.blueGrey,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedValueDiffiCulty = newValue!;
                                  });
                                },
                                items: dropdownItemsDifficulty,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Form(
                        key: _formKey,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextFormField(
                                  controller: nameController,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.all(20.0),
                                      hintText: 'Name Recipe',
                                      border: InputBorder.none,
                                      hintStyle: const TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 15.0),
                                      hintMaxLines: 20),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextFormField(
                                  controller: durationController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(20.0),
                                    hintText: 'Preparation Duration',
                                    border: InputBorder.none,
                                    hintStyle: const TextStyle(
                                        color: Colors.blueGrey, fontSize: 15.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: 300,
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Row(children: [
                                const Text('Press + to Add Recipe'),
                                IconButton(
                                    onPressed: _addTextFields,
                                    icon: const Icon(Icons.add))
                              ]),
                            ),
                            Expanded(child: _listView()),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SizedBox(
                            height: 200,
                            child: TextFormField(
                              controller: preparationController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 100,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(20.0),
                                border: InputBorder.none,
                                hintText: 'First we cut the vegetables and...',
                                hintStyle:
                                    const TextStyle(color: Colors.blueGrey),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  _getCategoryName(int selectedIndex) {
    return _categories[selectedIndex];
  }

  _getRecipeName() {
    return nameController.text;
  }

  _getRecipeDuration() {
    return durationController.text;
  }

  _getRecipePreparation() {
    return preparationController.text;
  }

  _getDifficulty() {
    return selectedValueDiffiCulty;
  }

  _getCategoryID(int index) {
    var catId = _categories[index].categoryId;

    return catId;
  }

  _getCategoryColor(int index) {
    var catColor = '';
    if (_categories.isNotEmpty) {
      catColor = _categories[index].categoryHexColor;
    } else {
      catColor = '#65e88f';
    }

    return catColor;
  }

  _getCategoryFont(int index) {
    GlobalSharedPreference.clearTempGoogleFont();
    var catFont = _categories[index].categoryGoogleFont;
    GlobalSharedPreference.setTempGoogleFont(catFont);
    return catFont;
  }

  void _showSheet(BuildContext context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter bottomSheetState) {
            return Scaffold(
              backgroundColor: const Color(0xFFE9E9E9),
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    snap: false,
                    floating: false,
                    backgroundColor: Colors.transparent,
                    expandedHeight: 200,
                    flexibleSpace: FlexibleSpaceBar(
                      background: ClipRRect(
                        child: _pickedImage.path.isEmpty
                            ? Center(
                                child: const Text(
                                  'Please Select an Image',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              )
                            : Image.file(
                                _pickedImage,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const SizedBox(
                          height: 20,
                        ),
                        ListTile(
                          title: Container(
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2.0,
                                color: selectedIndex == -1
                                    ? HexColor(
                                        _getCategoryColor(selectedIndex),
                                      )
                                    : Colors.green,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child:
                                Text(_getCategoryName(selectedIndex).toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: HexColor(
                                        _getCategoryColor(selectedIndex),
                                      ),
                                      fontWeight: FontWeight.w500,
                                    )),
                          ),
                          subtitle: Text(
                            _getRecipeName(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    _getDifficulty(),
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Icon(
                                    Icons.access_time,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    _getRecipeDuration(),
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                  const Text(
                                    'min',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Text(
                            "INGREDIENTS",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  _getRecipeIngredients()
                                      .toString()
                                      .replaceAll("[", "")
                                      .replaceAll("]", ""),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: const Text(
                            "PREPARATION",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 32),
                          child: Text(
                            _getRecipePreparation(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : !isUploaded
                                    ? const Text('Upload')
                                    : const Icon(Icons.check),
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (mounted) {
                                      bottomSheetState(() {
                                        isLoading = true;
                                        //Todo
                                        // Navigator.pushAndRemoveUntil(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         const SuccesAddEditScreen(
                                        //             'add'),
                                        //   ),
                                        //   (Route<dynamic> route) => false,
                                        // );
                                        saveRecipeToServer(bottomSheetState);
                                      });
                                    }
                                  }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  // _pickImage() {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return SafeArea(
  //           child: Wrap(
  //             children: [
  //               ListTile(
  //                   leading: const Icon(Icons.photo_library),
  //                   title: const Text('Photo Library').tr(),
  //                   onTap: () {
  //                     _imgFromGallery();
  //                     Navigator.of(context).pop();
  //                   }),
  //               ListTile(
  //                 leading: const Icon(Icons.photo_camera),
  //                 title: const Text('Camera').tr(),
  //                 onTap: () {
  //                   _imgFromCamera();
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  void _imgFromGallery() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });
  }

  Widget listCategoryItems(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          _getCategoryID(index);
          _getCategoryColor(index);
          _getCategoryFont(index);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 5.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0, //20
          vertical: 10.0, //5
        ),
        decoration: BoxDecoration(
            color: selectedIndex == index
                ? const Color(0xFFEFF3EE)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0)),
        child: Text(
          _categories[index].categoryName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: selectedIndex == index
                ? ThemeData.estimateBrightnessForColor(
                            HexColor(_getCategoryColor(selectedIndex))) ==
                        Brightness.light
                    ? Colors.red
                    : Colors.orange
                : const Color(0xFFEFF3EE),
          ),
        ),
      ),
    );
  }

  void _addTextFields() {
    var field = TextFormField();
    final controller = TextEditingController();
    field = TextFormField(
      controller: controller,
      decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20.0),
          hintText: 'Add Ingredient',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15.0),
          suffixIcon: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _fields.remove(field);
                _controllers.remove(controller);
              });
            },
          )),
    );

    setState(() {
      _controllers.add(controller);
      _fields.add(field);
    });
  }

  _listView() {
    return LimitedBox(
      child: ListView.builder(
        itemCount: _fields.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(5),
            ),
            margin: const EdgeInsets.all(5),
            child: _fields[index],
          );
        },
      ),
    );
  }

  _getRecipeIngredients() {
    ingredientList.clear();
    for (int i = 0; i < _controllers.length; i++) {
      ingredientList.add(_controllers[i].text);
    }

    return ingredientList;
  }

  Future saveRecipeToServer(StateSetter bottomSheetState) async {
    String createdAt =
        DateFormat("MMM, EEE, yyyy, kk:mm").format(DateTime.now());
    String userId = await GlobalSharedPreference.getUserID();
    String username = await GlobalSharedPreference.getUserName();
    String userImage = await GlobalSharedPreference.getUserImage();
//"http://10.0.2.2:3000/recipes"

    var url = defaultTargetPlatform == TargetPlatform.android
        ? Uri.parse(
            '${HttpService.baseUrlMobile}' '${HttpService.recipiesEndPoint}')
        : Uri.parse(
            '${HttpService.baseUrlWeb}' '${HttpService.recipiesEndPoint}');

    var request = http.MultipartRequest("POST", url);

    request.fields['ingredients'] =
        ingredientList.toString().replaceAll("[", "").replaceAll("]", "");
    request.fields['recipeDuration'] = _getRecipeDuration();
    request.fields['recipeName'] = _getRecipeName();
    request.fields['recipePreparation'] = _getRecipePreparation();
    request.fields['recipeCategoryname'] =
        _getCategoryName(selectedIndex).toString();
    request.files
        .add(await http.MultipartFile.fromPath('recipeImage', _pickedImage.path,
            contentType: MediaType(
              'image',
              'jpeg',
            )));
    request.fields['recipeUserImagePath'] = userImage;
    request.fields['categoryId'] = _getCategoryID(selectedIndex);
    request.fields['userId'] = userId;

    request.fields['recipeUserName'] = username;
    request.fields['createdAt'] = createdAt;
    request.fields['recipeDifficulty'] = selectedValueDiffiCulty;
    request.fields['categoryHexColor'] = _getCategoryColor(selectedIndex);
    request.fields['categoryGoogleFont'] = _getCategoryFont(selectedIndex);
    request.headers['Content-Type'] = "multipart/form-data";

    request.send().then((response) {
      if (response.statusCode == 201) {
        if (mounted) {
          bottomSheetState(() {
            isLoading = false;
            isUploaded = true;
          });
        }
      }
    });
  }
}
