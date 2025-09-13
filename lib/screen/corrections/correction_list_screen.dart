import 'package:flutter/material.dart';
import '../../utils/helpers.dart';

class CorrectionListScreen extends StatelessWidget {
  const CorrectionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = const [
      {'id': 'k1', 'evaluationId': 'e1', 'title': 'Math LA Corrections'},
      {'id': 'k2', 'evaluationId': 'e2', 'title': 'OS Corrections'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Corrections')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: data.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final k = data[i];
          return Card(
            child: ListTile(
              title: Text(k['title']!),
              subtitle: Text('Eval: ${k['evaluationId']}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () =>
                  push(context, '/correction-detail', args: {'id': k['id']}),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => push(context, '/new-correction'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
