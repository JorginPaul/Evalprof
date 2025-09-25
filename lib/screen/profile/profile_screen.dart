import 'package:Evalprof/screen/auth/login_screen.dart';
import 'package:Evalprof/screen/profile/edit_profile.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example user data
    final String userName = "Paul Jorgin";
    final String userEmail = "blessing2025@gmail.com";
    final String userRole = "Evaluator";
    final String profileImage = "../ChatGPT_Image.png";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfile())
              );
            },
          ),
        ],
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profileImage),
            ),
            const SizedBox(height: 16),
            Text(
              userName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              userEmail,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Chip(
              label: Text(userRole),
              avatar: const Icon(Icons.verified_user),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Change Password'),
              onTap: () {
                // Implement change password
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Implement settings
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
              title: Text('Logout', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen())
                );
              },
            ),
            const Divider(height: 32),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help & Support'),
              onTap: () {
                // Implement help & support
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Evalprofs'),
              onTap: () {
                // Implement about
              },
            ),
          ],
        ),
      ),
    );
  }
}