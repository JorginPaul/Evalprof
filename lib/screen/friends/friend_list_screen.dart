import 'package:EvalProfs/services/friend_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/app_constants.dart';
import '../../models/user_model.dart';
import '../../services/chat_service.dart';
import '../chat/chat_screen.dart';
import '../../utils/helpers.dart';
import '../../widgets/bottom_navbar.dart';
import 'friend_search_screen.dart'; // keep your existing search screen

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<UserModel> _friends = [];
  bool _loading = true;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    setState(() => _loading = true);
    // call your backend to fetch friends (replace with real call)
    final data = await FriendService.fetchFriends();
    setState(() {
      _friends = data;
      _loading = false;
    });
  }

  List<UserModel> _filter(int tabIndex) {
    final s = _search.toLowerCase();
    final filtered = _friends.where((u) {
      final matches = u.name.toLowerCase().contains(s);
      return matches;
    }).toList();

    if (tabIndex == 1) {
      // Online
      return filtered.where((u) => u.online).toList();
    } else if (tabIndex == 2) {
      // Lecturers (example: assume name contains 'Dr.' or we have role)
      return filtered.where((u) => u.name.toLowerCase().contains('dr') || u.name.toLowerCase().contains('prof')).toList();
    }
    return filtered;
  }

  Future<void> _openChat(UserModel user) async {
    final chatService = Provider.of<ChatService>(context, listen: false);
    final conv = await chatService.createConversationWith(user.id);
    if (conv != null) {
      chatService.joinConversation(conv.id);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: chatService,
            child: ChatScreen(conversationId: conv.id, otherUser: user),
          ),
        ),
      );
    } else {
      // fallback: open chat screen by user id and let screen create conversation
      Navigator.pushNamed(
        context,
        '/chat',
        arguments: {
          'userId': user.id,
          'otherUser': user,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primary;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          TabBar(
            controller: _tabController,
            labelColor: primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primary,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Online'),
              Tab(text: 'Lecturers'),
            ],
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: List.generate(3, (i) => _buildList(_filter(i))),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: 4,
        onTap: (i) {
          const routes = [
            '/dashboard',
            '/library',
            '/evaluation-generator',
            '/corrections',
            '/friends'
            '/chat'
          ];
          replace(context, routes[i]);
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      title: const Text('Friends', style: TextStyle(color: Colors.black)),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFFFF4444)),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Color(0xFFFF4444)),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FriendSearchScreen())),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFFF4444),
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search friends...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        onChanged: (s) => setState(() => _search = s),
      ),
    );
  }

  Widget _buildList(List<UserModel> list) {
    if (list.isEmpty) {
      return Center(child: Text('No friends found', style: TextStyle(color: Colors.grey[600])));
    }
    return RefreshIndicator(
      onRefresh: _loadFriends,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) => _friendTile(list[i]),
      ),
    );
  }

  Widget _friendTile(UserModel user) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey[300],
              child: user.avatarUrl != null
                  ? CachedNetworkImage(imageUrl: user.avatarUrl!, imageBuilder: (ctx, img) => CircleAvatar(radius: 28, backgroundImage: img))
                  : Text(user.name.isNotEmpty ? user.name[0] : '?'),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: user.online ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        title: Text(user.name),
        subtitle: Text(user.online ? 'Online' : 'Offline'),
        trailing: IconButton(
          icon: const Icon(Icons.message, color: Color(0xFFFF4444)),
          onPressed: () => _openChat(user),
        ),
        onTap: () {
          // maybe show profile or open chat
          _openChat(user);
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}