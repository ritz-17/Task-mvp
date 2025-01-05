import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
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
  Future<void> setRole(String role) async {
    _role = role;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', _role!);
    notifyListeners();
    debugPrint('Role set to: $role');
  }


  // Check if user is signed in
  Future<bool> checkIfSignedIn() async {
    _token = await _secureStorage.read(key: 'token');
    _isSignedIn = _token != null;
    notifyListeners();
    debugPrint('Sign-in status checked. isSignedIn: $_isSignedIn');
    return _isSignedIn;
  }

  // Initialize authentication state
  Future<void> initializeAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _isSignedIn = prefs.getBool('isSignedIn') ?? false;
    _token = await _secureStorage.read(key: 'token');
    final savedRole = prefs.getString('role');
    if (savedRole != null && savedRole.isNotEmpty) {
      // await checkAuth();
    } else {
      _role = null;
    }
    notifyListeners();
    debugPrint('Auth state initialized. isSignedIn: $_isSignedIn, role: $_role');
  }


  // Check authorization
  Future<void> checkAuth() async {
    if (_role == null || _role!.isEmpty) {
      throw Exception('Role is not defined. Cannot check authorization.');
    }

    final prefs = await SharedPreferences.getInstance();
    final checkUrl = '$baseUrl$_role/isauthorized';

    try {
      final response = await http.get(
        Uri.parse(checkUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $_token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true) {
          final user = User.fromJson(jsonResponse['data']);
          await prefs.setString('userId', user.id);
          await prefs.setString('firstName', user.firstName);
          await prefs.setString('lastName', user.lastName);
          await prefs.setString('email', user.email);
          await prefs.setString('phone', user.phone);
          await prefs.setBool('isVerified', user.isVerified);
          await prefs.setString('createdAt', user.createdAt);
          await prefs.setString('updatedAt', user.updatedAt);

          debugPrint('User details stored successfully: ${user.toString()}');
          notifyListeners();
        } else {
          throw Exception('Authorization failed: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to fetch $role: ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Authorization exception: $e');
      throw Exception('Authorization exception: $e');
    }
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
    if (_role == null || _role!.isEmpty) {
      throw Exception('Role is not set. Cannot proceed with registration.');
    }

    final registerUrl = '$baseUrl$_role/register';

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
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isSignedIn', true);
        _isSignedIn = true;
        notifyListeners();
        debugPrint('Registration successful');
      } else {
        throw Exception(
            data['message'] ?? 'Unknown error during registration.');
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      throw Exception('Registration error: $e');
    }
  }

  // Login method
  Future<void> login(
      String email,
      String type,
      String password,
      ) async {
    if (_role == null || _role!.isEmpty) {
      throw Exception('Role is not set. Cannot proceed with login.');
    }

    final loginUrl = '$baseUrl$_role/login';

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
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isSignedIn', true);
        _isSignedIn = true;
        notifyListeners();
        debugPrint('Login successful');
      } else {
        throw Exception(data['error'] ?? 'Unknown error during login.');
      }
    } catch (e) {
      debugPrint('Login error: $e');
      throw Exception('Login error: $e');
    }
  }

  // Logout method
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('role');
    await _secureStorage.delete(key: 'token');
    await prefs.setBool('isSignedIn', false);
    _isSignedIn = false;
    _token = null;
    _role = null;
    notifyListeners();
    debugPrint('User logged out successfully');
  }
}
