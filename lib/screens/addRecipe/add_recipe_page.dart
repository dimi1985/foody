import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foody/models/category.dart';
import 'package:foody/models/user.dart';
import 'package:foody/utils/http_service.dart';
import 'package:foody/utils/size_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/services.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({Key? key}) : super(key: key);

  @override
  State<AddRecipePage> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipePage>
    with AutomaticKeepAliveClientMixin {
  final List<CategoryModel> _categories = [];
  late Future<CategoryModel> _futureCategory;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final durationController = TextEditingController();
  final preparationController = TextEditingController();
  File mobileImage = File("zz");
  Uint8List webImage = Uint8List(10);

  List<DropdownMenuItem<String>> get dropdownItemsDifficulty {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Easy", child: Text("Easy")),
      const DropdownMenuItem(value: "Advanded", child: Text("Advanded")),
      const DropdownMenuItem(value: "Hard", child: Text("Hard")),
    ];
    return menuItems;
  }

  String selectedValueDiffiCulty = "Easy";

  final List<String> ingredientList = [];

  final List<TextEditingController> _controllers = [];
  final List<TextFormField> _fields = [];

  int selectedIndex = 0;

  bool isLoading = false;
  bool isUploaded = false;

  late Future<User> getUser;
  String? id;
  String? username;
  String? email;
  String? userImage;
  String? userType;

  @override
  void initState() {
    getGategorieList();
    getUserFields();
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

  var toDeletefield = TextFormField();
  var toDeletecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<CategoryModel>(
        future: _futureCategory,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Size size = MediaQuery.of(context).size;
            return Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: defaultTargetPlatform == TargetPlatform.android
                          ? size.width
                          : size.width * 0.7,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        imageContainer(size),
                        Card(
                          elevation: 5,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                categoryList(size),
                                const SizedBox(
                                  height: 30,
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      defaultTargetPlatform ==
                                              TargetPlatform.android
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                nameTextField(),
                                                durationTextField(),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                nameTextField(),
                                                durationTextField(),
                                              ],
                                            ),
                                      difficultySelection(size),
                                      ingredientListTextField(),
                                      preparationTextField(),
                                      button(size),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Widget imageContainer(Size size) {
    return Column(
      children: [
        (mobileImage.path == "zz")
            ? const Text('Select Image')
            : (kIsWeb)
                ? Image.memory(
                    webImage,
                    width: SizeScreen.isMobile(context) ? 50 : 300,
                    height: SizeScreen.isMobile(context) ? 50 : 300,
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
          width: size.width < 600 ? 100 : 130,
          height: size.width < 600 ? 50 : 60,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            onPressed: () => selectImage(),
            child: Text(
              "Select Image",
              style: TextStyle(fontSize: size.width < 600 ? 12 : 16),
            ),
          ),
        )
      ],
    );
  }

  Future getGategorieList() async {
    _futureCategory =
        HttpService.getAllCategories(_categories).then((value) async {
      return Future.value(value);
    });
  }

  void getUserFields() {
    getUser = HttpService.getUserById('').then((value) {
      setState(() {
        id = value.id;
        username = value.username;
        email = value.email;
        userImage = value.userImage;
        userType = value.userType;
      });
      return Future.value(value);
    });
  }

  selectImage() async {
    // MOBILE
    if (!kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);

        setState(() {
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
        setState(() {
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

  Widget categoryList(Size size) {
    return SizedBox(
      height: 50,
      width: size.width * 0.7,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            return listCategoryItems(index);
          }),
    );
  }

  Widget nameTextField() {
    return Container(
      height: 50,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        controller: nameController,
        keyboardType: TextInputType.name,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(20.0),
            hintText: 'Name Recipe',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
            hintMaxLines: 20),
      ),
    );
  }

  Widget durationTextField() {
    return Container(
      height: 50,
      width: 100,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        controller: durationController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(20.0),
          hintText: 'Duration',
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
        ),
      ),
    );
  }

  Widget difficultySelection(Size size) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: size.width * 0.5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            style: const TextStyle(
                fontSize: 14, color: Color.fromARGB(255, 86, 20, 192)),
            underline: Container(), //empty line
            value: selectedValueDiffiCulty,
            isExpanded: true,
            dropdownColor: const Color.fromARGB(255, 255, 111, 68),
            onChanged: (String? newValue) {
              setState(() {
                selectedValueDiffiCulty = newValue!;
              });
            },
            items: dropdownItemsDifficulty,
          ),
        ),
      ),
    );
  }

  Widget ingredientListTextField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 300,
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              const Text('Press + to Add Recipe'),
              Expanded(
                  flex: 1,
                  child: IconButton(
                      onPressed: addTextFields, icon: const Icon(Icons.add)))
            ]),
            Expanded(
              flex: 1,
              child: SizedBox(
                width: 600,
                height: 240,
                child: ingredientlistViewTextField(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ingredientlistViewTextField() {
    return LimitedBox(
      maxHeight: 300,
      child: ListView.builder(
        itemCount: _fields.length,
        shrinkWrap: true,
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

  Widget preparationTextField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        reverse: true,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextFormField(
            controller: preparationController,
            keyboardType: TextInputType.multiline,
            maxLines: defaultTargetPlatform == TargetPlatform.android ? 10 : 20,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(20.0),
              border: InputBorder.none,
              hintText: 'First we cut the vegetables and...',
              hintStyle: TextStyle(color: Colors.blueGrey),
            ),
          ),
        ),
      ),
    );
  }

  button(Size size) {
    return Container(
      margin: const EdgeInsets.all(12),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red),
        ),
        onPressed: () {
          setState(() {
            _showSheet(context, size);
          });
        },
        child: const Text(
          'Preview',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void addTextFields() {
    var field = TextFormField();
    final controller = TextEditingController();
    setState(() {
      toDeletefield = field;
      toDeletecontroller = controller;
    });
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

  Widget listCategoryItems(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
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
                ? const Color.fromARGB(255, 226, 130, 138)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0)),
        child: Center(
          child: Text(
            _categories[index].categoryName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 85, 4, 4),
            ),
          ),
        ),
      ),
    );
  }

  void _showSheet(BuildContext context, Size size) {
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
                        child: mobileImage.path.isEmpty
                            ? const Center(
                                child: Text(
                                  'Please Select an Image',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              )
                            : (kIsWeb)
                                ? Image.memory(
                                    webImage,
                                    width: size.width < 600 ? 50 : 300,
                                    height: size.width < 600 ? 50 : 300,
                                  )
                                : Image.file(
                                    mobileImage,
                                    width: 50,
                                    height: 50,
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
                                color: const Color.fromARGB(255, 76, 91, 175),
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child:
                                Text(_getCategoryName(selectedIndex).toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 76, 91, 175),
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
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
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
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
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
                                  },
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : !isUploaded
                                    ? const Text('Upload')
                                    : const Icon(Icons.check)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
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

  _getRecipeIngredients() {
    ingredientList.clear();
    for (int i = 0; i < _controllers.length; i++) {
      ingredientList.add(_controllers[i].text);
    }

    return ingredientList;
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

  Future saveRecipeToServer(StateSetter bottomSheetState) async {
    String createdAt =
        DateFormat("MMM, EEE, yyyy, kk:mm").format(DateTime.now());

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

    kIsWeb
        ? request.files.add(
            http.MultipartFile.fromBytes(
              'recipeImage',
              webImage,
              filename: 'image.jpg',
              contentType: MediaType('image', 'png'),
            ),
          )
        : request.files.add(
            await http.MultipartFile.fromPath('recipeImage', mobileImage.path,
                contentType: MediaType(
                  'image',
                  'jpeg',
                )));

    request.fields['recipeUserImagePath'] = userImage!;
    request.fields['categoryId'] = _getCategoryID(selectedIndex);
    request.fields['userId'] = id!;

    request.fields['recipeUserName'] = username!;
    request.fields['createdAt'] = createdAt;
    request.fields['recipeDifficulty'] = selectedValueDiffiCulty;
    // request.fields['categoryHexColor'] = _getCategoryColor(selectedIndex);
    // request.fields['categoryGoogleFont'] = _getCategoryFont(selectedIndex);
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

  @override
  bool get wantKeepAlive => true;
}
