import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthService with ChangeNotifier {
  final ApiService api = ApiService();
  String? _token;
  UserModel? _currentUser;

  // ======= GETTERS =======
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _token != null && _currentUser != null;
  String? get token => _token;

  // ======= LOGIN =======
  Future<bool> login(String email, String password) async {
    try {
      final response = await api.postRequest("auth/login", {
        "email": email,
        "password": password,
      });

      if (response['success'] == true) {
        _token = response['token'];
        _currentUser = UserModel.fromJson(response['user']);

        // Save credentials locally for auto-login
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('user', jsonEncode(_currentUser!.toJson()));

        notifyListeners();
        return true;
      } else {
        debugPrint("❌ Login failed: ${response['message']}");
        return false;
      }
    } catch (e) {
      debugPrint("⚠️ Login error: $e");
      return false;
    }
  }

  // ======= AUTO-LOGIN =======
  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token') || !prefs.containsKey('user')) return;

    final savedToken = prefs.getString('token');
    final savedUser = prefs.getString('user');

    if (savedToken != null && savedUser != null) {
      _token = savedToken;
      _currentUser = UserModel.fromJson(jsonDecode(savedUser));
      notifyListeners();
    }
  }

  // ======= LOGOUT =======
  Future<void> logout() async {
    _token = null;
    _currentUser = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');

    notifyListeners();
  }

  // ======= REGISTER =======
  Future<bool> register(Map<String, dynamic> data) async {
    try {
      final response = await api.postRequest("auth/register", data);

      if (response['success'] == true) {
        debugPrint("✅ Registration successful");
        return true;
      } else {
        debugPrint("❌ Registration failed: ${response['message']}");
        return false;
      }
    } catch (e) {
      debugPrint("⚠️ Registration error: $e");
      return false;
    }
  }
}