import 'package:flutter/material.dart';

class FriendSearchScreen extends StatefulWidget {
  const FriendSearchScreen({super.key});

  @override
  State<FriendSearchScreen> createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends State<FriendSearchScreen> {
  String query = '';
  List<Map<String, String>> results = const [
    {'id': 'u3', 'name': 'Mrs. Chioma', 'school': 'UNILAG'},
    {'id': 'u4', 'name': 'Mr. Dan', 'school': 'UNIBEN'},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = results
        .where(
          (r) =>
              r['name']!.toLowerCase().contains(query.toLowerCase()) ||
              r['school']!.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Find Lecturers')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by name, school, field',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => query = v),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final r = filtered[i];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(r['name']!.substring(0, 1)),
                    ),
                    title: Text(r['name']!),
                    subtitle: Text(r['school']!),
                    trailing: ElevatedButton(
                      onPressed: () {}, // TODO: send invite / connect
                      child: const Text('Connect'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
