import 'package:flutter/material.dart';
import 'package:foody/models/category.dart';
import 'package:foody/utils/http_service.dart';

class AdminCategories extends StatefulWidget {
  const AdminCategories({super.key});

  @override
  State<AdminCategories> createState() => _AdminCategoriesState();
}

class _AdminCategoriesState extends State<AdminCategories> {
  late Future<CategoryModel> getCategories;
  List<CategoryModel> listCategories = [];

  @override
  void initState() {
    getAllCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CategoryModel>(
        future: getCategories,
        builder: (context, snapshot) {
          return SizedBox(
            width: 400,
            height: 400,
            child: ListView.builder(
                itemCount: listCategories.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var category = listCategories[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text('Cat ID: ${category.categoryId}')),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.info_outline),
                      ),
                    ],
                  );
                }),
          );
        });
  }

  getAllCategories() {
    getCategories = HttpService.getAllCategories(listCategories).then((value) {
      return Future.value(value);
    });
  }
}
