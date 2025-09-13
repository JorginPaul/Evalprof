import 'package:flutter/material.dart';

class NotificationService {
  static void snackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
