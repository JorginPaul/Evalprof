import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? get token => _token;
  bool get isLoggedIn => _token != null;

  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _token = 'dummy-token';
    notifyListeners();
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}
