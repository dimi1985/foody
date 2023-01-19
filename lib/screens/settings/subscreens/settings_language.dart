import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SettingsLanguage extends StatelessWidget {
  const SettingsLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultTargetPlatform == TargetPlatform.android
          ? AppBar(
              title: Text('Language Settings'),
            )
          : null,
      body: Center(
        child: Text('Language Settings'),
      ),
    );
  }
}
