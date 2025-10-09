import 'package:EvalProfs/models/user_model.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthService with ChangeNotifier {
  final ApiService api = ApiService();
  String? _token; // Store token for future requests

  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await api.postRequest("auth/login", {
        "email": email,
        "password": password,
      });

      if (response['success'] == true) {
        _token = response['token']; // Store token
        final user = UserModel.fromJson(response['user']); // Fixed syntax
        return user;
      } else {
        print("Login failed: ${response['message']}");
        return null;
      }
    } catch (e) {
      print("Login failed: $e");
      return null;
    }
  }

  // Getter for token
  String? get token => _token;
}