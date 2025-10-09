import 'package:EvalProfs/screen/profile/profile_screen.dart';
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
        replace(context, '/chat');
        break;
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
                _buildWelcomeBanner(maxContentWidth),
                const SizedBox(height: 24),
                _buildQuickActionsSection(maxContentWidth),
                const SizedBox(height: 24),
                _buildRecentActivitySection(maxContentWidth),
                const SizedBox(height: 24),
                _buildUsageOverviewSection(maxContentWidth),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavbar(currentIndex: 0, onTap: _nav),
    );
  }

  // Welcome Banner
  Widget _buildWelcomeBanner(double maxWidth) {
    final bannerPadding = (maxWidth * 0.06).clamp(16.0, 32.0);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(bannerPadding),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            'Welcome Back,\nLecturer!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: (maxWidth * 0.04).clamp(20.0, 28.0),
              fontWeight: FontWeight.bold,
              color: primaryColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your personalized hub for academic \n excellence and collaboration.',
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontSize: (maxWidth * 0.022).clamp(12.0, 16.0),
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // Quick Actions
  Widget _buildQuickActionsSection(double maxWidth) {
    final crossAxisCount = maxWidth > 600 ? 4 : 2;
    final cardPadding = (maxWidth * 0.025).clamp(12.0, 20.0);

    final actions = [
      {
        'icon': Icons.upload_file_outlined,
        'title': 'Upload Course',
        'subtitle': 'Share materials effortlessly',
        'route': '/upload-course',
      },
      {
        'icon': Icons.auto_awesome_outlined,
        'title': 'Generate Evaluation',
        'subtitle': 'AI-powered assessments',
        'route': '/evaluation-generator',
      },
      {
        'icon': Icons.people_outline,
        'title': 'Connect with Peers',
        'subtitle': 'Expand academic network',
        'route': '/friends',
      },
      {
        'icon': Icons.edit_outlined,
        'title': 'Review Corrections',
        'subtitle': 'Refine shared content',
        'route': '/corrections',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: (maxWidth * 0.032).clamp(18.0, 20.0),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];
            return _buildActionCard(
              icon: action['icon'] as IconData,
              iconColor: primaryColor,
              title: action['title'] as String,
              subtitle: action['subtitle'] as String,
              onTap: () => push(context, action['route'] as String),
              padding: cardPadding,
              maxWidth: maxWidth,
            );
          },
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
    required double padding,
    required double maxWidth,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon,
                  size: (maxWidth * 0.05).clamp(28.0, 32.0), color: iconColor),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: (maxWidth * 0.022).clamp(12.0, 14.0),
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: (maxWidth * 0.018).clamp(10.0, 13.0),
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Recent Activity
  Widget _buildRecentActivitySection(double maxWidth) {
    final titleFontSize  = (maxWidth * 0.032).clamp(18.0, 22.0);
    final itemPadding = (maxWidth * 0.025).clamp(12.0, 20.0);
    final iconSize = (maxWidth * 0.032).clamp(18.0, 24.0);
    final titleSize = (maxWidth * 0.022).clamp(12.0, 16.0);
    final subtitleSize = (maxWidth * 0.018).clamp(11.0, 14.0);
    final timeSize = (maxWidth * 0.016).clamp(10.0, 12.0);
    final buttonSize = (maxWidth * 0.018).clamp(11.0, 13.0);

    final activities = [
      {
        'icon': Icons.description_outlined,
        'title': 'Course Uploaded',
        'subtitle': 'Advanced Calculus II Notes',
        'time': '2 days ago',
        'color': primaryColor,
      },
      {
        'icon': Icons.edit_outlined,
        'title': 'Correction Suggested',
        'subtitle': 'Introduction to Philosophy Quiz',
        'time': '1 day ago',
        'color': primaryColor,
      },
      {
        'icon': Icons.person_add_outlined,
        'title': 'New Friend',
        'subtitle': 'Dr. Sarah Chen connected with you',
        'time': '3 hours ago',
        'color': primaryColor,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: titleFontSize,
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
                      padding: itemPadding,
                      iconSize: iconSize,
                      titleSize: titleSize,
                      subtitleSize: subtitleSize,
                      timeSize: timeSize,
                      buttonSize: buttonSize,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

   Widget _buildActivityItem(
    Map<String, dynamic> activity, {
    bool isLast = false,
    required double padding,
    required double iconSize,
    required double titleSize,
    required double subtitleSize,
    required double timeSize,
    required double buttonSize,
    }) {
    return InkWell(
      /*
      onTap: () {
        if (activity['title'] == 'Course Uploaded') {
          push(context, '/course-list');
        } else if (activity['title'] == 'Correction Suggested') {
          push(context, '/corrections');
        } else if (activity['title'] == 'New Friend') {
          push(context, '/friends');
        }
      }, // Handle view action
      */
      child: Container(
        constraints: const BoxConstraints(minHeight: 80, maxHeight: 120),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: isLast ? null : Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: (padding * 2.5).clamp(32.0, 48.0),
              height: (padding * 2.5).clamp(32.0, 48.0),
              decoration: BoxDecoration(
                color: (activity['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                activity['icon'] as IconData,
                color: activity['color'] as Color,
                size: iconSize,
              ),
            ),
            SizedBox(width: padding * 0.80),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    activity['title'] as String,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: padding * 0.10),
                  Text(
                    activity['subtitle'] as String,
                    style: TextStyle(
                      fontSize: subtitleSize,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    activity['time'] as String,
                    style: TextStyle(
                      fontSize: timeSize,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: padding * 0.20, vertical: padding * 0.005),
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor),
                borderRadius: BorderRadius.circular(16),
              ),
              
              child: TextButton(
                onPressed: () {
                  if (activity['title'] == 'Course Uploaded') {
                    push(context, '/course-list');
                  } else if (activity['title'] == 'Correction Suggested') {
                    push(context, '/corrections');
                  } else if (activity['title'] == 'New Friend') {
                    push(context, '/friends');
                  }
                },
                child: Text(
                  'View',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // Platform Usage Overview
  Widget _buildUsageOverviewSection(double maxWidth) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'
  ];

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: EdgeInsets.all((maxWidth * 0.025).clamp(12.0, 20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Platform Usage Overview',
            style: TextStyle(
              fontSize: (maxWidth * 0.032).clamp(18.0, 22.0),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: (maxWidth * 0.35).clamp(180.0, 250.0),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(   // remove y-axis labels
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: 60),
                  ),
                  rightTitles: const AxisTitles(  // remove right labels
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(    // remove top labels
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1, // spacing for each tick
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Text(
                            months[value.toInt()],
                            style: const TextStyle(color: Colors.grey, fontSize: 11),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                
                borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey[500]!)),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(1, 140),
                      FlSpot(2, 135),
                      FlSpot(3, 160),
                      FlSpot(4, 180),
                      FlSpot(5, 200),
                      FlSpot(6, 190),
                      FlSpot(7, 210),
                      FlSpot(8, 230),
                      FlSpot(9, 240),
                      FlSpot(10, 250),
                      FlSpot(11, 260),
                    ],
                    isCurved: true,
                    color: primaryColor,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: primaryColor.withOpacity(0.2),
                    ),
                  ),
                  LineChartBarData(
                    spots: const [
                      FlSpot(1, 90),
                      FlSpot(2, 85),
                      FlSpot(3, 100),
                      FlSpot(4, 120),
                      FlSpot(5, 140),
                      FlSpot(6, 135),
                      FlSpot(7, 150),
                      FlSpot(8, 170),
                      FlSpot(9, 180),
                      FlSpot(10, 200),
                      FlSpot(11, 220),
                    ],
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(primaryColor, 'Evaluations Generated'),
              const SizedBox(width: 16),
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
      children: [
        Container(width: 12, height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}