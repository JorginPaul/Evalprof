import 'package:EvalProfs/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  static const Color primaryColor = Color(0xFFFF4444);
  String selectedFilter = 'All';

  // Sample notification data
  final List<Map<String, dynamic>> notifications = [
    {
      'id': 1,
      'type': 'course_uploaded',
      'icon': Icons.description_outlined,
      'title': 'Course Upload Successful',
      'message': 'Your "Advanced Calculus II Notes" has been uploaded and is now pending validation.',
      'time': '5 minutes ago',
      'isRead': false,
      'actionLabel': 'View Course',
    },
    {
      'id': 2,
      'type': 'evaluation_generated',
      'icon': Icons.auto_awesome_outlined,
      'title': 'Evaluation Generated',
      'message': 'AI has successfully generated an evaluation for "Introduction to Philosophy".',
      'time': '2 hours ago',
      'isRead': false,
      'actionLabel': 'View Evaluation',
    },
    {
      'id': 3,
      'type': 'correction_received',
      'icon': Icons.edit_outlined,
      'title': 'New Correction Suggested',
      'message': 'Dr. Sarah Chen suggested corrections for your "Linear Algebra Quiz".',
      'time': '1 day ago',
      'isRead': true,
      'actionLabel': 'Review',
    },
    {
      'id': 4,
      'type': 'friend_request',
      'icon': Icons.person_add_outlined,
      'title': 'New Connection Request',
      'message': 'Prof. Michael Johnson wants to connect with you.',
      'time': '2 days ago',
      'isRead': true,
      'actionLabel': 'Accept',
    },
    {
      'id': 5,
      'type': 'course_validated',
      'icon': Icons.check_circle_outlined,
      'title': 'Course Validated',
      'message': 'Your "Statistics Fundamentals" course has been validated and published.',
      'time': '3 days ago',
      'isRead': true,
      'actionLabel': 'View',
    },
    {
      'id': 6,
      'type': 'message_received',
      'icon': Icons.message_outlined,
      'title': 'New Message',
      'message': 'Dr. Emily Roberts sent you a message about collaboration opportunities.',
      'time': '4 days ago',
      'isRead': true,
      'actionLabel': 'Reply',
    },
    {
      'id': 7,
      'type': 'course_feedback',
      'icon': Icons.rate_review_outlined,
      'title': 'Course Feedback Received',
      'message': 'Your "Organic Chemistry" course received 5-star feedback from 3 lecturers.',
      'time': '1 week ago',
      'isRead': true,
      'actionLabel': 'View Feedback',
    },
  ];

  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilter == 'All') {
      return notifications;
    } else if (selectedFilter == 'Unread') {
      return notifications.where((n) => !n['isRead']).toList();
    }
    return notifications;
  }

  int get unreadCount => notifications.where((n) => !n['isRead']).length;

  void _markAsRead(int id) {
    setState(() {
      final notification = notifications.firstWhere((n) => n['id'] == id);
      notification['isRead'] = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteNotification(int id) {
    setState(() {
      notifications.removeWhere((n) => n['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'course_uploaded':
      case 'evaluation_generated':
        return primaryColor;
      case 'correction_received':
        return Colors.orange;
      case 'friend_request':
        return Colors.blue;
      case 'course_validated':
        return Colors.green;
      case 'message_received':
        return Colors.purple;
      case 'course_feedback':
        return Colors.teal;
      default:
        return primaryColor;
    }
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
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (unreadCount > 0)
            IconButton(
              icon: const Icon(Icons.done_all, color: Colors.black87),
              onPressed: _markAllAsRead,
              tooltip: 'Mark all as read',
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
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, size: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding + 16,
              vertical: 12,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: Row(
                  children: [
                    _buildFilterChip('All', notifications.length),
                    const SizedBox(width: 8),
                    _buildFilterChip('Unread', unreadCount),
                  ],
                ),
              ),
            ),
          ),

          // Notifications list
          Expanded(
            child: filteredNotifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding + 16,
                      vertical: 16,
                    ),
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      return Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxContentWidth),
                          child: _buildNotificationCard(notification),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int count) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: isSelected ? primaryColor : Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['isRead'] as bool;
    final notificationColor = _getNotificationColor(notification['type']);

    return Dismissible(
      key: Key(notification['id'].toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _deleteNotification(notification['id']),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      child: Card(
        elevation: isRead ? 0 : 2,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isRead ? Colors.grey[200]! : primaryColor.withOpacity(0.2),
          ),
        ),
        color: isRead ? Colors.white : primaryColor.withOpacity(0.02),
        child: InkWell(
          onTap: () => _markAsRead(notification['id']),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: notificationColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    notification['icon'] as IconData,
                    color: notificationColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification['message'],
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notification['time'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _markAsRead(notification['id']);
                              // Handle action based on notification type
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              notification['actionLabel'],
                              style: TextStyle(
                                fontSize: 12,
                                color: notificationColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
            Icons.notifications_none_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            selectedFilter == 'Unread'
                ? 'No unread notifications'
                : 'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            selectedFilter == 'Unread'
                ? 'All caught up!'
                : 'You\'ll see updates about your courses and connections here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}