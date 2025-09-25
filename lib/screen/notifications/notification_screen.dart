import 'package:Evalprof/screen/auth/dashboard_screen.dart';
import 'package:Evalprof/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
         actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen())
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, size: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}