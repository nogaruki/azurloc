import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:azurloc/models/activity_model.dart';
import 'package:azurloc/services/auth_service.dart';
import 'package:azurloc/services/category_service.dart';
import 'package:azurloc/models/category_model.dart' as category_model;

class ActivityService {
  final _backendUrl = 'https://azurloc-back.onrender.com';
  final Dio _dio = Dio();
  final _authService = AuthService();

  Future<List<Activity>> getAll() async {
    try {
      final response = await _dio.get('$_backendUrl/api/activities',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<category_model.Category> categories = await CategoryService().getAll();

        final List<dynamic> data = response.data;
        return data.map((json) => Activity.fromJson(json, categories)).toList();
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

  Future<bool> edit(Activity activity) async {
    try {
      final accessToken = await _authService.refresh();
      if (accessToken == '') {
        return false;
      }
      final response = await _dio.put('$_backendUrl/api/activities/${activity.id}',
        data: jsonEncode(activity.toJson()),
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
      final response = await _dio.delete('$_backendUrl/api/activities/$id',
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

  Future<bool> add(Activity newActivity) async {
    try {
      final accessToken = await _authService.refresh();
      if (accessToken == '') {
        return false;
      }
      final response = await _dio.post('$_backendUrl/api/activities',
        data: jsonEncode(newActivity.toJson()),
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
