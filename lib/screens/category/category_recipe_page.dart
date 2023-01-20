import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foody/screens/category/widgets/category_card.dart';
import 'package:foody/utils/http_service.dart';

import '../../models/category.dart';

class CategoryRecipePage extends StatefulWidget {
  const CategoryRecipePage({super.key});

  @override
  State<CategoryRecipePage> createState() => _CategoryRecipePageState();
}

class _CategoryRecipePageState extends State<CategoryRecipePage> {
  final List<CategoryModel>? categories = [];
  late Future<CategoryModel>? futureCategory;

  @override
  void initState() {
    futureCategory = HttpService.getAllCategories(categories!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<CategoryModel>(
          future: futureCategory,
          builder: (context, snapshot) {
            return kIsWeb ? gridLisview(size) : mobileListview();
          }),
    );
  }

  gridLisview(size) {
    return size.width < 600
        ? ListView.separated(
            itemCount: categories!.length,
            shrinkWrap: true,
            itemBuilder: ((context, index) {
              var category = categories![index];
              return CategoryCard(category);
            }),
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 10,
              );
            },
          )
        : Center(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: categories?.length,
                itemBuilder: (BuildContext ctx, index) {
                  var category = categories![index];
                  return CategoryCard(category);
                }),
          );
  }

  mobileListview() {
    return ListView.separated(
      itemCount: categories!.length,
      shrinkWrap: true,
      itemBuilder: ((context, index) {
        var category = categories![index];
        return CategoryCard(category);
      }),
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 10,
        );
      },
    );
  }
}
