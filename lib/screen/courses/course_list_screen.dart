import 'package:flutter/material.dart';
import '../../widgets/bottom_navbar.dart';
import '../../utils/helpers.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = const [
      {'id': 'c1', 'title': 'Mathematics', 'level': '200'},
      {'id': 'c2', 'title': 'Computer Science', 'level': '300'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Your Courses')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: courses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final c = courses[i];
          return Card(
            child: ListTile(
              title: Text(c['title']!),
              subtitle: Text('Level ${c['level']}'),
              onTap: () =>
                  push(context, '/course-detail', args: {'id': c['id']}),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => push(context, '/upload-course'),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: 1,
        onTap: (i) {
          switch (i) {
            case 0:
              replace(context, '/dashboard');
              break;
            case 1:
              break;
            case 2:
              replace(context, '/evaluation-generator');
              break;
            case 3:
              replace(context, '/corrections');
              break;
            case 4:
              replace(context, '/friends');
              break;
          }
        },
      ),
    );
  }
}
