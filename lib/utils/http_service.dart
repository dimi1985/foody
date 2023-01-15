import 'dart:convert';

import 'package:foody/models/user.dart';
import 'package:foody/utils/shared_preference.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class HttpService {
  static var baseUrl = defaultTargetPlatform == TargetPlatform.android
      ? Uri.parse('http://10.0.2.2:3000/')
      : Uri.parse('http://localhost:3000/');

  static var registerEndPoint = 'user/register';
  static var loginEndPoint = 'user/login';
  static var getUserIdEndPoint = 'user/getUserId';
  static var getUsersEndPoint = 'user';
  static var getCategoriesEndPoint = 'categories';
  static var recipiesEndPoint = 'recipes';

  static Future<User> registerUser(
    String username,
    String email,
    String password,
    String imgageFile,
    String userType,
    String createdAt,
  ) async {
    var url = Uri.parse('$baseUrl$registerEndPoint');

    var imageDummyPath = r'user-images\dummy-image\dummy-image.jpg';
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'username': username,
          'email': email,
          'password': password,
          'userImage': imageDummyPath,
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
}
