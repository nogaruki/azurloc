import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:azurloc/models/category_model.dart' as category_model;
import 'package:azurloc/services/auth_service.dart';

class CategoryService {
  final _backendUrl = 'https://azurloc-back.onrender.com';
  final Dio _dio = Dio();
  final _authService = AuthService();

  Future<List<category_model.Category>> getAll() async {
    try {
      final response = await _dio.get('$_backendUrl/api/categories',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => category_model.Category.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<bool> edit(category_model.Category category) async {
    try {
      final accessToken = await _authService.refresh();
      if (accessToken == '') {
        return false;
      }
      final response = await _dio.put('$_backendUrl/api/categories/${category.id}',
        data: jsonEncode(category.toJson()),
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

  Future<bool> delete(String id) async {
    try {
      final accessToken = await _authService.refresh();
      if (accessToken == '') {
        return false;
      }
      final response = await _dio.delete('$_backendUrl/api/categories/$id',
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

  Future<bool> add(category_model.Category newCategory) async {
    try {
      final accessToken = await _authService.refresh();
      if (accessToken == '') {
        return false;
      }
      final response = await _dio.post('$_backendUrl/api/categories',
        data: jsonEncode(newCategory.toJson()),
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      return response.statusCode == 201;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}
