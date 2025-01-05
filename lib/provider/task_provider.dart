import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _taskList = [];
  bool _isLoading = false;

  List<Task> get taskList => _taskList;

  bool get isLoading => _isLoading;

  static const String baseUrl = "https://backend.taskmaster.outlfy.com";
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    final token = await _secureStorage.read(key: 'token');
    print("Token retrieved: $token");
    return token;
  }

  Future<String?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> fetchTaskList() async {
    final token = await _getToken();
    final userId = await _getUserId();

    if (token == null || userId == null) {
      throw Exception('Token or User ID not found. User may not be logged in.');
    }

    final taskUrl = '$baseUrl/task';

    try {
      final response = await http.get(
        Uri.parse(taskUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true) {
          final List<dynamic> taskData = jsonResponse['data'];
          _taskList = taskData
              .map((e) => Task.fromJson(e))
              .where((task) => task.createdBy == userId)
              .toList();

          notifyListeners();
        } else {
          throw Exception('Authorization failed: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to fetch tasks: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  Future<void> createTask(
      String title,
      String description,
      String jobType,
      String empId,
      ) async {
    final token = await _getToken();
    final managerId = await _getUserId();

    if (token == null || managerId == null) {
      throw Exception('Token or Manager ID not found. User may not be logged in.');
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
        print('Task created successfully: $data');
        await fetchTaskList();
      } else {
        throw Exception(
          'Failed to create task: ${data['error'] ?? response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Error creating task: $e');
    }
  }
}