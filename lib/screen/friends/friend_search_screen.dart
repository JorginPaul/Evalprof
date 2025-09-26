import 'package:flutter/material.dart';
import '../../utils/helpers.dart';

class FriendSearchScreen extends StatefulWidget {
  const FriendSearchScreen({super.key});

  @override
  State<FriendSearchScreen> createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends State<FriendSearchScreen> {
  static const Color primaryColor = Color(0xFFFF4444);
  final TextEditingController _searchController = TextEditingController();
  String query = '';
  bool isLoading = false;
  String selectedFilter = 'All';
  
  // Enhanced mock data with more realistic lecturer information
  final List<Map<String, dynamic>> allLecturers = [
    {
      'id': 'u1',
      'name': 'Dr. Amara Okafor',
      'institution': 'University of Lagos (UNILAG)',
      'subject': 'Computer Science',
      'position': 'Senior Lecturer',
      'location': 'Lagos, Nigeria',
      'initials': 'AO',
      'bgColor': Colors.blue,
      'isOnline': true,
      'mutualConnections': 12,
      'bio': 'Specializing in Machine Learning and Data Science research.',
    },
    {
      'id': 'u2',
      'name': 'Prof. Chioma Adebayo',
      'institution': 'University of Ibadan (UI)',
      'subject': 'Mathematics',
      'position': 'Professor',
      'location': 'Ibadan, Nigeria',
      'initials': 'CA',
      'bgColor': Colors.green,
      'isOnline': false,
      'mutualConnections': 8,
      'bio': 'Expert in Applied Mathematics and Statistical Analysis.',
    },
    {
      'id': 'u3',
      'name': 'Dr. Emeka Nwosu',
      'institution': 'University of Benin (UNIBEN)',
      'subject': 'Physics',
      'position': 'Associate Professor',
      'location': 'Benin City, Nigeria',
      'initials': 'EN',
      'bgColor': Colors.purple,
      'isOnline': true,
      'mutualConnections': 5,
      'bio': 'Research focus on Quantum Physics and Material Science.',
    },
    {
      'id': 'u4',
      'name': 'Dr. Fatima Hassan',
      'institution': 'Ahmadu Bello University (ABU)',
      'subject': 'Chemistry',
      'position': 'Lecturer',
      'location': 'Zaria, Nigeria',
      'initials': 'FH',
      'bgColor': Colors.orange,
      'isOnline': true,
      'mutualConnections': 3,
      'bio': 'Organic Chemistry researcher with focus on pharmaceutical compounds.',
    },
    {
      'id': 'u5',
      'name': 'Prof. James Okoro',
      'institution': 'University of Nigeria, Nsukka (UNN)',
      'subject': 'Engineering',
      'position': 'Professor',
      'location': 'Nsukka, Nigeria',
      'initials': 'JO',
      'bgColor': Colors.teal,
      'isOnline': false,
      'mutualConnections': 15,
      'bio': 'Mechanical Engineering with expertise in renewable energy systems.',
    },
    {
      'id': 'u6',
      'name': 'Dr. Kemi Adeoye',
      'institution': 'Lagos State University (LASU)',
      'subject': 'Biology',
      'position': 'Senior Lecturer',
      'location': 'Lagos, Nigeria',
      'initials': 'KA',
      'bgColor': Colors.indigo,
      'isOnline': true,
      'mutualConnections': 7,
      'bio': 'Molecular Biology and Genetics research specialist.',
    },
  ];

  final List<String> filters = ['All', 'Professors', 'Senior Lecturers', 'Lecturers', 'Online'];

  List<Map<String, dynamic>> get filteredResults {
    var results = allLecturers.where((lecturer) {
      final matchesQuery = lecturer['name']!.toLowerCase().contains(query.toLowerCase()) ||
          lecturer['institution']!.toLowerCase().contains(query.toLowerCase()) ||
          lecturer['subject']!.toLowerCase().contains(query.toLowerCase()) ||
          lecturer['location']!.toLowerCase().contains(query.toLowerCase());
      
      if (!matchesQuery) return false;
      
      switch (selectedFilter) {
        case 'Professors':
          return lecturer['position']!.toLowerCase().contains('professor');
        case 'Senior Lecturers':
          return lecturer['position']!.toLowerCase().contains('senior lecturer');
        case 'Lecturers':
          return lecturer['position']!.toLowerCase() == 'lecturer';
        case 'Online':
          return lecturer['isOnline'] == true;
        default:
          return true;
      }
    }).toList();
    
    // Sort by online status first, then by mutual connections
    results.sort((a, b) {
      if (a['isOnline'] != b['isOnline']) {
        return b['isOnline'] ? 1 : -1;
      }
      return b['mutualConnections'].compareTo(a['mutualConnections']);
    });
    
    return results;
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        query = _searchController.text;
      });
    });
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
        title: const Text(
          'Find Lecturers',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Header Section
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding + 16,
              vertical: 16,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: Column(
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                    _buildFilterChips(),
                  ],
                ),
              ),
            ),
          ),
          
          // Results Section
          Expanded(
            child: SingleChildScrollView(
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
                      _buildResultsHeader(),
                      const SizedBox(height: 16),
                      if (isLoading)
                        _buildLoadingState()
                      else if (filteredResults.isEmpty && query.isNotEmpty)
                        _buildEmptyState()
                      else if (filteredResults.isEmpty)
                        _buildInitialState()
                      else
                        _buildResultsList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search by name, institution, subject, or location...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          suffixIcon: query.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[600]),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      query = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        onChanged: (value) {
          setState(() {
            query = value;
            isLoading = value.isNotEmpty;
          });
          
          // Simulate API delay
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
          });
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;
          
          return FilterChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                selectedFilter = filter;
              });
            },
            selectedColor: primaryColor.withOpacity(0.2),
            checkmarkColor: primaryColor,
            labelStyle: TextStyle(
              color: isSelected ? primaryColor : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            side: BorderSide(
              color: isSelected ? primaryColor : Colors.grey[300]!,
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsHeader() {
    if (query.isEmpty) return const SizedBox.shrink();
    
    return Text(
      '${filteredResults.length} result${filteredResults.length != 1 ? 's' : ''} found for "$query"',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          CircularProgressIndicator(color: primaryColor),
          const SizedBox(height: 16),
          Text(
            'Searching lecturers...',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No lecturers found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search terms or filters',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Discover New Lecturers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Search by name, institution, subject, or location to find and connect with fellow educators',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredResults.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildLecturerCard(filteredResults[index]);
      },
    );
  }

  Widget _buildLecturerCard(Map<String, dynamic> lecturer) {
    return Card(
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
                      backgroundColor: lecturer['bgColor'],
                      child: Text(
                        lecturer['initials'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (lecturer['isOnline'] == true)
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
                        lecturer['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lecturer['position'],
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lecturer['institution'],
                        style: TextStyle(
                          fontSize: 12,
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
                    lecturer['subject'],
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    lecturer['location'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              lecturer['bio'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                height: 1.3,
              ),
            ),
            if (lecturer['mutualConnections'] > 0) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.people_outline, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    '${lecturer['mutualConnections']} mutual connections',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewProfile(lecturer),
                    icon: const Icon(Icons.person_outline, size: 18),
                    label: const Text('View Profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _connectWithLecturer(lecturer),
                    icon: const Icon(Icons.person_add_outlined, size: 18),
                    label: const Text('Connect'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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

  void _viewProfile(Map<String, dynamic> lecturer) {
    // Navigate to lecturer profile
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildProfileBottomSheet(lecturer),
    );
  }

  Widget _buildProfileBottomSheet(Map<String, dynamic> lecturer) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: lecturer['bgColor'],
                  child: Text(
                    lecturer['initials'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  lecturer['name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lecturer['position'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lecturer['institution'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  lecturer['bio'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _connectWithLecturer(lecturer);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Send Connection Request',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _connectWithLecturer(Map<String, dynamic> lecturer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Connection Request'),
        content: Text('Send connection request to ${lecturer['name']}?'),
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
                  content: Text('Connection request sent to ${lecturer['name']}'),
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