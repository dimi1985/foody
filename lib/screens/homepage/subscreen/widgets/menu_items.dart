import 'package:flutter/material.dart';
import 'package:foody/models/menuModel.dart';

class MenuItems extends StatefulWidget {
  final List<MenuModel> menuName;
  final int index;
  final PageController pageController;

  const MenuItems(this.menuName, this.index, this.pageController, {super.key});

  @override
  State<MenuItems> createState() => _MenuItemsState();
}

class _MenuItemsState extends State<MenuItems> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        setState(() {
          onAddButtonTapped(widget.index);
        });
      },
      onHover: (value) {
        setState(() {
          isHovered = value;
          isHovered = !!isHovered;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10)),
          child: Container(
            height: 50,
            color: isHovered ? const Color.fromARGB(255, 250, 132, 112) : null,
            child: Center(
              child: Text(
                widget.menuName[widget.index].title,
                style: TextStyle(
                  fontSize: size.width <= 800 ? 14 : 20,
                  fontWeight: FontWeight.bold,
                  color: isHovered
                      ? const Color.fromARGB(255, 121, 56, 226)
                      : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onAddButtonTapped(int index) {
    widget.pageController.jumpToPage(index);
  }
}
