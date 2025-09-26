import 'package:flutter/material.dart';
import '../../widgets/bottom_navbar.dart';
import '../../utils/helpers.dart';
import 'course_detail_screen.dart';

class CourseLibraryScreen extends StatefulWidget {
  const CourseLibraryScreen({super.key});

  @override
  State<CourseLibraryScreen> createState() => _CourseLibraryScreenState();
}

class _CourseLibraryScreenState extends State<CourseLibraryScreen> {
  static const Color primaryColor = Color(0xFFFF4444);
  String selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;
  
  List<String> get filters {
    final subjects = courses.map((course) => course['subject'] as String).toSet().toList();
    subjects.sort();
    return ['All', ...subjects];
  }
  
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
      'level': '100',
      'description': 'Comprehensive introduction to fundamental physics concepts including mechanics, thermodynamics, and wave motion. This course provides a solid foundation for advanced physics studies.',
      'duration': '12 weeks',
      'credits': '3',
      'tags': 'Physics, Mechanics, Thermodynamics',
      'uploadDate': '1 week ago',
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
      'level': '300',
      'description': 'In-depth exploration of organic and inorganic chemistry principles, reaction mechanisms, and laboratory techniques for advanced undergraduate students.',
      'duration': '16 weeks',
      'credits': '4',
      'tags': 'Chemistry, Organic, Inorganic',
      'uploadDate': '3 days ago',
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
      'level': '200',
      'description': 'Introduction to machine learning algorithms, data preprocessing, model evaluation, and practical implementation using Python and popular ML libraries.',
      'duration': '14 weeks',
      'credits': '3',
      'tags': 'Computer Science, AI, Python',
      'uploadDate': '2 days ago',
    },
    {
      'id': '4',
      'title': 'History of Renaissance Art',
      'subject': 'Art History',
      'instructor': 'Dr. Michael Brown',
      'downloads': 75,
      'rating': 4.2,
      'color': const Color(0xFF9C27B0),
      'verified': true,
      'level': '200',
      'description': 'Comprehensive study of Renaissance art movements, key artists, and cultural contexts from the 14th to 16th centuries in Europe.',
      'duration': '12 weeks',
      'credits': '3',
      'tags': 'Art History, Renaissance, Culture',
      'uploadDate': '5 days ago',
    },
    {
      'id': '5',
      'title': 'Microeconomics Principles',
      'subject': 'Economics',
      'instructor': 'Prof. Jessica Williams',
      'downloads': 150,
      'rating': 4.7,
      'color': const Color(0xFF607D8B),
      'verified': true,
      'level': '100',
      'description': 'Fundamental principles of microeconomic theory including supply and demand, market structures, consumer behavior, and firm decision-making.',
      'duration': '14 weeks',
      'credits': '3',
      'tags': 'Economics, Markets, Theory',
      'uploadDate': '1 day ago',
    },
  ];

  List<Map<String, dynamic>> get filteredCourses {
    return courses.where((course) {
      final matchesFilter = selectedFilter == 'All' || course['subject'] == selectedFilter;
      final searchQuery = _searchController.text.toLowerCase().trim();
      final matchesSearch = searchQuery.isEmpty || 
          course['title'].toLowerCase().contains(searchQuery) ||
          course['instructor'].toLowerCase().contains(searchQuery) ||
          course['subject'].toLowerCase().contains(searchQuery);
      return matchesFilter && matchesSearch;
    }).toList();
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      isSearching = false;
    });
  }

  void _navigateToCourseDetail(Map<String, dynamic> course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailScreen(courseData: course),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxContentWidth = (screenWidth > 800) ? 800.0 : screenWidth;
    final horizontalPadding = (screenWidth - maxContentWidth) / 2;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Course Library',
          style: TextStyle(
            color: Colors.black,
            fontSize: (maxContentWidth * 0.032).clamp(16.0, 20.0),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.person, size: 20, color: Colors.grey),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar Section
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding + 16,
                vertical: 16,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for courses...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey[600]),
                              onPressed: _clearSearch,
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        isSearching = value.isNotEmpty;
                      });
                    },
                  ),
                ),
              ),
            ),
            
            // Filters Section
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(horizontalPadding + 16, 0, horizontalPadding + 16, 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filters',
                            style: TextStyle(
                              fontSize: (maxContentWidth * 0.025).clamp(14.0, 18.0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            Icons.tune,
                            color: primaryColor,
                            size: (maxContentWidth * 0.03).clamp(18.0, 22.0),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filters.length,
                          itemBuilder: (context, index) {
                            final filter = filters[index];
                            final isSelected = selectedFilter == filter;
                            return Padding(
                              padding: EdgeInsets.only(right: index < filters.length - 1 ? 8.0 : 0.0),
                              child: GestureDetector(
                                onTap: () => setState(() => selectedFilter = filter),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? primaryColor : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isSelected) ...[
                                        Icon(
                                          filter == 'All' ? Icons.apps : Icons.book,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                      ],
                                      Text(
                                        filter,
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : Colors.grey[700],
                                          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                                          fontSize: (maxContentWidth * 0.022).clamp(12.0, 14.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Course List Section
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding + 16,
                  vertical: 16,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxContentWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          filteredCourses.isEmpty && (_searchController.text.isNotEmpty || selectedFilter != 'All')
                              ? _searchController.text.isNotEmpty
                                  ? 'No courses found for "${_searchController.text}"'
                                  : 'No courses found in $selectedFilter'
                              : 'Available Courses',
                          style: TextStyle(
                            fontSize: (maxContentWidth * 0.025).clamp(14.0, 18.0),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_searchController.text.isNotEmpty || selectedFilter != 'All') ...[
                          const SizedBox(height: 4),
                          Text(
                            filteredCourses.isEmpty
                                ? 'Try adjusting your search or filter criteria'
                                : '${filteredCourses.length} course${filteredCourses.length == 1 ? '' : 's'} found',
                            style: TextStyle(
                              fontSize: (maxContentWidth * 0.02).clamp(10.0, 14.0),
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Expanded(
                          child: filteredCourses.isEmpty
                              ? _buildEmptyState(maxContentWidth)
                              : ListView.builder(
                                  itemCount: filteredCourses.length,
                                  itemBuilder: (context, index) {
                                    final course = filteredCourses[index];
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: index < filteredCourses.length - 1 ? 12.0 : 0.0),
                                      child: CourseCard(
                                        course: course,
                                        onTap: () => _navigateToCourseDetail(course),
                                        onDownload: () => _downloadCourse(course),
                                        searchQuery: _searchController.text.toLowerCase().trim(),
                                        maxWidth: maxContentWidth,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => push(context, '/upload-course'),
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
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

  Widget _buildEmptyState(double maxWidth) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: (maxWidth * 0.1).clamp(48.0, 72.0),
            color: Colors.grey[400],
          ),
          SizedBox(height: (maxWidth * 0.03).clamp(12.0, 20.0)),
          Text(
            _searchController.text.isNotEmpty
                ? 'No courses match your search'
                : 'No courses in this category',
            style: TextStyle(
              fontSize: (maxWidth * 0.025).clamp(14.0, 18.0),
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: (maxWidth * 0.015).clamp(6.0, 12.0)),
          Text(
            'Try a different search term or category',
            style: TextStyle(
              fontSize: (maxWidth * 0.022).clamp(12.0, 16.0),
              color: Colors.grey[500],
            ),
          ),
        ],
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
  final VoidCallback onTap;
  final VoidCallback onDownload;
  final String searchQuery;
  final double maxWidth;

  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
    required this.onDownload,
    this.searchQuery = '',
    required this.maxWidth,
  });

  static const Color primaryColor = Color(0xFFFF4444);

  Widget _highlightSearchText(String text, String query) {
    if (query.isEmpty) {
      return Text(
        text,
        style: TextStyle(
          fontSize: text == course['title'] 
              ? (maxWidth * 0.025).clamp(14.0, 18.0)
              : text == course['subject'] 
                  ? (maxWidth * 0.022).clamp(12.0, 16.0)
                  : (maxWidth * 0.02).clamp(10.0, 14.0),
          fontWeight: text == course['title'] ? FontWeight.w600 : FontWeight.normal,
          color: text == course['title'] ? Colors.black : Colors.grey[600],
        ),
      );
    }
    
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    
    if (!lowerText.contains(lowerQuery)) {
      return Text(
        text,
        style: TextStyle(
          fontSize: text == course['title'] 
              ? (maxWidth * 0.025).clamp(14.0, 18.0)
              : text == course['subject'] 
                  ? (maxWidth * 0.022).clamp(12.0, 16.0)
                  : (maxWidth * 0.02).clamp(10.0, 14.0),
          fontWeight: text == course['title'] ? FontWeight.w600 : FontWeight.normal,
          color: text == course['title'] ? Colors.black : Colors.grey[600],
        ),
      );
    }
    
    final startIndex = lowerText.indexOf(lowerQuery);
    final endIndex = startIndex + query.length;
    
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: text == course['title'] 
              ? (maxWidth * 0.025).clamp(14.0, 18.0)
              : text == course['subject'] 
                  ? (maxWidth * 0.022).clamp(12.0, 16.0)
                  : (maxWidth * 0.02).clamp(10.0, 14.0),
          fontWeight: text == course['title'] ? FontWeight.w600 : FontWeight.normal,
          color: text == course['title'] ? Colors.black : Colors.grey[600],
        ),
        children: [
          if (startIndex > 0)
            TextSpan(text: text.substring(0, startIndex)),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: TextStyle(
              backgroundColor: Colors.yellow[300],
              fontWeight: FontWeight.bold,
            ),
          ),
          if (endIndex < text.length)
            TextSpan(text: text.substring(endIndex)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardPadding = (maxWidth * 0.025).clamp(12.0, 20.0);
    final iconSize = (maxWidth * 0.08).clamp(40.0, 60.0);
    
    return GestureDetector(
      onTap: onTap,
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
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Row(
            children: [
              // Course Icon
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: (course['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getSubjectIcon(course['subject']),
                  color: course['color'] as Color,
                  size: iconSize * 0.5,
                ),
              ),
              SizedBox(width: cardPadding),
              
              // Course Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _highlightSearchText(
                      course['title'],
                      searchQuery,
                    ),
                    SizedBox(height: cardPadding * 0.25),
                    _highlightSearchText(
                      course['subject'],
                      searchQuery,
                    ),
                    SizedBox(height: cardPadding * 0.5),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: (maxWidth * 0.015).clamp(6.0, 10.0),
                            vertical: (maxWidth * 0.005).clamp(2.0, 4.0),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'VERIFIED',
                            style: TextStyle(
                              fontSize: (maxWidth * 0.018).clamp(8.0, 12.0),
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: (maxWidth * 0.015).clamp(6.0, 10.0)),
                        Expanded(
                          child: _highlightSearchText(
                            course['instructor'],
                            searchQuery,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: cardPadding * 0.5),
                    Row(
                      children: [
                        Icon(
                          Icons.download_outlined, 
                          size: (maxWidth * 0.022).clamp(12.0, 16.0), 
                          color: Colors.grey[500],
                        ),
                        SizedBox(width: (maxWidth * 0.01).clamp(4.0, 6.0)),
                        Text(
                          '${course['downloads']}',
                          style: TextStyle(
                            fontSize: (maxWidth * 0.02).clamp(10.0, 14.0),
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: cardPadding),
                        Icon(
                          Icons.star, 
                          size: (maxWidth * 0.022).clamp(12.0, 16.0), 
                          color: Colors.amber[600],
                        ),
                        SizedBox(width: (maxWidth * 0.01).clamp(4.0, 6.0)),
                        Text(
                          '${course['rating']}',
                          style: TextStyle(
                            fontSize: (maxWidth * 0.02).clamp(10.0, 14.0),
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Download Button
              GestureDetector(
                onTap: () => onDownload(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: (maxWidth * 0.025).clamp(12.0, 18.0),
                    vertical: (maxWidth * 0.015).clamp(6.0, 10.0),
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.download, 
                        size: (maxWidth * 0.025).clamp(14.0, 18.0), 
                        color: Colors.white,
                      ),
                      SizedBox(width: (maxWidth * 0.01).clamp(4.0, 6.0)),
                      Text(
                        'Download',
                        style: TextStyle(
                          fontSize: (maxWidth * 0.02).clamp(10.0, 14.0),
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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