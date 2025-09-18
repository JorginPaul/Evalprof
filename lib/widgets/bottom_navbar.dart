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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFFF4444),
          unselectedItemColor: Colors.grey[400],
          selectedFontSize: 12,
          unselectedFontSize: 11,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
          ),
          items: [
            BottomNavigationBarItem(
              icon: _buildNavItem(
                icon: Icons.dashboard_outlined,
                selectedIcon: Icons.dashboard,
                isSelected: currentIndex == 0,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildNavItem(
                icon: Icons.menu_book_outlined,
                selectedIcon: Icons.menu_book,
                isSelected: currentIndex == 1,
              ),
              label: 'Courses',
            ),
            BottomNavigationBarItem(
              icon: _buildNavItem(
                icon: Icons.quiz_outlined,
                selectedIcon: Icons.quiz,
                isSelected: currentIndex == 2,
              ),
              label: 'Evaluate',
            ),
            BottomNavigationBarItem(
              icon: _buildNavItem(
                icon: Icons.rule_folder_outlined,
                selectedIcon: Icons.rule_folder,
                isSelected: currentIndex == 3,
              ),
              label: 'Corrections',
            ),
            BottomNavigationBarItem(
              icon: _buildNavItem(
                icon: Icons.people_outline,
                selectedIcon: Icons.people,
                isSelected: currentIndex == 4,
              ),
              label: 'Friends',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected 
            ? const Color(0xFFFF4444).withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isSelected ? selectedIcon : icon,
        size: 24,
        color: isSelected 
            ? const Color(0xFFFF4444)
            : Colors.grey[400],
      ),
    );
  }
}