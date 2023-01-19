import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:foody/models/settingsModel.dart';
import 'package:foody/screens/dashboard/admin_panel.dart.dart';
import 'package:foody/screens/settings/subscreens/settings_language.dart';
import 'package:foody/screens/settings/subscreens/settings_theme.dart';
import 'package:foody/screens/settings/subscreens/settings_user.dart';

class SettingPage extends StatefulWidget {
  final String? userType;
  const SettingPage({super.key, required this.userType});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isHovered = false;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void initState() {
    addAdmin();
    super.initState();
  }

  List<SettingsModel> settingsName = [
    SettingsModel(title: 'User Settings', page: const SettingsUser()),
    SettingsModel(title: 'Theme Settings', page: const SettingsTheme()),
    SettingsModel(
      title: 'Language Settings',
      page: const SettingsLanguage(),
    ),
    SettingsModel(
      title: 'Admin Panel',
      page: const AdminPanel(),
    )
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultTargetPlatform == TargetPlatform.android
            ? Colors.deepPurple
            : Colors.white,
        elevation: 0,
        title: const Text('Settings Page'),
        iconTheme: IconThemeData(
          color: defaultTargetPlatform == TargetPlatform.android
              ? Colors.white
              : Colors.black, //change your color here
        ),
      ),
      body: kIsWeb && size.width > 600
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: size.width < 600 ? 2 : 1,
                  child: SizedBox(
                    height: double.infinity,
                    child: Card(
                      elevation: 10,
                      shadowColor: Colors.deepPurple,
                      child: Column(
                        children: [
                          const SafeArea(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Settings',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          ListView.builder(
                            itemCount: settingsName.length,
                            shrinkWrap: true,
                            itemBuilder: ((context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    onAddButtonTapped(index);
                                  });
                                },
                                onHover: (value) {
                                  value = true;
                                },
                                child: Card(
                                  child: ListTile(
                                    title: Text(settingsName[index].title),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: size.width < 600 ? 2 : 3,
                  child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: PageView.builder(
                          controller: pageController,
                          itemCount: settingsName.length,
                          padEnds: true,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration:
                                  const BoxDecoration(color: Colors.white60),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: settingsName[index].page,
                              ),
                            );
                          })),
                )
              ],
            )
          : Column(
              children: [
                const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Settings',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount: settingsName.length,
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.of(context)
                              .push(_animatedRoute(settingsName, index));
                        });
                      },
                      onHover: (value) {
                        value = true;
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(settingsName[index].title),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
    );
  }

  void onAddButtonTapped(int index) {
    // or this to jump to it without animating
    pageController.jumpToPage(index);
  }

  Route _animatedRoute(List<SettingsModel> settingsName, int index) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          settingsName[index].page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void addAdmin() {
    if (widget.userType!.contains('user')) {
      if (mounted) {
        setState(() {
          settingsName.removeAt(3);
        });
      }
    }
  }
}
