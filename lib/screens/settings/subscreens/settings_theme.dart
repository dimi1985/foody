import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:foody/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsTheme extends StatefulWidget {
  const SettingsTheme({super.key});

  @override
  State<SettingsTheme> createState() => _SettingsThemeState();
}

class _SettingsThemeState extends State<SettingsTheme> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: defaultTargetPlatform == TargetPlatform.android
          ? AppBar(
              title: const Text('Theme Settings'),
            )
          : null,
      body: Center(
        child: ListTile(
          leading: Text('Dark Mode'),
          trailing: Checkbox(
              value: themeChange.darkTheme,
              onChanged: (value) {
                themeChange.darkTheme = value!;
              }),
        ),
      ),
    );
  }
}
