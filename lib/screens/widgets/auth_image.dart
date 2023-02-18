import 'package:flutter/material.dart';

class AuthImage extends StatelessWidget {
  const AuthImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/auth_bg.webp',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    );
  }
}
