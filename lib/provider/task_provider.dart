import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:task_mvp/provider/auth_provider.dart';

class TaskProvider extends ChangeNotifier {
  static const String baseUrl = "https://backend.taskmaster.outlfy.com";

  static Future<String?> _getToken() async {
    final box = await Hive.openBox('authBox');
    print("Token retrieved: ${box.get('token')}");
    return box.get('token');
  }

  Future<void> createTask(String title, String description, String jobType,
      String empId, String managerId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found. User may not be logged in.');
    }

    try {
      // final ap = AuthProvider();
      // await ap.checkAuth(token);

      final response = await http.post(
        Uri.parse('$baseUrl/task'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'jobType': jobType,
          'assignedTo': empId,
          'createdBy': managerId,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        notifyListeners();
      } else {
        throw Exception(
          'Failed to create Task: ${data['error'] ?? response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Authorization exception: $e');
    }
  }
}
