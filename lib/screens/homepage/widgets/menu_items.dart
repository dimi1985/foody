import 'package:flutter/material.dart';
import 'package:foody/models/menuModel.dart';

class MenuItems extends StatefulWidget {
  final List<MenuModel> menuName;
  final int index;
  bool isHovered;
  Function(int index) onAddButtonTapped;
  MenuItems(this.menuName, this.index, this.isHovered, this.onAddButtonTapped,
      {super.key});

  @override
  State<MenuItems> createState() => _MenuItemsState();
}

class _MenuItemsState extends State<MenuItems> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.onAddButtonTapped(widget.index);
        });
      },
      onHover: (value) {
        setState(() {
          widget.isHovered = value;
          widget.isHovered = !!widget.isHovered;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10)),
          child: Container(
            height: 50,
            color: widget.isHovered ? Colors.amber : null,
            child: Center(
              child: Text(
                widget.menuName[widget.index].title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
