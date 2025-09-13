import 'package:flutter/material.dart';
import '../../utils/helpers.dart';
import '../../widgets/bottom_navbar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int idx = 0;

  void _nav(int i) {
    setState(() => idx = i);
    switch (i) {
      case 0:
        break;
      case 1:
        replace(context, '/course-list');
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lecturer Hub Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('Courses'),
              subtitle: const Text('Manage and upload your courses'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => push(context, '/course-list'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('AI Evaluation Generator'),
              subtitle: const Text('Create questions using AI'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => push(context, '/evaluation-generator'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Corrections'),
              subtitle: const Text('Create and review corrections'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => push(context, '/corrections'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Friends & Collaboration'),
              subtitle: const Text('Find and connect with lecturers'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => push(context, '/friends'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavbar(currentIndex: 0, onTap: _nav),
    );
  }
}
