import 'package:Evalprof/screen/auth/dashboard_screen.dart';
import 'package:Evalprof/screen/notifications/notification_screen.dart';
import 'package:flutter/material.dart';
import '../../utils/helpers.dart';
import '../../widgets/bottom_navbar.dart';

class CorrectionListScreen extends StatefulWidget {
  const CorrectionListScreen({super.key});

  @override
  State<CorrectionListScreen> createState() => _CorrectionListScreenState();
}

class _CorrectionListScreenState extends State<CorrectionListScreen> {
  static const Color primaryColor = Color(0xFFFF4444);
  int idx = 3; // Corrections tab

  void _nav(int i) {
    setState(() => idx = i);
    switch (i) {
      case 0:
        replace(context, '/dashboard');
        break;
      case 1:
        replace(context, '/course-list');
        break;
      case 2:
        replace(context, '/evaluation-generator');
        break;
      case 3:
        // current screen
        break;
      case 4:
        replace(context, '/friends');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final recentCorrections = [
      {
        'id': 'k1',
        'title': 'Mathematics Algebra Evaluation',
        'description':
            'Review proposed corrections for Chapter 3 on linear equations. Focus on question 7 and 12.',
        'subject': 'Mathematics',
        'category': 'Algebra',
        'grade': 'Grade 10',
        'status': 'Pending Review',
        'daysAgo': '2 days ago',
        'statusColor': Colors.orange,
      },
      {
        'id': 'k2',
        'title': 'Physics Lab Report Guidelines',
        'description':
            'Check for consistency in formatting and rubric clarity for the Optics Lab.',
        'subject': 'Physics',
        'category': 'Lab',
        'grade': 'Guidelines',
        'status': 'Needs Attention',
        'daysAgo': '2 days ago',
        'statusColor': Colors.red,
      },
      {
        'id': 'k3',
        'title': 'History Mid-Term Essay Prompts',
        'description':
            'Review suggested alternative prompts and rubric adjustments for the American History mid-term.',
        'subject': 'History',
        'category': 'Mid-Term',
        'grade': 'Prompts',
        'status': 'Comments Added',
        'daysAgo': '2 days ago',
        'statusColor': Colors.blue,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Color(0xFFFF4444), size: 20),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          },
        ),
        title: const Text(
          'Correction Panel',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: Color(0xFFFF4444)),
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

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Stats Section
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Stats',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.schedule,
                          count: '12',
                          label: 'Pending\nReviews',
                          iconColor: const Color(0xFFFF4444),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.chat_bubble_outline,
                          count: '45',
                          label: 'Total\nComments',
                          iconColor: const Color(0xFFFF4444),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Recent Correction Requests
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Recent Correction Requests',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Correction Items
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: recentCorrections.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final correction = recentCorrections[i];
                return _buildCorrectionCard(context, correction);
              },
            ),

            const SizedBox(height: 20),

            // Propose New Correction Section
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Propose New Correction',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F8FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF4A90E2).withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: const Color(0xFF4A90E2),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'All files will be scanned for malicious content. Please adhere to the content guidelines.',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFF4A90E2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Attach your proposed corrected files or supplementary materials here. Max 5 files, 20MB each.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => push(context, '/new-correction'),
                      icon: const Icon(Icons.attach_file, color: Color(0xFF4A90E2)),
                      label: const Text(
                        'Attach New File',
                        style: TextStyle(
                          color: Color(0xFF4A90E2),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF4A90E2)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // My Contributions Section
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Contributions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildContributionItem(
                    icon: Icons.chat_bubble_outline,
                    text: 'You have 7 pending comments awaiting review.',
                    badge: '7',
                    badgeColor: const Color(0xFF4A90E2),
                  ),
                  const SizedBox(height: 12),
                  _buildContributionItem(
                    icon: Icons.check_circle_outline,
                    text: '3 corrections you submitted have been approved.',
                    badge: '3',
                    badgeColor: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildContributionItem(
                    icon: Icons.upload_file,
                    text: "Last uploaded: 'Thermodynamics Chapter 5 Solutions'.",
                    badge: null,
                    badgeColor: null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80), // Bottom padding for navigation
          ],
        ),
      ),
      bottomNavigationBar: BottomNavbar(currentIndex: idx, onTap: _nav),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String count,
    required String label,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorrectionCard(BuildContext context, Map<String, dynamic> correction) {
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
                    color: const Color(0xFFFF4444).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.description,
                    color: Color(0xFFFF4444),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        correction['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        correction['daysAgo'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              correction['description'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTag(correction['subject']),
                const SizedBox(width: 8),
                _buildTag(correction['category']),
                const SizedBox(width: 8),
                _buildTag(correction['grade']),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: correction['statusColor'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 12,
                        color: correction['statusColor'],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        correction['status'],
                        style: TextStyle(
                          fontSize: 12,
                          color: correction['statusColor'],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => push(context, '/correction-detail', args: {'id': correction['id']}),
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 14,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => push(context, '/new-correction', args: {'id': correction['id']}),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4444),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Add Correction',
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

  Widget _buildContributionItem({
    required IconData icon,
    required String text,
    String? badge,
    Color? badgeColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}