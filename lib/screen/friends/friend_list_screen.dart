import 'package:flutter/material.dart';
import '../../utils/helpers.dart';

class FriendListScreen extends StatelessWidget {
  const FriendListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final friends = const [
      {'id': 'u1', 'name': 'Dr. Ada', 'school': 'UNN'},
      {'id': 'u2', 'name': 'Prof. Bello', 'school': 'ABU'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Network'),
        actions: [
          IconButton(
            onPressed: () => push(context, '/friend-search'),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: friends.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final f = friends[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(f['name']!.substring(0, 1))),
              title: Text(f['name']!),
              subtitle: Text(f['school']!),
              trailing: const Icon(Icons.chat_bubble_outline),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
