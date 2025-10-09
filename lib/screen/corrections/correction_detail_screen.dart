import 'package:EvalProfs/screen/notifications/notification_screen.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Correction Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFFFF4444)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationScreen()),
              );
            },
          ),
        ],
      ),
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
