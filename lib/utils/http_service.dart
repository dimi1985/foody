import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:foody/models/category.dart';
import 'package:foody/models/recipe.dart';
import 'package:foody/utils/shared_preference.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import '../models/user.dart';

class HttpService {
  //http://localhost:3000/register

  static var registerEndPoint = 'user/register';
  static var loginEndPoint = 'user/login';
  static var getUsersEndPoint = 'user';
  static var getCategoriesEndPoint = 'categories';
  static var recipiesEndPoint = 'recipes';
  static var baseUrlMobile = 'http://10.0.2.2:3000/';
  static var baseUrlWeb = 'http://localhost:3000/';
  static var url = defaultTargetPlatform == TargetPlatform.android
      ? Uri.parse(baseUrlMobile)
      : Uri.parse(baseUrlWeb);

  static Future<User> registerUser({
    required String username,
    required String email,
    required String password,
    required String imgagePath,
    required String userType,
    required String createdAt,
  }) async {
    var url = defaultTargetPlatform == TargetPlatform.android
        ? Uri.parse('$baseUrlMobile' '$registerEndPoint')
        : Uri.parse('$baseUrlWeb' '$registerEndPoint');

    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'username': username,
          'email': email,
          'password': password,
          'userImage': imgagePath,
          'userType': userType,
          'createdAt': createdAt,
        },
      ),
    );

    var serverResponse = response.body;

    if (response.statusCode == 201) {
      return User.fromJson(
        jsonDecode(serverResponse),
      );
    } else if (response.statusCode == 409) {
      return User.fromJson(
        jsonDecode(serverResponse),
      );
    } else {
      throw Exception('Error With The Server');
    }
  }

  static Future<User> loginUser(String email, String password) async {
    var url = defaultTargetPlatform == TargetPlatform.android
        ? Uri.parse('$baseUrlMobile' '$loginEndPoint')
        : Uri.parse('$baseUrlWeb' '$loginEndPoint');

    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'email': email,
          'password': password,
        },
      ),
    );

    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return User.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 404) {
      return User.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }

  static Future<User> getUserById(String userId) async {
    if (userId.isEmpty) {
      userId = await GlobalSharedPreference.getUserID();
    }

    var url = defaultTargetPlatform == TargetPlatform.android
        ? Uri.parse('$baseUrlMobile' 'user/$userId')
        : Uri.parse('$baseUrlWeb' 'user/$userId');

    final http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return User.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }

  // static Future<Recipe> saveRecipe({
  //   required String postName,
  //   required List usersIn,
  //   required int maxPlayers,
  //   required String utcLocation,
  //   required String userId,
  //   required String postUserImagePath,
  //   required String postUserName,
  //   required String createdAt,
  //   required String timeToPlay,
  //   required String reasonToPlay,
  // }) async {
  //    var url = defaultTargetPlatform == TargetPlatform.android
  //       ? Uri.parse('$baseUrlMobile' '$recipiesEndPoint')
  //       : Uri.parse('$baseUrlWeb' '$recipiesEndPoint');
  //   final http.Response response = await http.post(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(
  //       <String, dynamic>{
  //         'postName': postName,
  //         'usersIn': usersIn,
  //         'maxPlayers': maxPlayers,
  //         'utcLocation': utcLocation,
  //         'userId': userId,
  //         'postUserImagePath': postUserImagePath,
  //         'postUserName': postUserName,
  //         'createdAt': createdAt,
  //         'timeToPlay': timeToPlay,
  //         'reasonToPlay': reasonToPlay,
  //       },
  //     ),
  //   );

  //   var serverResponse = response.body;

  //   if (response.statusCode == 201) {
  //     return Recipe.fromJson(
  //       jsonDecode(serverResponse),
  //     );
  //   } else if (response.statusCode == 409) {
  //     return Recipe.fromJson(
  //       jsonDecode(serverResponse),
  //     );
  //   } else if (response.statusCode == 204) {
  //     return Recipe.fromJson(
  //       jsonDecode(serverResponse),
  //     );
  //   } else {
  //     throw Exception('Error With The Server');
  //   }
  // }

  static Future<Recipe> getAllRecipies(List<Recipe> recipes) async {
    var postUri = Uri.parse('$url' 'recipes');

    final http.Response response = await http.get(
      postUri,
    );

    var serverResponse = response.body;
    if (response.statusCode == 200 || response.statusCode == 304) {
      Map<String, dynamic> map = jsonDecode(response.body);

      List<dynamic> recipeData = map["recipe"];

      for (var i in recipeData) {
        recipes.add(Recipe.fromJson(i));
      }

      return Recipe.fromJson(
        jsonDecode(serverResponse),
      );
    } else {
      return Recipe.fromJson(
        jsonDecode(serverResponse),
      );
    }
  }

  static Future<Recipe> getUserRecipes(
      List<Recipe> profileRecipes, String userId) async {
    if (userId.isEmpty) {
      userId = await GlobalSharedPreference.getUserID();
    }

    var postUri = Uri.parse('$url' 'user/recipes/$userId');

    final http.Response response = await http.get(
      postUri,
    );

    var serverResponse = response.body;
    if (response.statusCode == 200) {
      //var data = jsonDecode(responseData.body);
      Map<String, dynamic> map = jsonDecode(response.body);

      List<dynamic> recipeData = map["recipies"];

      for (var i in recipeData) {
        profileRecipes.add(Recipe.fromJson(i));
      }

      return Recipe.fromJson(
        jsonDecode(serverResponse),
      );
    } else {
      return Recipe.fromJson(
        jsonDecode(serverResponse),
      );
    }
  }

  static void updateUserImageMobile(File mobileImage) async {
    String userId = await GlobalSharedPreference.getUserID();
    var url = defaultTargetPlatform == TargetPlatform.android
        ? Uri.parse('$baseUrlMobile' 'user/updateImage/$userId')
        : Uri.parse('$baseUrlWeb' 'user/updateImage/$userId');

    var request = http.MultipartRequest("PATCH", url);

    request.headers['Content-Type'] = "multipart/form-data";

    request.files
        .add(await http.MultipartFile.fromPath('userImage', mobileImage.path,
            contentType: MediaType(
              'image',
              'jpeg',
            )));

    request.send().then((response) {
      if (response.statusCode == 201) {}
    });
  }

  static void updateUserImageWeb(Uint8List webImage) async {
    String userId = await GlobalSharedPreference.getUserID();
    var url = defaultTargetPlatform == TargetPlatform.android
        ? Uri.parse('$baseUrlMobile' 'user/updateImage/$userId')
        : Uri.parse('$baseUrlWeb' 'user/updateImage/$userId');
    var request = http.MultipartRequest("PATCH", url);

    request.headers['Content-Type'] = "multipart/form-data";

    request.files.add(
      http.MultipartFile.fromBytes(
        'userImage',
        webImage,
        filename: 'image.jpg',
        contentType: MediaType('image', 'png'),
      ),
    );

    request.send().then((response) {
      if (response.statusCode == 201) {}
    });
  }

  static Future<User> getAllUsers(List<User> users) async {
    var baseUrl = defaultTargetPlatform == TargetPlatform.android
        ? Uri.parse('$baseUrlMobile' '$getUsersEndPoint')
        : Uri.parse('$baseUrlWeb' '$getUsersEndPoint');

    final http.Response response = await http.get(
      baseUrl,
    );

    var serverResponse = response.body;
    if (response.statusCode == 200) {
      //var data = jsonDecode(responseData.body);
      Map<String, dynamic> map = jsonDecode(response.body);

      List<dynamic> userData = map["users"];

      for (var i in userData) {
        users.add(User.fromJson(i));
      }
      // if (_users.any((item) => item.id.contains(userId))) {
      //   _users.removeWhere((item) => item.id == userId);
      // }
      // _users.removeWhere((item) => item.isSocialBothered == false);

      return User.fromJson(
        jsonDecode(serverResponse),
      );
    } else {
      return User.fromJson(
        jsonDecode(serverResponse),
      );
    }
  }

  static Future<CategoryModel> getAllCategories(
      List<CategoryModel> categories) async {
    var baseUrl = defaultTargetPlatform == TargetPlatform.android
        ? Uri.parse('$baseUrlMobile' '$getCategoriesEndPoint')
        : Uri.parse('$baseUrlWeb' '$getCategoriesEndPoint');

    final http.Response response = await http.get(
      baseUrl,
    );

    var serverResponse = response.body;
    if (response.statusCode == 200) {
      //var data = jsonDecode(responseData.body);
      Map<String, dynamic> map = jsonDecode(response.body);

      List<dynamic> categoryData = map["category"];

      for (var i in categoryData) {
        categories.add(CategoryModel.fromJson(i));
      }

      return CategoryModel.fromJson(
        jsonDecode(serverResponse),
      );
    } else {
      return CategoryModel.fromJson(
        jsonDecode(serverResponse),
      );
    }
  }

  static Future<CategoryModel> updateCategory(
    String categoryId,
    String categoryName,
    String categoryHexColor,
  ) async {
    var postUri = Uri.parse('$url' 'categories/$categoryId');
    List<Map<String, String>> updateOps = [];

    updateOps.add({'propName': "categoryName", "value": categoryName});
    updateOps.add({'propName': "categoryHexColor", "value": categoryHexColor});

    http.Response response = await http.patch(postUri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updateOps));

    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return CategoryModel.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return CategoryModel.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }

  static updateCategoryImage(
      File pickedImage, Uint8List webImage, String categoryId) async {
    var postUri =
        Uri.parse('$url' 'categories/updateCategoryImage/$categoryId');
    var request = http.MultipartRequest("PATCH", postUri);

    request.headers['Content-Type'] = "multipart/form-data";
    if (pickedImage.path.isEmpty) {}

    kIsWeb
        ? request.files.add(
            http.MultipartFile.fromBytes(
              'categoryImage',
              webImage,
              filename: 'image.jpg',
              contentType: MediaType('image', 'png'),
            ),
          )
        : request.files.add(
            await http.MultipartFile.fromPath('categoryImage', pickedImage.path,
                contentType: MediaType(
                  'image',
                  'jpeg',
                )));

    request.send().then((response) {
      if (response.statusCode == 201) {}
      return Future.value(response);
    });
  }

  static Future<Recipe> updateRecipe(
    String recipeId,
    String recipeName,
    String recipeDuration,
    String? ingredients,
    String recipePreparation,
    String recipeCategoryname,
    String categoryId,
    String categoryHexColor,
    String categoryGoogleFont,
  ) async {
    var postUri = Uri.parse('$url' 'recipes/$recipeId');
    List<Map<String, String>> updateOps = [];

    updateOps.add({'propName': "recipeName", "value": recipeName});
    updateOps.add({'propName': "recipeDuration", "value": recipeDuration});
    updateOps.add({'propName': "ingredients", "value": ingredients!});
    updateOps
        .add({'propName': "recipePreparation", "value": recipePreparation});

    updateOps
        .add({'propName': "recipeCategoryname", "value": recipeCategoryname});
    updateOps.add({'propName': "categoryId", "value": categoryId});
    updateOps.add({'propName': "categoryHexColor", "value": categoryHexColor});
    updateOps
        .add({'propName': "categoryGoogleFont", "value": categoryGoogleFont});
    http.Response response = await http.patch(postUri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updateOps));

    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server: $serverResponse');
    }
  }

  static Future<Recipe> updateRecipeCategory(
    String recipeId,
    String categoryId,
    String categoryHexColor,
    String categoryGoogleFont,
  ) async {
    var postUri = Uri.parse('$url' 'recipes/$recipeId');
    List<Map<String, String>> updateOps = [];

    updateOps.add({'propName': "categoryId", "value": categoryId});
    updateOps.add({'propName': "categoryHexColor", "value": categoryHexColor});
    updateOps
        .add({'propName': "categoryGoogleFont", "value": categoryGoogleFont});
    http.Response response = await http.patch(postUri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updateOps));

    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server: $serverResponse');
    }
  }

  static updateRecipeImage(
      File pickedImage, Uint8List webImage, String recipeId) async {
    var postUri = Uri.parse('$url' 'recipes/updateImage/$recipeId');
    var request = http.MultipartRequest("PATCH", postUri);

    kIsWeb
        ? request.files.add(
            http.MultipartFile.fromBytes(
              'recipeImage',
              webImage,
              filename: 'image.jpg',
              contentType: MediaType('image', 'png'),
            ),
          )
        : request.files.add(
            await http.MultipartFile.fromPath('recipeImage', pickedImage.path,
                contentType: MediaType(
                  'image',
                  'jpeg',
                )));

    request.send().then((response) {
      if (response.statusCode == 201) {}
      return Future.value(response);
    });
  }

  static Future<Recipe> updateRecipeCategoryName(
      String recipeId, String oldCategoryId, String newCategoryId) async {
    var postUri = Uri.parse('$url'
        'recipes/updateRecipeCategoryId/$recipeId/$oldCategoryId/$newCategoryId');

    final http.Response response = await http.patch(
      postUri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'recipeId': recipeId,
          'oldCategoryId': oldCategoryId,
          'newCategoryId': newCategoryId,
        },
      ),
    );

    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    }
    if (response.statusCode == 401) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }

  static Future<Recipe> approveRecipe(
      String recipeId, bool booleanValue) async {
    var uri = Uri.parse('$url' 'recipes/approveRecipe/$recipeId/$booleanValue');

    final http.Response response = await http.patch(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }

  static Future<Recipe> getRecipesByCategory(
      List<Recipe> recipes, String categoryID) async {
    var uri = Uri.parse('$url' 'recipes/getRecipeByCategory/$categoryID');

    final http.Response response = await http.get(
      uri,
    );

    var serverResponse = response.body;
    if (response.statusCode == 200) {
      //var data = jsonDecode(responseData.body);
      Map<String, dynamic> map = jsonDecode(response.body);

      List<dynamic> recipeData = map["recipies"];

      for (var i in recipeData) {
        recipes.add(Recipe.fromJson(i));
      }

      return Recipe.fromJson(
        jsonDecode(serverResponse),
      );
    } else {
      return Recipe.fromJson(
        jsonDecode(serverResponse),
      );
    }
  }

  static Future<User> sendUserFollow(String userA, String userB) async {
    var uri = Uri.parse('$url' 'user/userFollow/$userA/$userB');

    final http.Response response = await http.patch(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return User.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }

  static Future<Recipe> getRecipiesSortBy(List<Recipe> mainRecipies) async {
    var uri = Uri.parse('$url' 'recipes/sortby');

    final http.Response response = await http.get(
      uri,
    );

    var serverResponse = response.body;
    if (response.statusCode == 200) {
      //var data = jsonDecode(responseData.body);
      Map<String, dynamic> map = jsonDecode(response.body);

      List<dynamic> recipeData = map["recipe"];

      for (var i in recipeData) {
        mainRecipies.add(Recipe.fromJson(i));
      }

      return Recipe.fromJson(
        jsonDecode(serverResponse),
      );
    } else {
      return Recipe.fromJson(
        jsonDecode(serverResponse),
      );
    }
  }

  static Future<User> sendUserUnFollow(String userA, String userB) async {
    var uri = Uri.parse('$url' 'user/userUnfollow/$userA/$userB');

    final http.Response response = await http.patch(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return User.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }

  static Future<Recipe> likeRecipe(
      String recipeId, String user, bool booleanValue) async {
    var uri =
        Uri.parse('$url' 'recipes/likeRecipe/$recipeId/$user/$booleanValue');
//    print('from hhtp url: $url');

    final http.Response response = await http.patch(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }

  static Future<Recipe> dislikeRecipe(String recipeId, String user) async {
    var uri = Uri.parse('$url' 'recipes/dislikeRecipe/$recipeId/$user');

    final http.Response response = await http.patch(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{}),
    );
    var serverResponse = response.body;

    if (response.statusCode == 200) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else if (response.statusCode == 401) {
      return Recipe.fromJson(jsonDecode(serverResponse));
    } else {
      throw Exception('Error With The Server');
    }
  }
}
