import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SettingsTheme extends StatelessWidget {
  const SettingsTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultTargetPlatform == TargetPlatform.android
          ? AppBar(
              title: Text('Theme Settings'),
            )
          : null,
      body: Center(
        child: Text('Theme Settings'),
      ),
    );
  }
}
