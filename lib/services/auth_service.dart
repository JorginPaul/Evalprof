import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/chat_service.dart';

class AuthService with ChangeNotifier {
  final ApiService api = ApiService();
  String? _token;
  UserModel? _currentUser;

  ChatService? chatService; // link to ChatService

  // ======= GETTERS =======
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _token != null && _currentUser != null;
  String? get token => _token;

  void linkChatService(ChatService chat) {
    chatService = chat;
    if (_token != null) {
      chatService!.connected ? null : chatService!.connect();
    }
  }

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

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('user', jsonEncode(_currentUser!.toJson()));

        // Connect ChatService automatically
        chatService?.connect();

        notifyListeners();
        return true;
      } else {
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

    _token = prefs.getString('token');
    _currentUser = UserModel.fromJson(jsonDecode(prefs.getString('user')!));

    // Auto-connect chat if linked
    chatService?.connect();

    notifyListeners();
  }

  // ======= LOGOUT =======
  Future<void> logout() async {
    _token = null;
    _currentUser = null;
    chatService?.disposeService();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');

    notifyListeners();
  }
}