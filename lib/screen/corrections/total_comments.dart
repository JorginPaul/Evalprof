import 'package:EvalProfs/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import '../../utils/helpers.dart';

class TotalCommentsScreen extends StatefulWidget {
  const TotalCommentsScreen({super.key});

  @override
  State<TotalCommentsScreen> createState() => _TotalCommentsScreenState();
}

class _TotalCommentsScreenState extends State<TotalCommentsScreen> {
  static const Color primaryColor = Color(0xFFFF4444);

  final comments = [
    {
      'id': 'c1',
      'author': 'Dr. John Smith',
      'content': 'Question 7 needs more clarity. Consider rephrasing to avoid ambiguity in the linear equation section.',
      'documentTitle': 'Mathematics Algebra Evaluation',
      'timeAgo': '2 hours ago',
      'type': 'Suggestion',
      'replies': 2,
    },
    {
      'id': 'c2',
      'author': 'Prof. Emily Chen',
      'content': 'The rubric looks good, but I think we should add more weight to the experimental procedure section.',
      'documentTitle': 'Physics Lab Report Guidelines',
      'timeAgo': '5 hours ago',
      'type': 'Feedback',
      'replies': 1,
    },
    {
      'id': 'c3',
      'author': 'Dr. Michael Brown',
      'content': 'Excellent work! The questions are well-balanced across different difficulty levels.',
      'documentTitle': 'Chemistry Mid-Term Questions',
      'timeAgo': '1 day ago',
      'type': 'Approval',
      'replies': 0,
    },
    {
      'id': 'c4',
      'author': 'Prof. Sarah Johnson',
      'content': 'This doesn\'t align with the new curriculum standards. Please review section 3.',
      'documentTitle': 'Biology Evolution Chapter Test',
      'timeAgo': '1 day ago',
      'type': 'Issue',
      'replies': 3,
    },
    {
      'id': 'c5',
      'author': 'Dr. David Lee',
      'content': 'The essay prompts are creative and thought-provoking. Well done!',
      'documentTitle': 'English Literature Essay Prompts',
      'timeAgo': '2 days ago',
      'type': 'Approval',
      'replies': 1,
    },
    {
      'id': 'c6',
      'author': 'Prof. Maria Garcia',
      'content': 'Consider adding more visual aids to help students understand the concepts better.',
      'documentTitle': 'History Mid-Term Essay Prompts',
      'timeAgo': '2 days ago',
      'type': 'Suggestion',
      'replies': 0,
    },
    {
      'id': 'c7',
      'author': 'Dr. James Wilson',
      'content': 'The assessment criteria are comprehensive. Great attention to detail.',
      'documentTitle': 'Economics Final Exam',
      'timeAgo': '3 days ago',
      'type': 'Approval',
      'replies': 2,
    },
    {
      'id': 'c8',
      'author': 'Prof. Linda Martinez',
      'content': 'Some questions seem too advanced for this grade level. Consider simplifying.',
      'documentTitle': 'Geography Quiz Grade 9',
      'timeAgo': '3 days ago',
      'type': 'Issue',
      'replies': 4,
    },
  ];

  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredComments = _selectedFilter == 'All'
        ? comments
        : comments.where((c) => c['type'] == _selectedFilter).toList();

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
          'All Comments',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              // Implement search functionality
              showSearch(
                context: context,
                delegate: CommentSearchDelegate(comments),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen())
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, size: 20, color: Colors.white),
              ),
            ),
          ),
        ],
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
                    Icons.chat_bubble_outline,
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
                        '${filteredComments.length} Total Comments',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Across all correction documents',
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
                _buildFilterChip('All', comments.length),
                const SizedBox(width: 8),
                _buildFilterChip('Suggestion', comments.where((c) => c['type'] == 'Suggestion').length),
                const SizedBox(width: 8),
                _buildFilterChip('Feedback', comments.where((c) => c['type'] == 'Feedback').length),
                const SizedBox(width: 8),
                _buildFilterChip('Issue', comments.where((c) => c['type'] == 'Issue').length),
                const SizedBox(width: 8),
                _buildFilterChip('Approval', comments.where((c) => c['type'] == 'Approval').length),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Comments List
          Expanded(
            child: filteredComments.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredComments.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _buildCommentCard(filteredComments[i]),
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
        fontSize: 13,
      ),
      side: BorderSide(
        color: isSelected ? primaryColor : Colors.grey[300]!,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    );
  }

  Widget _buildCommentCard(Map<String, dynamic> comment) {
    Color typeColor;
    IconData typeIcon;
    switch (comment['type']) {
      case 'Suggestion':
        typeColor = const Color(0xFF4A90E2);
        typeIcon = Icons.lightbulb_outline;
        break;
      case 'Feedback':
        typeColor = Colors.orange;
        typeIcon = Icons.feedback_outlined;
        break;
      case 'Issue':
        typeColor = Colors.red;
        typeIcon = Icons.error_outline;
        break;
      case 'Approval':
        typeColor = Colors.green;
        typeIcon = Icons.check_circle_outline;
        break;
      default:
        typeColor = Colors.grey;
        typeIcon = Icons.comment_outlined;
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
                CircleAvatar(
                  radius: 20,
                  backgroundColor: primaryColor.withOpacity(0.1),
                  child: Text(
                    comment['author'].toString().substring(0, 1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment['author'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        comment['timeAgo'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(typeIcon, size: 14, color: typeColor),
                      const SizedBox(width: 4),
                      Text(
                        comment['type'],
                        style: TextStyle(
                          fontSize: 11,
                          color: typeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                comment['content'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.description_outlined, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    comment['documentTitle'],
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (comment['replies'] > 0) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.reply, size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${comment['replies']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Handle reply
                      _showReplyDialog(comment);
                    },
                    icon: const Icon(Icons.reply, size: 16),
                    label: const Text('Reply'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[300]!),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => push(context, '/correction-detail', args: {'id': comment['id']}),
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: const Text('View'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No comments found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showReplyDialog(Map<String, dynamic> comment) {
    final TextEditingController replyController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reply to Comment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                comment['content'],
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: replyController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write your reply...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (replyController.text.isNotEmpty) {
                // Handle reply submission
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reply sent successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
            child: const Text('Send Reply'),
          ),
        ],
      ),
    );
  }
}

// Search Delegate for Comments
class CommentSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> comments;

  CommentSearchDelegate(this.comments);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = comments.where((comment) {
      final searchLower = query.toLowerCase();
      return comment['author'].toString().toLowerCase().contains(searchLower) ||
          comment['content'].toString().toLowerCase().contains(searchLower) ||
          comment['documentTitle'].toString().toLowerCase().contains(searchLower);
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final comment = results[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFFF4444).withOpacity(0.1),
              child: Text(
                comment['author'].toString().substring(0, 1),
                style: const TextStyle(color: Color(0xFFFF4444)),
              ),
            ),
            title: Text(comment['author']),
            subtitle: Text(
              comment['content'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            onTap: () {
              close(context, comment['id']);
            },
          ),
        );
      },
    );
  }
}