import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example user data
    final String userName = "John Doe";
    final String userEmail = "john.doe@email.com";
    final String userRole = "Evaluator";
    final String profileImage =
        "https://ui-avatars.com/api/?name=John+Doe&background=0D8ABC&color=fff";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit profile screen
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
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Implement logout
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