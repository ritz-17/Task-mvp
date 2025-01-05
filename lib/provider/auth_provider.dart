import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  // Box initialization
  final Future<Box> _box = Hive.openBox('authBox');
  final String baseUrl = "https://backend.taskmaster.outlfy.com/";
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

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
        await _secureStorage.write(key: 'token', value: _token);
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
    _secureStorage.delete(key: 'token');
    await box.put('isSignedIn', false);
    _isSignedIn = false;
    _token = null;
    _role = null;
    notifyListeners();
  }

  // Check if user is signed in
  Future<bool> checkIfSignedIn() async {
    final box = await _box;
    _token = await _secureStorage.read(key: 'token');
    _isSignedIn = _token != null;
    _role = box.get('role');
    checkAuth();
    notifyListeners();
    return _isSignedIn;
  }

  //check authorization
  Future<void> checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true) {
          // Extract user details from response
          final userData = jsonResponse['data'];

          // Save user details in SharedPreferences
          await prefs.setString('userId', userData['_id']);
          await prefs.setString('firstName', userData['firstName']);
          await prefs.setString('lastName', userData['lastName']);
          await prefs.setString('email', userData['email']);
          await prefs.setString('phone', userData['phone']);
          await prefs.setBool('isVerified', userData['isVerified']);
          await prefs.setString('createdAt', userData['createdAt']);
          await prefs.setString('updatedAt', userData['updatedAt']);

          // Print data for debugging
          print('User details stored successfully: $userData');

          notifyListeners();
        } else {
          throw Exception('Authorization failed: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to fetch $role: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Authorization exception: $e');
    }
  }

}
