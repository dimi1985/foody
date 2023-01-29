import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:foody/models/recipe.dart';
import 'package:foody/screens/profile/profile_screen.dart';
import 'package:foody/utils/http_service.dart';
import 'package:foody/utils/shared_preference.dart';

class RecipeDetails extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetails({super.key, required this.recipe});

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  var top = 0.0;
  late ScrollController controller;
  bool isCollapsed = false;
  String actionRoute = 'detailsPage';
  bool isMe = false;
  late String loggedUserId;
  late String recipeID;
  @override
  void initState() {
    //List<Widget> widgets = list.map((name) => new Text(name)).toList();
    controller = ScrollController()..addListener(onScroll);
    isMyRecipe();
    super.initState();
  }

  void onScroll() {
    if (mounted) {
      if (controller.position.pixels >= 300) {
        setState(() {
          isCollapsed = true;
        });
      } else {
        setState(() {
          isCollapsed = false;
        });
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        controller: controller,
        slivers: <Widget>[
          //2
          SliverAppBar(
            collapsedHeight: 110,
            expandedHeight: 350.0,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                top = constraints.biggest.height;
                return Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        foregroundDecoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Color.fromARGB(141, 28, 44, 53),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0, 0.7],
                          ),
                        ),
                        child: Image.network(
                          recipeImage(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: top < 120
                              ? const EdgeInsets.only(bottom: 8.0, left: 16)
                              : const EdgeInsets.only(bottom: 8.0),
                          child: recipeName(top),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: size.height,
                width: size.width,
                child: ListView(
                  children: ListTile.divideTiles(context: context, tiles: [
                    ListTile(
                      title: profileContainer(),
                    ),
                    ListTile(
                      title: SizedBox(
                        width: double.infinity,
                        height: size.height,
                        child: MaterialApp(
                          debugShowCheckedModeBanner: false,
                          theme: ThemeData(
                            tabBarTheme: const TabBarTheme(
                              labelColor: Colors.deepOrange,
                              unselectedLabelColor: Colors.grey,
                            ),
                          ),
                          home: DefaultTabController(
                            length: 2,
                            child: Scaffold(
                              appBar: PreferredSize(
                                preferredSize: const Size.fromHeight(50.0),
                                child: AppBar(
                                  elevation: 0,
                                  backgroundColor: Colors.white10,
                                  bottom: const TabBar(
                                    indicatorColor: Colors.deepOrange,
                                    tabs: [
                                      Tab(text: 'Ingredients'),
                                      Tab(text: 'Preparation'),
                                    ],
                                  ),
                                ),
                              ),
                              body: TabBarView(
                                children: [ingredients(), preparation()],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]).toList(),
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }

  Widget profileContainer() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 8,
            backgroundImage: NetworkImage(
              ('${HttpService.url}' '${widget.recipe.recipeUserImagePath}'),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(widget.recipe.recipeUserName),
        ],
      ),
      const Spacer(
        flex: 3,
      ),
      MaterialButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(widget.recipe.userId, loggedUserId)),
          );
        },
        child: const Text('View Profile'),
      )
    ]);
  }

  String recipeImage() {
    return '${HttpService.url}'
            '${widget.recipe.recipeImage}'
        .replaceAll(r'\', '/');
  }

  Widget recipeName(double top) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.recipe.recipeName,
          style: TextStyle(
            fontSize: isCollapsed ? 10 : 30,
            color: const Color.fromARGB(255, 68, 68, 68),
            fontWeight: FontWeight.bold,
          ),
          textScaleFactor: 2,
        ),
        SizedBox(
          height: isCollapsed ? 0 : 25,
        ),
        AnimatedOpacity(
          opacity: isCollapsed ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 500),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                categoryName(),
                const Spacer(
                  flex: 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: durationPreparation(),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget categoryName() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.category,
          color: Colors.deepOrange,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          widget.recipe.recipeCategoryname,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget durationPreparation() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.alarm,
          color: Colors.deepOrange,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          '${widget.recipe.recipeDuration.toString()} mins',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget ingredients() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: widget.recipe.ingredients.length,
        itemBuilder: (context, index) {
          var item = widget.recipe.ingredients;
          return ListTile(
            title: Text(item[index]),
          );
        },
      ),
    );
  }

  Widget preparation() {
    return Padding(
      //200 is putting it to center ?? check it
      padding: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          widget.recipe.recipePreparation,
        ),
      ),
    );
  }

  void isMyRecipe() async {
    GlobalSharedPreference.getUserID().then((value) {
      setState(() {
        loggedUserId = value;

        if (widget.recipe.userId == loggedUserId) {
          isMe = true;
        }
      });
      return value;
    });
  }
}
