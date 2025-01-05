import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TaskProvider extends ChangeNotifier {
  static const String baseUrl = "https://backend.taskmaster.outlfy.com";
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // ---------------------------- Retrieve Token -------------------------------
  Future<String?> _getToken() async {
    final token = await _secureStorage.read(key: 'token');
    print("Token retrieved: $token");
    return token;
  }

// ---------------------------- Create Task API ------------------------------
  Future<void> createTask(
    String title,
    String description,
    String jobType, // Job type: 'short' or 'long'
    String empId, // Employee ID assigned to the task
    String managerId, // Manager ID who created the task
  ) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found. User may not be logged in.');
    }

    try {
      // API call to create the task
      final response = await http.post(
        Uri.parse('$baseUrl/task'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'jobType': jobType, // Specify 'short' for short tasks
          'assignedTo': empId,
          'createdBy': managerId,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        // Log task details to the terminal
        print("Task created successfully:");
        print("Title: $title");
        print("Description: $description");
        print("Job Type: $jobType");
        print("Assigned To: $empId");
        print("Created By: $managerId");
      } else {
        throw Exception(
          'Failed to create Task: ${data['error'] ?? response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Error creating task: $e');
    } finally {
      // Notify listeners to update any UI bound to this provider
      notifyListeners();
    }
  }
}
