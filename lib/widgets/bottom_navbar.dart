import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_outlined),
          label: 'Courses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.quiz_outlined),
          label: 'Evaluate',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.rule_folder_outlined),
          label: 'Corrections',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: 'Friends',
        ),
      ],
    );
  }
}
