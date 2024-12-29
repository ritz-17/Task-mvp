import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  String baseURl = "https://backend.taskmaster.outlfy.com/";
  bool _isSignedIn = false;
  String? _token;

  bool get isSignedIn => _isSignedIn;

  get isLoading => null;

  Future<void> login(
      String email, String mobile, String type, String password) async {
    String loginUrl = '${baseURl}manager/login';

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': {
            'email': email,
            'phone': mobile,
            'auth': {
              'type': type,
              'data': {
                'password': password,
              },
            },
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['token'] != null) {
          _token = data['token'];

          final box = await Hive.openBox('authBox');
          await box.put('token', _token);
          await box.put('isSignedIn', true);

          _isSignedIn = true;
          notifyListeners();
        } else {
          throw Exception('Token not found in response.');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Login failed: ${errorData['error'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Error in login: $e');
      throw Exception('Login error: ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> getDataFromHive() async {
    final box = await Hive.openBox('authBox');
    _isSignedIn = box.get('isSignedIn', defaultValue: false);
    _token = box.get('token');
    notifyListeners();
  }

  Future<void> logout() async {
    final box = await Hive.openBox('authBox');
    await box.delete('token');
    await box.put('isSignedIn', false);
    _isSignedIn = false;
    notifyListeners();
  }

  Future<bool> checkIfSignedIn() async {
    final box = await Hive.openBox('authBox');
    _token = box.get('token');
    _isSignedIn = _token != null;
    notifyListeners();
    return _isSignedIn;
  }
}
