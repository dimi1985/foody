import 'package:flutter/material.dart';
import 'package:foody/models/category.dart';
import 'package:foody/utils/http_service.dart';

class CategoryCard extends StatefulWidget {
  final CategoryModel category;
  const CategoryCard(this.category, {super.key});

  @override
  State<CategoryCard> createState() => _CategoryState();
}

class _CategoryState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  '${HttpService.url}' '${widget.category.categoryImage}'
                      .replaceAll(r'\', '/')),
              fit: BoxFit.cover),
          color: const Color.fromARGB(255, 105, 105, 105),
          borderRadius: BorderRadius.circular(15)),
      child: Text(
        widget.category.categoryName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
