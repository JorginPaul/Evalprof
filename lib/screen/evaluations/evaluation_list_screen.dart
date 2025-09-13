import 'package:flutter/material.dart';

class EvaluationListScreen extends StatelessWidget {
  const EvaluationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = const [
      {'id': 'e1', 'course': 'Mathematics', 'topic': 'Linear Algebra'},
      {'id': 'e2', 'course': 'Computer Science', 'topic': 'Operating Systems'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Evaluations')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: data.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final e = data[i];
          return Card(
            child: ListTile(
              title: Text('${e['course']} — ${e['topic']}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: open evaluation detail if you add it
              },
            ),
          );
        },
      ),
    );
  }
}
