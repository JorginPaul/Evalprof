import 'package:flutter/material.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseId;
  const CourseDetailScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    // Simulated detail (replace with real fetch)
    final course = {
      'id': courseId,
      'title': 'Sample Course',
      'level': '200',
      'description': 'Course description...',
    };

    return Scaffold(
      appBar: AppBar(title: Text(course['title']!)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Level ${course['level']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(course['description']!, style: const TextStyle(fontSize: 14)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, '/evaluation-generator'),
                icon: const Icon(Icons.quiz_outlined),
                label: const Text('Generate Evaluation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
