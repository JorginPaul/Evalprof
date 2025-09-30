import 'package:Evalprof/screen/notifications/notification_screen.dart';
import 'package:Evalprof/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import '../../utils/helpers.dart';
import '../../widgets/bottom_navbar.dart';
import 'package:Evalprof/screen/friends/friend_search_screen.dart'; // Add this import

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  int idx = 4; // Friends tab index
  static const Color primaryColor = Color(0xFFFF4444);
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
        replace(context, '/corrections');
        break;
      case 4:
        // Already on friends screen
        break;
    }
  }

  // Mock data for connections
  final List<Map<String, dynamic>> connections = [
    {
      'id': '1',
      'name': 'Dr. Alistair Finch',
      'institution': 'University of Lumina',
      'subject': 'Quantum Physics',
      'position': 'Professor',
      'description': 'Specializing in quantum entanglement and its applications in cryptography.',
      'initials': 'DA',
      'bgColor': Colors.cyan,
      'isOnline': true,
    },
    {
      'id': '2',
      'name': 'Prof. Clara Bellwether',
      'institution': 'Techno University',
      'subject': 'AI Ethics',
      'position': 'Associate Professor',
      'description': 'Dedicated to the ethical implications of AI development and responsible',
      'initials': 'PC',
      'bgColor': Colors.cyan,
      'isOnline': false,
    },
  ];

  // Mock data for suggested lecturers
  final List<Map<String, dynamic>> suggestedLecturers = [
    {
      'id': '3',
      'name': 'Dr. Eleanor Vance',
      'institution': 'Heritage College',
      'subject': 'Classical Literature',
      'position': 'Lecturer',
      'initials': 'DE',
      'bgColor': primaryColor,
      'isConnected': false,
    },
    {
      'id': '4',
      'name': 'Prof. Marcus Chen',
      'institution': 'Global Institute',
      'subject': 'Data Science',
      'position': 'Professor',
      'initials': 'PM',
      'bgColor': Colors.black87,
      'isConnected': false,
    },
    {
      'id': '5',
      'name': 'Ms. Sofia Vargas',
      'institution': 'City Polytechnic',
      'subject': 'Software Engineering',
      'position': 'Assistant Lecturer',
      'initials': 'MS',
      'bgColor': Colors.grey,
      'isConnected': false,
    },
    {
      'id': '6',
      'name': 'Dr. Ben Carter',
      'institution': 'Summit University',
      'subject': 'Biotechnology',
      'position': 'Senior Lecturer',
      'initials': 'DB',
      'bgColor': Colors.grey,
      'isConnected': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxContentWidth = (screenWidth > 900) ? 900.0 : screenWidth;
    final horizontalPadding = (screenWidth - maxContentWidth) / 2;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Friends',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFFFF4444)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen())
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
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
                _buildSearchBar(),
                const SizedBox(height: 24),
                _buildYourConnectionsSection(),
                const SizedBox(height: 32),
                _buildSuggestedLecturersSection(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavbar(currentIndex: idx, onTap: _nav),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FriendSearchScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey[500]),
              const SizedBox(width: 12),
              Text(
                'Search lecturers...',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYourConnectionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your Connections',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () {
                // Handle see all
              },
              child: Text(
                'See All',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...connections.map((connection) => _buildConnectionCard(connection)),
      ],
    );
  }

  Widget _buildConnectionCard(Map<String, dynamic> connection) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: connection['bgColor'],
                      child: Text(
                        connection['initials'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (connection['isOnline'] == true)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        connection['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        connection['institution'],
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.cyan.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    connection['subject'],
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  connection['position'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              connection['description'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Handle message
                },
                icon: const Icon(Icons.message_outlined, size: 18),
                label: const Text('Message'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
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
    );
  }

  Widget _buildSuggestedLecturersSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxContentWidth = (screenWidth > 800) ? 800.0 : screenWidth;
    final crossAxisCount = maxContentWidth > 600 ? 4 : 2;
    final titleFontSize = (maxContentWidth * 0.032).clamp(18.0, 22.0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Suggested Lecturers',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            IconButton(
              onPressed: () {
                // Handle refresh suggestions
              },
              icon: const Icon(Icons.refresh, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          clipBehavior: Clip.none,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 20,
            mainAxisExtent: 190, // Fixed height for consistency
          ),
          itemCount: suggestedLecturers.length,
          itemBuilder: (context, index) {
            return _buildSuggestedLecturerCard(suggestedLecturers[index], maxContentWidth);
          },
        ),
      ],
    );
  }

  Widget _buildSuggestedLecturerCard(Map<String, dynamic> lecturer, double maxContentWidth) {
    final avatarRadius = (maxContentWidth * 0.04).clamp(22.0, 30.0);
    final nameFontSize = (maxContentWidth * 0.022).clamp(11.0, 14.0);
    final institutionFontSize = (maxContentWidth * 0.018).clamp(9.0, 12.0);
    final subjectFontSize = (maxContentWidth * 0.016).clamp(8.0, 10.0);
    final positionFontSize = (maxContentWidth * 0.016).clamp(8.0, 10.0);
    final buttonFontSize = (maxContentWidth * 0.018).clamp(9.0, 11.0);
    final cardPadding = (maxContentWidth * 0.02).clamp(10.0, 14.0);
    
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: Container(
        height: 190,
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Avatar section
            Column(
              children: [
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: lecturer['bgColor'],
                  child: Text(
                    lecturer['initials'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: avatarRadius * 0.6,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
            
            // Info section
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    lecturer['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: nameFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lecturer['institution'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: institutionFontSize,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.cyan.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      lecturer['subject'],
                      style: TextStyle(
                        color: Colors.cyan,
                        fontSize: subjectFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lecturer['position'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: positionFontSize,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Button section
            Container(
              width: double.infinity,
              height: 28,
              child: ElevatedButton(
                onPressed: () {
                  _addFriend(lecturer);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  side: BorderSide(color: Colors.grey[300]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  'Add Friend',
                  style: TextStyle(
                    fontSize: buttonFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addFriend(Map<String, dynamic> lecturer) {
    // Show confirmation dialog or handle add friend logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Friend'),
        content: Text('Send friend request to ${lecturer['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Friend request sent to ${lecturer['name']}'),
                  backgroundColor: primaryColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }
}