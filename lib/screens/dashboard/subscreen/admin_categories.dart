import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foody/models/category.dart';
import 'package:foody/utils/http_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AdminCategories extends StatefulWidget {
  const AdminCategories({super.key});

  @override
  State<AdminCategories> createState() => _AdminCategoriesState();
}

class _AdminCategoriesState extends State<AdminCategories> {
  late Future<CategoryModel> getCategories;
  List<CategoryModel> listCategories = [];
  bool isLoading = false;
  bool isUploaded = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController hexColorController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController googleFontController = TextEditingController();
  File mobileImage = File("zz");
  Uint8List webImage = Uint8List(10);

  @override
  void initState() {
    getAllCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<CategoryModel>(
        future: getCategories,
        builder: (context, snapshot) {
          return listCategories.isEmpty
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('No Data'),
                      ElevatedButton(
                        onPressed: (() => _showAddCatBottomSheet(size)),
                        child: const Text('Add Category'),
                      )
                    ],
                  ),
                )
              : SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: listCategories.length,
                          itemBuilder: (context, index) {
                            var category = listCategories[index];

                            return ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                child: ClipOval(
                                  child: Image.network(
                                    '${HttpService.url}'
                                            '${category.categoryImage}'
                                        .replaceAll(r'\', '/'),
                                    fit: BoxFit.cover,
                                    width: 60.0,
                                    height: 60.0,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: const Color.fromARGB(
                                            255, 188, 188, 189),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Whoops!',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(8.0),
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        category.categoryName,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.info_outline,
                                        size: 30,
                                        color: Colors.blueGrey,
                                      ),
                                      onPressed: () {
                                        _showCategoryDetailsBottomSheet(
                                            listCategories,
                                            index,
                                            category.categoryId);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        size: 30,
                                        color: Colors.blueGrey,
                                      ),
                                      onPressed: () {
                                        _showEditCatBottomSheet(listCategories,
                                            index, category, size);
                                      },
                                    )
                                  ]),
                            );
                          }),
                      ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                        ),
                        onPressed: () {
                          _showAddCatBottomSheet(size);
                        },
                        child: const Text('Add Category'),
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }

  getAllCategories() {
    getCategories = HttpService.getAllCategories(listCategories).then((value) {
      return Future.value(value);
    });
  }

  Future _showEditCatBottomSheet(categories, int index, category, Size size) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          isUploaded = false;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: SizedBox(
                  height: 400,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [imageContainer(size, setState)],
                      ),
                      TextField(
                        controller: nameController = TextEditingController()
                          ..text = categories[index].categoryName,
                      ),
                      TextField(
                        controller: hexColorController = TextEditingController()
                          ..text = categories[index].categoryHexColor,
                      ),
                      TextField(
                        controller:
                            googleFontController = TextEditingController()
                              ..text = categories[index].categoryGoogleFont,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          updateToServer(setState, category);
                        },
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : isUploaded
                                ? const Icon(Icons.check)
                                : const Text('Update'),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Future _showAddCatBottomSheet(Size size) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [imageContainer(size, setState)],
                    ),
                    TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(hintText: 'Category Name'),
                    ),
                    TextField(
                      controller: hexColorController,
                      decoration:
                          const InputDecoration(hintText: 'Category HexColor'),
                    ),
                    TextField(
                      controller: googleFontController,
                      decoration: const InputDecoration(
                          hintText: 'Category Google Font'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        saveToServer(setState).whenComplete(() {
                          if (!isLoading && isUploaded) {
                            setState(() {
                              Navigator.pop(context);
                            });
                          }
                        });
                      },
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : isUploaded
                              ? const Icon(Icons.check)
                              : const Text('Submit'),
                    )
                  ],
                ),
              ),
            );
          });
        }).whenComplete(() {});
  }

  void _showCategoryDetailsBottomSheet(
      categories, int index, String categoryId) {}

  saveToServer(StateSetter setState) async {
    var postUri =
        Uri.parse("${HttpService.url}${HttpService.getCategoriesEndPoint}");

    var request = http.MultipartRequest("POST", postUri);

    kIsWeb
        ? request.files.add(
            http.MultipartFile.fromBytes(
              'categoryImage',
              webImage,
              filename: 'image.jpg',
              contentType: MediaType('image', 'png'),
            ),
          )
        : request.files.add(
            await http.MultipartFile.fromPath('categoryImage', mobileImage.path,
                contentType: MediaType(
                  'image',
                  'jpeg',
                )));

    request.fields['categoryName'] = nameController.text.trim();
    request.fields['categoryHexColor'] = hexColorController.text.trim();
    request.fields['categoryGoogleFont'] = googleFontController.text.trim();

    request.headers['Content-Type'] = "multipart/form-data";

    request.send().then((response) {
      if (response.statusCode == 201) {
        if (mounted) {
          setState(() {
            isLoading = false;
            isUploaded = true;
          });
        }
      }
    });
  }

  Widget imageContainer(Size size, StateSetter setState) {
    return Column(
      children: [
        (mobileImage.path == "zz")
            ? const Text('Select Image')
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

  Future updateToServer(StateSetter setState, category) {
    setState(() {
      isLoading = true;
      isUploaded = false;
    });

    return HttpService.updateCategory(
      category.categoryId,
      nameController.text,
      hexColorController.text,
    ).then((value) {
      HttpService.updateCategoryImage(
          File(mobileImage.path), webImage, category.categoryId);
    }).whenComplete(() => setState(() {
          isLoading = false;
          isUploaded = true;
        }));
  }
}
