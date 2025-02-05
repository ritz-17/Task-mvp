import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/employee_model.dart';

class EmployeeService {
  static const String baseUrl = "https://backend.taskmaster.outlfy.com";
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static Future<String?> _getToken() async {
    final token = await _secureStorage.read(key: 'token');
    print("Token retrieved: $token");
    return token;
  }

  static Future<List<Employee>> fetchEmployees() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found. User may not be logged in');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/employee/crud'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Employee.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch employees');
    }
  }
}


// Employee Provider for State Management
class EmployeeProvider extends ChangeNotifier {
  List<Employee> _employees = [];
  bool _isLoading = false;

  List<Employee> get employees => _employees;

  List<Employee> get freeMembers =>
      _employees.where((e) => e.status == 'free').toList();

  bool get isLoading => _isLoading;

  Future<void> loadEmployees() async {
    _isLoading = true;
    notifyListeners();

    try {
      final employees = await EmployeeService.fetchEmployees();
      _employees = employees;
    } catch (error) {
      print('Error loading employees: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
