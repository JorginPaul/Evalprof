import 'package:flutter/material.dart';

class CorrectionDetailScreen extends StatelessWidget {
  final String correctionId;
  const CorrectionDetailScreen({super.key, required this.correctionId});

  @override
  Widget build(BuildContext context) {
    final correction = {
      'id': correctionId,
      'answerKey': '1) B\n2) C\n3) A\n4) D',
      'notes': 'Ensure students justify answers.',
    };

    return Scaffold(
      appBar: AppBar(title: Text('Correction ${correction['id']}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Answer Key',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SelectableText(correction['answerKey']!),
            const SizedBox(height: 16),
            const Text('Notes', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(correction['notes']!),
          ],
        ),
      ),
    );
  }
}
