import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:azurloc/models/activity_model.dart';
import 'package:azurloc/models/user_model.dart';
import 'package:azurloc/models/category_model.dart' as category_model;
import 'package:azurloc/models/history_model.dart';
import 'package:azurloc/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:azurloc/services/category_service.dart';
import '../models/cart_model.dart';

class UserService {
  final Dio _dio = Dio();
  final _backendUrl = 'https://azurloc-back.onrender.com';
  final AuthService _authService = AuthService();
  final CategoryService _categoryService = CategoryService();

  Future<User> getInfo() async {
    User emptyUser = User(
      id: '',
      firstname: '',
      lastname: '',
      username: '',
      email: '',
      password: '',
      city: '',
      address: '',
      emailVerified: false,
      refreshToken: [],
      roles: {},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    try {
      final accessToken = await _authService.refresh();
      if (accessToken.isEmpty) {
        return emptyUser;
      }
      final response = await _dio.get(
        '$_backendUrl/api/user',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        return emptyUser;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return emptyUser;
    }
  }

  Future<bool> edit(User user) async {
    try {
      final accessToken = await _authService.refresh();
      if (accessToken.isEmpty) {
        return false;
      }
      final response = await _dio.put(
        '$_backendUrl/api/user',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: jsonEncode(user.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> addToCart(Activity activity) async {
    try {
      final accessToken = await _authService.refresh();
      if (accessToken.isEmpty) {
        return false;
      }
      final response = await _dio.post(
        '$_backendUrl/api/user/cart',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: {
          'activity': activity.id,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<Cart?> getUserCart() async {
    try {
      final accessToken = await _authService.refresh();
      if (accessToken.isEmpty) {
        return null;
      }
      final response = await _dio.get(
        '$_backendUrl/api/user/cart',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        List<category_model.Category> categories = await _categoryService.getAll();
        return Cart.fromJson(response.data, categories);
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<bool> removeFromCart(String activityId) async {
    try {
      final accessToken = await _authService.refresh();
      if (accessToken.isEmpty) {
        return false;
      }
      final response = await _dio.delete(
        '$_backendUrl/api/user/cart',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: {'activity': activityId},
      );
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> buyProcess(Cart cart) async {
    try {
      final accessToken = await _authService.refresh();
      if (accessToken.isEmpty) {
        return false;
      }
      final response = await _dio.post(
        '$_backendUrl/api/user/history',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }

  }

  Future<List<History>> getHistory() async {
    List<History> emptyHistory = [];
    try {
      final accessToken = await _authService.refresh();
      if (accessToken.isEmpty) {
        return emptyHistory;
      }
      final response = await _dio.get(
        '$_backendUrl/api/user/history',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if(response.statusCode == 200) {
        List<category_model.Category> categories = await _categoryService.getAll();
        List<History> histories = response.data.map<History>((history) => History.fromJson(history, categories)).toList();
        return histories;
      } else {
        return emptyHistory;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return emptyHistory;
    }
  }
}
