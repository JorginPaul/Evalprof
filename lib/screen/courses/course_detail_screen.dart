import 'package:Evalprof/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:Evalprof/screen/profile/profile_screen.dart'; // Adjust the import path as needed

class CourseDetailScreen extends StatelessWidget {
  final String? courseId; // Optional for backward compatibility
  final Map<String, dynamic>? courseData; // New parameter for course data
  
  const CourseDetailScreen({
    super.key, 
    this.courseId,
    this.courseData,
  });
  
  static const Color primaryColor = Color(0xFFFF4444);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxContentWidth = (screenWidth > 800) ? 800.0 : screenWidth;
    final horizontalPadding = (screenWidth - maxContentWidth) / 2;

    // Use provided courseData or fallback to simulated data
    final course = courseData ?? {
      'id': courseId ?? 'sample',
      'title': 'Sample Course',
      'level': '200',
      'subject': 'General Studies',
      'description': 'This is a sample course description. Replace with actual course data from your database or API.',
      'instructor': 'Sample Instructor',
      'uploadDate': '1 week ago',
      'duration': '12 weeks',
      'credits': '3',
      'tags': 'Sample, Course, Education',
      'downloads': 0,
      'rating': 0.0,
      'verified': true,
    };

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Course Details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: (maxContentWidth * 0.032).clamp(16.0, 20.0),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
            onPressed: () {
              // Show notifications or handle notification action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No new notifications'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: primaryColor,
                child: const Text(
                  'JD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                _buildCourseHeader(course, maxContentWidth),
                const SizedBox(height: 24),
                _buildCourseInfo(course, maxContentWidth),
                const SizedBox(height: 24),
                _buildCourseDescription(course, maxContentWidth),
                const SizedBox(height: 24),
                _buildTagsSection(course, maxContentWidth),
                if (courseData != null) ...[
                  const SizedBox(height: 24),
                  _buildCourseStats(course, maxContentWidth),
                ],
                const SizedBox(height: 32),
                _buildActionButtons(context, maxContentWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseHeader(Map<String, dynamic> course, double maxWidth) {
    final headerPadding = (maxWidth * 0.06).clamp(16.0, 32.0);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(headerPadding),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: (maxWidth * 0.02).clamp(8.0, 12.0),
                  vertical: (maxWidth * 0.01).clamp(4.0, 6.0),
                ),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Level ${course['level']}',
                  style: TextStyle(
                    fontSize: (maxWidth * 0.022).clamp(12.0, 14.0),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: (maxWidth * 0.02).clamp(8.0, 12.0),
                  vertical: (maxWidth * 0.01).clamp(4.0, 6.0),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  course['subject'] ?? 'General Studies',
                  style: TextStyle(
                    fontSize: (maxWidth * 0.022).clamp(12.0, 14.0),
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[700],
                  ),
                ),
              ),
              if (course['verified'] == true) ...[
                SizedBox(width: (maxWidth * 0.02).clamp(8.0, 12.0)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: (maxWidth * 0.02).clamp(8.0, 12.0),
                    vertical: (maxWidth * 0.01).clamp(4.0, 6.0),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified,
                        size: (maxWidth * 0.022).clamp(12.0, 14.0),
                        color: Colors.green[700],
                      ),
                      SizedBox(width: (maxWidth * 0.01).clamp(2.0, 4.0)),
                      Text(
                        'VERIFIED',
                        style: TextStyle(
                          fontSize: (maxWidth * 0.018).clamp(10.0, 12.0),
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: headerPadding * 0.5),
          Text(
            course['title'] ?? 'Untitled Course',
            style: TextStyle(
              fontSize: (maxWidth * 0.045).clamp(22.0, 28.0),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
          SizedBox(height: headerPadding * 0.25),
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: (maxWidth * 0.025).clamp(14.0, 18.0),
                color: Colors.grey[600],
              ),
              SizedBox(width: (maxWidth * 0.01).clamp(4.0, 8.0)),
              Text(
                course['instructor'] ?? 'Unknown Instructor',
                style: TextStyle(
                  fontSize: (maxWidth * 0.025).clamp(14.0, 16.0),
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.access_time_outlined,
                size: (maxWidth * 0.025).clamp(14.0, 18.0),
                color: Colors.grey[600],
              ),
              SizedBox(width: (maxWidth * 0.01).clamp(4.0, 8.0)),
              Text(
                course['uploadDate'] ?? 'Unknown date',
                style: TextStyle(
                  fontSize: (maxWidth * 0.022).clamp(12.0, 14.0),
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCourseInfo(Map<String, dynamic> course, double maxWidth) {
    final cardPadding = (maxWidth * 0.04).clamp(16.0, 24.0);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course Information',
              style: TextStyle(
                fontSize: (maxWidth * 0.035).clamp(18.0, 22.0),
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: cardPadding * 0.75),
            _buildInfoRow(
              'Duration',
              course['duration'] ?? 'Not specified',
              Icons.schedule_outlined,
              maxWidth,
            ),
            SizedBox(height: cardPadding * 0.5),
            _buildInfoRow(
              'Credits',
              '${course['credits'] ?? 'N/A'} Credits',
              Icons.school_outlined,
              maxWidth,
            ),
            SizedBox(height: cardPadding * 0.5),
            _buildInfoRow(
              'Course ID',
              course['id'] ?? 'Unknown',
              Icons.tag_outlined,
              maxWidth,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, double maxWidth) {
    return Row(
      children: [
        Icon(
          icon,
          size: (maxWidth * 0.03).clamp(18.0, 22.0),
          color: primaryColor,
        ),
        SizedBox(width: (maxWidth * 0.025).clamp(12.0, 16.0)),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: (maxWidth * 0.025).clamp(14.0, 16.0),
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: (maxWidth * 0.025).clamp(14.0, 16.0),
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseDescription(Map<String, dynamic> course, double maxWidth) {
    final cardPadding = (maxWidth * 0.04).clamp(16.0, 24.0);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: TextStyle(
                fontSize: (maxWidth * 0.035).clamp(18.0, 22.0),
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: cardPadding * 0.75),
            Text(
              course['description'] ?? 'No description available.',
              style: TextStyle(
                fontSize: (maxWidth * 0.025).clamp(14.0, 16.0),
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsSection(Map<String, dynamic> course, double maxWidth) {
    final tagsString = course['tags'] ?? '';
    final tags = tagsString.isNotEmpty ? tagsString.split(', ') : <String>['No tags'];
    final cardPadding = (maxWidth * 0.04).clamp(16.0, 24.0);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tags',
              style: TextStyle(
                fontSize: (maxWidth * 0.035).clamp(18.0, 22.0),
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: cardPadding * 0.75),
            Wrap(
              spacing: (maxWidth * 0.02).clamp(8.0, 12.0),
              runSpacing: (maxWidth * 0.015).clamp(6.0, 8.0),
              children: tags.map<Widget>((tag) => Container(
                padding: EdgeInsets.symmetric(
                  horizontal: (maxWidth * 0.025).clamp(12.0, 16.0),
                  vertical: (maxWidth * 0.015).clamp(6.0, 8.0),
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primaryColor.withOpacity(0.3)),
                ),
                child: Text(
                  tag.trim(),
                  style: TextStyle(
                    fontSize: (maxWidth * 0.022).clamp(12.0, 14.0),
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseStats(Map<String, dynamic> course, double maxWidth) {
    final cardPadding = (maxWidth * 0.04).clamp(16.0, 24.0);
    final downloads = course['downloads'] ?? 0;
    final rating = course['rating']?.toDouble() ?? 0.0;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course Statistics',
              style: TextStyle(
                fontSize: (maxWidth * 0.035).clamp(18.0, 22.0),
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: cardPadding * 0.75),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Downloads',
                    downloads.toString(),
                    Icons.download_outlined,
                    Colors.blue,
                    maxWidth,
                  ),
                ),
                SizedBox(width: (maxWidth * 0.04).clamp(16.0, 24.0)),
                Expanded(
                  child: _buildStatItem(
                    'Rating',
                    rating > 0 ? rating.toStringAsFixed(1) : 'N/A',
                    Icons.star_outlined,
                    Colors.amber,
                    maxWidth,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color, double maxWidth) {
    return Container(
      padding: EdgeInsets.all((maxWidth * 0.025).clamp(12.0, 16.0)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: (maxWidth * 0.04).clamp(20.0, 24.0),
            color: color,
          ),
          SizedBox(height: (maxWidth * 0.015).clamp(6.0, 8.0)),
          Text(
            value,
            style: TextStyle(
              fontSize: (maxWidth * 0.032).clamp(16.0, 20.0),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: (maxWidth * 0.01).clamp(2.0, 4.0)),
          Text(
            label,
            style: TextStyle(
              fontSize: (maxWidth * 0.022).clamp(12.0, 14.0),
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, double maxWidth) {
    final buttonHeight = (maxWidth * 0.08).clamp(48.0, 56.0);
    final buttonPadding = (maxWidth * 0.025).clamp(12.0, 16.0);
    final fontSize = (maxWidth * 0.025).clamp(14.0, 16.0);
    
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: buttonHeight,
          child: ElevatedButton.icon(
            onPressed: () {
              // Navigate to evaluation generator or show message if route doesn't exist
              try {
                Navigator.pushNamed(context, '/evaluation-generator');
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Evaluation generator coming soon!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: buttonPadding),
            ),
            icon: Icon(
              Icons.quiz_outlined,
              size: (maxWidth * 0.03).clamp(18.0, 22.0),
            ),
            label: Text(
              'Generate Evaluation',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: (maxWidth * 0.025).clamp(12.0, 16.0)),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: buttonHeight * 0.85,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Download started')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(
                    Icons.download_outlined,
                    size: (maxWidth * 0.028).clamp(16.0, 20.0),
                  ),
                  label: Text(
                    'Download',
                    style: TextStyle(
                      fontSize: fontSize * 0.9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: (maxWidth * 0.025).clamp(12.0, 16.0)),
            Expanded(
              child: SizedBox(
                height: buttonHeight * 0.85,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Shared successfully')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue[700],
                    side: BorderSide(color: Colors.blue[700]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(
                    Icons.share_outlined,
                    size: (maxWidth * 0.028).clamp(16.0, 20.0),
                  ),
                  label: Text(
                    'Share',
                    style: TextStyle(
                      fontSize: fontSize * 0.9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}