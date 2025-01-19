import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _taskList = [];
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

  Future<String?> _getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  Future<void> _setTaskList(List<Task> tasks) async {
    _taskList.clear();
    _taskList.addAll(tasks);
    notifyListeners();
  }

  Future<List<Task>> fetchTaskList() async {
    _isLoading = true;
    notifyListeners();

    final token = await _getToken();
    final userId = await _getUserId();
    final role = await _getRole();
    print(userId);

    if (token == null || userId == null) {
      _isLoading = false;
      notifyListeners();
      throw Exception('User not authenticated.');
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
        final jsonResponse = jsonDecode(response.body);
        final taskData = jsonResponse['data'] as List;

        if (taskData == null || taskData is! List) {
          throw Exception('Invalid response format.');
        }
        if (role == 'employee') {
          final tasks = taskData
              .map((json) => Task.fromJson(json))
              .where((task) => task.assignedTo.user.id == userId)
              .toList();
          await _setTaskList(tasks);
          return tasks;
        } else {
          final tasks = taskData
              .map((json) => Task.fromJson(json))
              .where((task) => task.createdBy.user.id == userId)
              .toList();
          await _setTaskList(tasks);
          return tasks;
        }
      } else {
        throw Exception(
            'Failed to fetch tasks: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      throw Exception('Error fetching tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTask(
    String title,
    String description,
    String jobType,
    String empId,
    String priority, {
    String? audioBase64,
    List<String>? encodedAttachments,
  }) async {
    final token = await _getToken();
    final managerId = await _getUserId();

    if (token == null || managerId == null) {
      throw Exception(
          'Token or Manager ID not found. User may not be logged in.');
    }

    try {
      // Prepare the task data
      final taskData = {
        'title': title,
        'description': description,
        'jobType': jobType,
        'assignedTo': empId,
        'createdBy': managerId,
        if (audioBase64 != null && audioBase64.isNotEmpty)
          'voice': audioBase64, // Include voice if provided
        if (encodedAttachments != null && encodedAttachments.isNotEmpty)
          'attachments': encodedAttachments, // Include attachments if provided
      };

      final response = await http.post(
        Uri.parse('$baseUrl/task'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(taskData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        print('Task created successfully: $data');
        print(data);
        await fetchTaskList();
      } else {
        throw Exception(
            'Failed to create task: ${data['error'] ?? response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error creating task: $e');
    }
  }

  //update status of task
  Future<void> updateTaskStatus(String taskId, String status) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found. User may not be logged in.');
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/task/$taskId'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'status': status,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('Task status updated successfully');
        await fetchTaskList();
        notifyListeners();
      } else {
        throw Exception(
            'Failed to update task status: ${data['message'] ?? response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error updating task status: $e');
    }
  }

  Task getTaskById(String taskId) {
    return _taskList.firstWhere((task) => task.id == taskId);
  }
}
