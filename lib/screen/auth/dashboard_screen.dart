import 'package:Evalprof/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/helpers.dart';
import '../../widgets/bottom_navbar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int idx = 0;
  static const Color primaryColor = Color(0xFFFF4444);

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
      case 5:
        replace(context, '/profile_screen');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1.
    final screenWidth = MediaQuery.of(context).size.width;
    final maxContentWidth = (screenWidth > 800) ? 800.0 : screenWidth;
    final horizontalPadding = (screenWidth - maxContentWidth) / 2;
    final contentPadding = EdgeInsets.symmetric(
      horizontal: horizontalPadding + 16,
      vertical: 16,
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
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

      body: SingleChildScrollView(
        padding: contentPadding,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Header Section - Welcome Banner
              _buildWelcomeBanner(),
              const SizedBox(height: 24),
              
              // Quick Actions Section
              _buildQuickActionsSection(),
              const SizedBox(height: 24),
              
              // Recent Activity Section
              _buildRecentActivitySection(),
              const SizedBox(height: 24),
              
              // Platform Usage Overview Section
              _buildUsageOverviewSection(),
              const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavbar(currentIndex: 0, onTap: _nav),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 251, 242, 244),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFFF4444)),
      ),
      child: Column(
        children: [
          Text(
            'Welcome Back,\nLecturer!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF4444),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your personalized hub for academic\nexcellence and collaboration.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            _buildActionCard(
              icon: Icons.upload_file_outlined,
              iconColor: Color(0xFFFF4444),
              title: 'Upload Course',
              subtitle: 'Share your learning\nmaterials effortlessly',
              onTap: () => push(context, '/course-list'),
            ),
            _buildActionCard(
              icon: Icons.auto_awesome_outlined,
              iconColor: Color(0xFFFF4444),
              title: 'Generate Evaluation',
              subtitle: 'Craft AI-powered\nassessments in\nminutes',
              onTap: () => push(context, '/evaluation-generator'),
            ),
            _buildActionCard(
              icon: Icons.people_outline,
              iconColor: Color(0xFFFF4444),
              title: 'Connect with Peers',
              subtitle: 'Expand your\nacademic network',
              onTap: () => push(context, '/friends'),
            ),
            _buildActionCard(
              icon: Icons.edit_outlined,
              iconColor: Color(0xFFFF4444),
              title: 'Review Corrections',
              subtitle: 'Provide feedback and\nrefine content',
              onTap: () => push(context, '/corrections'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 32,
                color: iconColor,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    final activities = [
      {
        'icon': Icons.description_outlined,
        'title': 'Course Uploaded',
        'subtitle': 'Advanced Calculus II Notes',
        'time': '2 days ago',
        'color': Color(0xFFFF4444),
      },
      {
        'icon': Icons.edit_outlined,
        'title': 'Correction Suggested',
        'subtitle': 'Introduction to Philosophy Quiz',
        'time': '1 day ago',
        'color': Color(0xFFFF4444),
      },
      {
        'icon': Icons.person_add_outlined,
        'title': 'New Friend',
        'subtitle': 'Dr. Sarah Chen connected with you',
        'time': '3 hours ago',
        'color': Color(0xFFFF4444),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: activities
                .asMap()
                .entries
                .map((entry) => _buildActivityItem(
                      entry.value,
                      isLast: entry.key == activities.length - 1,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity, {bool isLast = false}) {
    return InkWell(
      onTap: () {}, // Handle view action
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: isLast ? null : Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (activity['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                activity['icon'] as IconData,
                color: activity['color'] as Color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity['title'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activity['subtitle'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activity['time'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFFF4444)),
                borderRadius: BorderRadius.circular(16),
              ),
              
              child: const Text(
                'View',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFFF4444),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageOverviewSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Platform Usage Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Monthly Activity Trends',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 60,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                          if (value.toInt() >= 0 && value.toInt() < months.length) {
                            return Text(
                              months[value.toInt()],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            );
                          }
                          return const Text('');
                        },
                        reservedSize: 30,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    // Evaluations Generated line
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 120),
                        FlSpot(1, 140),
                        FlSpot(2, 135),
                        FlSpot(3, 160),
                        FlSpot(4, 180),
                        FlSpot(5, 200),
                      ],
                      isCurved: true,
                      color: Color(0xFFFF4444),
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Color(0xFFFF4444).withOpacity(0.2),
                      ),
                    ),
                    
                    // Courses Uploaded line
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 80),
                        FlSpot(1, 90),
                        FlSpot(2, 85),
                        FlSpot(3, 100),
                        FlSpot(4, 120),
                        FlSpot(5, 140),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                  ],
                  minY: 0,
                  maxY: 240,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Color(0xFFFF4444), 'Evaluations Generated'),
                const SizedBox(width: 20),
                _buildLegendItem(Colors.blue, 'Courses Uploaded'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}