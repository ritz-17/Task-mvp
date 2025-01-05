import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TaskProvider extends ChangeNotifier {
  static const String baseUrl = "https://backend.taskmaster.outlfy.com";
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    final token = _secureStorage.read(key: 'token');
    print("Token retrieved: $token");
    return token;
  }

  Future<void> createTask(String title, String description, String jobType,
      String empId, String managerId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found. User may not be logged in.');
    }

    try {
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
      } else {
        throw Exception(
          'Failed to create Task: ${data['error'] ?? response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Authorization exception: $e');
    } finally {
      notifyListeners();
    }
  }
}
