import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  // Box initialization
  final Future<Box> _box = Hive.openBox('authBox');
  final String baseUrl = "https://backend.taskmaster.outlfy.com/";

  // Private fields
  bool _isSignedIn = false;
  String? _token;
  String? _role;

  // Public getters
  bool get isSignedIn => _isSignedIn;
  String? get token => _token;
  String? get role => _role;

  // Setters
  void setRole(String role) async {
    _role = role;
    final box = await _box;
    await box.put('role', role);
    notifyListeners();
  }

  Future<void> _updateHive(String key, dynamic value) async {
    final box = await _box;
    await box.put(key, value);
  }

  // Retrieve data from Hive
  Future<void> initializeAuthState() async {
    final box = await _box;
    _isSignedIn = box.get('isSignedIn', defaultValue: false);
    _token = box.get('token');
    _role = box.get('role');
    notifyListeners();
  }

  // Register method
  Future<void> register(
    String email,
    String phone,
    String firstName,
    String lastName,
    String type,
    String password,
    String dateOfBirth,
    String address,
  ) async {
    final registerUrl = '$baseUrl$role/register';

    try {
      final body = jsonEncode({
        'user': {
          'email': email,
          'phone': phone,
          'firstName': firstName,
          'lastName': lastName,
          'auth': {
            'type': type,
            'data': {
              'password': password,
            },
          },
        },
        'data': {
          'dateOfBirth': dateOfBirth,
          'address': address,
        },
      });

      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['message'] == "User successfully registered.") {
        await _updateHive('isSignedIn', true);
        _isSignedIn = true;
        notifyListeners();
        print('Registration successful');
      } else {
        throw Exception(
            data['message'] ?? 'Unknown error during registration.');
      }
    } catch (e) {
      print('Registration error: $e');
      throw Exception('Registration error: $e');
    }
  }

  // Login method
  Future<void> login(
    String email,
    String type,
    String password,
  ) async {
    final loginUrl = '$baseUrl$role/login';

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': {
            'email': email,
            'auth': {
              'type': type,
              'data': {
                'password': password,
              },
            },
          },
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        _token = data['token'];
        await _updateHive('token', _token);
        await _updateHive('isSignedIn', true);

        _isSignedIn = true;
        notifyListeners();
        print('Login successful');
      } else {
        throw Exception(data['error'] ?? 'Unknown error during login.');
      }
    } catch (e) {
      print('Login error: $e');
      throw Exception('Login error: $e');
    }
  }

  // Logout method
  Future<void> logout() async {
    final box = await _box;
    await box.delete('token');
    await box.put('isSignedIn', false);
    _isSignedIn = false;
    _token = null;
    _role = null;
    notifyListeners();
  }

  // Check if user is signed in
  Future<bool> checkIfSignedIn() async {
    final box = await _box;
    _token = box.get('token');
    _isSignedIn = _token != null;
    _role = box.get('role');
    notifyListeners();
    return _isSignedIn;
  }

  //check authorization
  Future<void> checkAuth(String token) async {
    final checkUrl = '$baseUrl$role/isauthorized';
    try {
      final response = await http.get(
        Uri.parse(checkUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        print(jsonList);
        // return jsonList.map((json) => Employee.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to fetch $role: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('authorization exception: $e');
    }
  }
}
