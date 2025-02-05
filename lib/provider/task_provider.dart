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
    return await _secureStorage.read(key: 'token');
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
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['data'] is! List) {
          throw Exception("Invalid data format received");
        }

        final taskData = jsonResponse['data'] as List;

        List<Task> tasks = taskData.map((json) {
          try {
            return Task.fromJson(json);
          } catch (e) {
            return null; // Filter out problematic entries
          }
        }).whereType<Task>().toList(); // Remove null values

        // Filter tasks based on user role
        // if (role == 'employee') {
        //   tasks = tasks.where((task) => task.assignedTo == userId).toList();
        // } else if (role == 'manager') {
        //   tasks = tasks.where((task) => task.createdBy == userId).toList();
        // }

        await _setTaskList(tasks);
        return _taskList;
      } else {
        throw Exception(
            'Failed to fetch tasks');
      }
    } catch (e) {
      throw Exception('Error fetching tasks');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> createTask(
      String title,
      String description,
      String jobType,
      List<String> empId,
      String priority,
      String? audioBase64,
      List<String>? encodedAttachments,
      DateTime deadline,
      ) async {
    final token = await _getToken();
    final managerId = await _getUserId();

    if (token == null || managerId == null) {
      throw Exception('User not authenticated.');
    }

    try {
      final taskData = {
        'title': title,
        'description': description,
        'jobType': jobType,
        'assignedTo': empId,
        'createdBy': managerId,
        'priority': priority,
        if (audioBase64 != null) 'voice': audioBase64,
        if (encodedAttachments != null) 'attachments': encodedAttachments,
        'deadline': deadline.toIso8601String(),
      };

      final response = await http.post(
        Uri.parse('$baseUrl/task'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(taskData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // await fetchTaskList();
      } else {
        throw Exception('Failed to create task');
      }
    } catch (e) {
      throw Exception('Error creating task');
    }
  }


  Future<void> updateTaskStatus(String taskId, String status) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found.');
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/task/$taskId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': status}),
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await fetchTaskList();
        notifyListeners();
      } else {
        throw Exception('Failed to update task status');
      }
    } catch (e) {
      throw Exception('Error updating task status');
    }
  }

  Task getTaskById(String taskId) {
    return _taskList.firstWhere((task) => task.id == taskId, orElse: () => throw Exception("Task not found"));
  }

  Future<void> deleteTask(String taskId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found.');
    }

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/task/$taskId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await fetchTaskList();
        notifyListeners();
      } else {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      throw Exception('Error deleting task');
    }
  }

}
