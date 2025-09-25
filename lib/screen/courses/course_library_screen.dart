import 'package:Evalprof/screen/notifications/notification_screen.dart';
import 'package:Evalprof/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import '../../widgets/bottom_navbar.dart';
import '../../utils/helpers.dart';

class CourseLibraryScreen extends StatefulWidget {
  const CourseLibraryScreen({super.key});

  @override
  State<CourseLibraryScreen> createState() => _CourseLibraryScreenState();
}

class _CourseLibraryScreenState extends State<CourseLibraryScreen> {
  String selectedFilter = 'Physics';
  final TextEditingController _searchController = TextEditingController();

  final List<String> filters = [
    'Physics',
    'Chemistry',
    'Computer Science',
    'Mathematics',
    'Biology',
    'Art History',
    'Economics',
    'All'
  ];

  final List<Map<String, dynamic>> courses = [
    {
      'id': '1',
      'title': 'Introduction to Physics',
      'subject': 'Physics',
      'instructor': 'Dr. Emily Carter',
      'downloads': 125,
      'rating': 4.8,
      'color': const Color(0xFF2196F3),
      'verified': true,
    },
    {
      'id': '2',
      'title': 'Advanced Chemistry',
      'subject': 'Chemistry',
      'instructor': 'Prof. David Lee',
      'downloads': 98,
      'rating': 4.5,
      'color': const Color(0xFFFF5722),
      'verified': true,
    },
    {
      'id': '3',
      'title': 'Machine Learning Fundamentals',
      'subject': 'Computer Science',
      'instructor': 'Dr. Sarah Chen',
      'downloads': 210,
      'rating': 4.9,
      'color': const Color(0xFF4CAF50),
      'verified': true,
    },
    {
      'id': '4',
      'title': 'History of Renaissance Art',
      'subject': 'Art History',
      'instructor': 'Dr. Michael Brown',
      'downloads': 75,
      'rating': 4.2,
      'color': const Color(0xFF2196F3),
      'verified': true,
    },
    {
      'id': '5',
      'title': 'Micro-Economics Principles',
      'subject': 'Economics',
      'instructor': 'Prof. Jessica Williams',
      'downloads': 150,
      'rating': 4.7,
      'color': const Color(0xFF2196F3),
      'verified': true,
    },
  ];

  List<Map<String, dynamic>> get filteredCourses {
    return courses.where((course) {
      final matchesFilter =
          selectedFilter == 'All' || course['subject'] == selectedFilter;
      final matchesSearch = _searchController.text.isEmpty ||
          course['title']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          course['instructor']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Course Library',
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Search Bar
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for courses...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),

              // Filters Section
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.tune,
                          color: Color(0xFFFF4444),
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: filters.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final filter = filters[index];
                          final isSelected = selectedFilter == filter;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => selectedFilter = filter),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFFF4444)
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSelected) ...[
                                    const Icon(Icons.book,
                                        size: 16, color: Colors.white),
                                    const SizedBox(width: 4),
                                  ],
                                  Text(
                                    filter,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey[700],
                                      fontWeight: isSelected
                                          ? FontWeight.w500
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Available Courses Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Available Courses',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Responsive Grid/List
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = isTablet ? 2 : 1;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: isTablet ? 3.5 : 2.8,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: filteredCourses.length,
                          itemBuilder: (context, index) {
                            final course = filteredCourses[index];
                            return CourseCard(
                              course: course,
                              onDownload: () => _downloadCourse(course),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

  void _downloadCourse(Map<String, dynamic> course) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading "${course['title']}"...'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final VoidCallback onDownload;

  const CourseCard({
    super.key,
    required this.course,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to course detail page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening ${course['title']}...')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Course Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: course['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getSubjectIcon(course['subject']),
                color: course['color'],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Course Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course['subject'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'VERIFIED',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          course['instructor'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.download_outlined,
                          size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        '${course['downloads']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.star,
                          size: 14, color: Colors.amber[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${course['rating']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Download Button
            ElevatedButton(
              onPressed: onDownload,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4444),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.download, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Download',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'physics':
        return Icons.scatter_plot;
      case 'chemistry':
        return Icons.science;
      case 'computer science':
        return Icons.computer;
      case 'mathematics':
        return Icons.calculate;
      case 'art history':
        return Icons.palette;
      case 'economics':
        return Icons.trending_up;
      default:
        return Icons.book;
    }
  }
}