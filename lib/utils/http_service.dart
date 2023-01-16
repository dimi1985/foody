import 'dart:convert';
import 'dart:io';
import 'package:foody/models/user.dart';
import 'package:foody/utils/shared_preference.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

class HttpService {
  static var registerEndPoint = 'user/register';
  static var loginEndPoint = 'user/login';
  static var getUserIdEndPoint = 'user/getUserId';
  static var getUsersEndPoint = 'user';
  static var getCategoriesEndPoint = 'categories';
  static var recipiesEndPoint = 'recipes';
  static var mobileUrl = 'http://10.0.2.2:3000/';
  static var webUrl = 'http://localhost:3000/';

  static var baseUrl = defaultTargetPlatform == TargetPlatform.android
      ? Uri.parse(mobileUrl)
      : Uri.parse(webUrl);

  static Future<User> registerUser(
    String email,
    String password,
    String username,
    String userImage,
    String userType,
    String createdAt,
  ) async {
    var url = Uri.parse('$baseUrl$registerEndPoint');

    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'email': email,
          'password': password,
          'username': username,
          'userImage': userImage,
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
    var url = Uri.parse('$baseUrl$loginEndPoint');

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

  static Future<User> getUserById() async {
    String userId = await GlobalSharedPreference.getUserID();
    var url = Uri.parse('$baseUrl' 'user/$userId');

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

  static void updateUserImageMobile(File mobileImage) async {
    String userId = await GlobalSharedPreference.getUserID();
    var postUri = Uri.parse('$baseUrl' 'user/updateImage/$userId');
    var request = http.MultipartRequest("PATCH", postUri);

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
    var postUri = Uri.parse('$baseUrl' 'user/updateImage/$userId');
    var request = http.MultipartRequest("PATCH", postUri);

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
}
