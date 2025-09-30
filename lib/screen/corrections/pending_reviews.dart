import 'package:flutter/material.dart';
import '../../utils/helpers.dart';

class PendingReviewsScreen extends StatefulWidget {
  const PendingReviewsScreen({super.key});

  @override
  State<PendingReviewsScreen> createState() => _PendingReviewsScreenState();
}

class _PendingReviewsScreenState extends State<PendingReviewsScreen> {
  static const Color primaryColor = Color(0xFFFF4444);

  final pendingReviews = [
    {
      'id': 'pr1',
      'title': 'Mathematics Algebra Evaluation',
      'description': 'Review proposed corrections for Chapter 3 on linear equations.',
      'subject': 'Mathematics',
      'category': 'Algebra',
      'grade': 'Grade 10',
      'submittedBy': 'Dr. John Smith',
      'daysAgo': '2 days ago',
      'priority': 'High',
    },
    {
      'id': 'pr2',
      'title': 'Physics Lab Report Guidelines',
      'description': 'Check for consistency in formatting and rubric clarity.',
      'subject': 'Physics',
      'category': 'Lab',
      'grade': 'Guidelines',
      'submittedBy': 'Prof. Emily Chen',
      'daysAgo': '3 days ago',
      'priority': 'Medium',
    },
    {
      'id': 'pr3',
      'title': 'Chemistry Mid-Term Questions',
      'description': 'Review question difficulty and answer key accuracy.',
      'subject': 'Chemistry',
      'category': 'Mid-Term',
      'grade': 'Grade 11',
      'submittedBy': 'Dr. Michael Brown',
      'daysAgo': '4 days ago',
      'priority': 'High',
    },
    {
      'id': 'pr4',
      'title': 'Biology Evolution Chapter Test',
      'description': 'Check alignment with curriculum standards.',
      'subject': 'Biology',
      'category': 'Test',
      'grade': 'Grade 12',
      'submittedBy': 'Prof. Sarah Johnson',
      'daysAgo': '5 days ago',
      'priority': 'Low',
    },
    {
      'id': 'pr5',
      'title': 'English Literature Essay Prompts',
      'description': 'Review prompt clarity and rubric comprehensiveness.',
      'subject': 'English',
      'category': 'Essay',
      'grade': 'Grade 10',
      'submittedBy': 'Dr. David Lee',
      'daysAgo': '1 week ago',
      'priority': 'Medium',
    },
  ];

  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredReviews = _selectedFilter == 'All'
        ? pendingReviews
        : pendingReviews.where((r) => r['priority'] == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pending Reviews',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Summary Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
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
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.schedule,
                    color: primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${filteredReviews.length} Reviews Pending',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Please review and provide feedback',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('All', pendingReviews.length),
                const SizedBox(width: 8),
                _buildFilterChip('High', pendingReviews.where((r) => r['priority'] == 'High').length),
                const SizedBox(width: 8),
                _buildFilterChip('Medium', pendingReviews.where((r) => r['priority'] == 'Medium').length),
                const SizedBox(width: 8),
                _buildFilterChip('Low', pendingReviews.where((r) => r['priority'] == 'Low').length),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Reviews List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredReviews.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _buildReviewCard(filteredReviews[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int count) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedFilter = label);
      },
      backgroundColor: Colors.white,
      selectedColor: primaryColor.withOpacity(0.1),
      labelStyle: TextStyle(
        color: isSelected ? primaryColor : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? primaryColor : Colors.grey[300]!,
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    Color priorityColor;
    switch (review['priority']) {
      case 'High':
        priorityColor = Colors.red;
        break;
      case 'Medium':
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }

    return Container(
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.description,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Submitted by ${review['submittedBy']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    review['priority'],
                    style: TextStyle(
                      fontSize: 11,
                      color: priorityColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review['description'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTag(review['subject']),
                _buildTag(review['category']),
                _buildTag(review['grade']),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  review['daysAgo'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => push(context, '/correction-detail', args: {'id': review['id']}),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Review Now',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}