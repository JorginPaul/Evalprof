import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../constants/app_constants.dart';
import '../../models/user_model.dart';
import '../../models/message_model.dart';
import '../../services/chat_service.dart';
import '../../widgets/bottom_navbar.dart';
import '../../utils/helpers.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;
  final UserModel otherUser;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.otherUser,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final FocusNode _focusNode = FocusNode();
  late ChatService _chat;
  bool _showAttachmentMenu = false;
  bool _isTyping = false;
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _chat = Provider.of<ChatService>(context, listen: false);
    if (widget.conversationId.isNotEmpty) {
      _chat.joinConversation(widget.conversationId);
      _chat.fetchMessages(widget.conversationId);
    }

    // Listen to text changes to show typing indicator
    _ctrl.addListener(_onTextChanged);
    
    // Auto-scroll to bottom when new messages arrive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _onTextChanged() {
    final hasText = _ctrl.text.trim().isNotEmpty;
    if (hasText != _isTyping) {
      setState(() => _isTyping = hasText);
      // Optionally send typing indicator to other user
      // _chat.sendTypingIndicator(widget.conversationId, hasText);
    }
  }

  void _scrollToBottom() {
    if (_scroll.hasClients) {
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    
    final myId = 'CURRENT_USER_ID'; // Replace with actual current user id from auth
    final convId = widget.conversationId.isNotEmpty 
        ? widget.conversationId 
        : 'temp_${DateTime.now().millisecondsSinceEpoch}';
    
    _chat.sendMessage(
      conversationId: convId,
      text: text,
      senderId: myId,
    );
    
    _ctrl.clear();
    setState(() => _isTyping = false);
    
    // Scroll to bottom after sending
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _handleAttachment() {
    setState(() => _showAttachmentMenu = !_showAttachmentMenu);
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try{
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        // Handle image upload
        _sendMediaMessage(image.path, 'image');
      }
    }catch (e){
      debugPrint("Image pick error: $e");
    }
    setState(() => _showAttachmentMenu = false);
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    
    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        _sendMediaMessage(filePath, 'document');
      }
    }
    setState(() => _showAttachmentMenu = false);
  }

  void _sendMediaMessage(String path, String type) {
    final myId = 'CURRENT_USER_ID';
    final convId = widget.conversationId.isNotEmpty 
        ? widget.conversationId 
        : 'temp_${DateTime.now().millisecondsSinceEpoch}';
    
    // Upload file and send message with file URL
    // _chat.sendMediaMessage(conversationId: convId, filePath: path, type: type, senderId: myId);
    
    // For now, send a placeholder message
    _chat.sendMessage(
      conversationId: convId,
      text: '[$type uploaded]',
      senderId: myId,
    );
  }

  void _deleteMessage(MessageModel message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // _chat.deleteMessage(widget.conversationId, message.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _nav(int i) {
    setState(() => _selectedNavIndex = i);
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
        replace(context, '/friends');
        break;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatService>(
      builder: (context, chat, _) {
        final convId = widget.conversationId;
        final msgs = chat.messages[convId] ?? [];

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: _buildAppBar(),
          body: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Hide keyboard when tapping outside
                    FocusScope.of(context).unfocus();
                    setState(() => _showAttachmentMenu = false);
                  },
                  child: msgs.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: _scroll,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          itemCount: msgs.length,
                          itemBuilder: (context, i) {
                            final m = msgs[i];
                            final me = m.senderId == 'CURRENT_USER_ID';
                            final showAvatar = i == msgs.length - 1 ||
                                msgs[i + 1].senderId != m.senderId;
                            final showDateDivider = i == 0 ||
                                !_isSameDay(m.createdAt, msgs[i - 1].createdAt);

                            return Column(
                              children: [
                                if (showDateDivider) _buildDateDivider(m.createdAt),
                                _messageBubble(m, me, showAvatar),
                              ],
                            );
                          },
                        ),
                ),
              ),
              if (_showAttachmentMenu) _buildAttachmentMenu(),
              _inputBar(),
            ],
          ),
          bottomNavigationBar: BottomNavbar(
            currentIndex: _selectedNavIndex,
            onTap: _nav,
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: widget.otherUser.avatarUrl == null
                    ? Text(
                        widget.otherUser.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : null,
                foregroundImage: widget.otherUser.avatarUrl != null
                    ? NetworkImage(widget.otherUser.avatarUrl!)
                    : null,
              ),
              if (widget.otherUser.online)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.otherUser.name,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.otherUser.online ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: widget.otherUser.online ? Colors.green : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.videocam_outlined, color: Colors.black87),
          onPressed: () {
            // Implement video call
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Video call feature coming soon')),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.call_outlined, color: Colors.black87),
          onPressed: () {
            // Implement voice call
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Voice call feature coming soon')),
            );
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.black87),
          onSelected: (value) {
            switch (value) {
              case 'view_profile':
                // Navigate to user profile
                push(context, '/profile/${widget.otherUser.id}');
                break;
              case 'mute':
                // Mute conversation
                break;
              case 'clear':
                // Clear chat history
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view_profile',
              child: Row(
                children: [
                  Icon(Icons.person_outline, size: 20),
                  SizedBox(width: 12),
                  Text('View Profile'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'mute',
              child: Row(
                children: [
                  Icon(Icons.notifications_off_outlined, size: 20),
                  SizedBox(width: 12),
                  Text('Mute Notifications'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'clear',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 20, color: Colors.red),
                  SizedBox(width: 12),
                  Text('Clear Chat', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
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
            'Start a conversation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Send a message to ${widget.otherUser.name}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateDivider(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);
    
    String dateText;
    if (messageDate == today) {
      dateText = 'Today';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      dateText = 'Yesterday';
    } else {
      dateText = '${date.day}/${date.month}/${date.year}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey[300])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              dateText,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey[300])),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _messageBubble(MessageModel m, bool me, bool showAvatar) {
    final bg = me ? AppColors.primary : Colors.white;
    final align = me ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final textColor = me ? Colors.white : Colors.black87;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: me ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!me && showAvatar)
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: widget.otherUser.avatarUrl == null
                  ? Text(
                      widget.otherUser.name[0].toUpperCase(),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    )
                  : null,
              foregroundImage: widget.otherUser.avatarUrl != null
                  ? NetworkImage(widget.otherUser.avatarUrl!)
                  : null,
            )
          else if (!me)
            const SizedBox(width: 32),
          const SizedBox(width: 8),
          Flexible(
            child: GestureDetector(
              onLongPress: me ? () => _showMessageOptions(m) : null,
              child: Column(
                crossAxisAlignment: align,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      m.text,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${m.createdAt.hour.toString().padLeft(2, '0')}:${m.createdAt.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                      if (me) ...[
                        const SizedBox(width: 4),
                        Icon(
                          m.isRead ? Icons.done_all : Icons.done,
                          size: 14,
                          color: m.isRead ? Colors.blue : Colors.grey[500],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (me && showAvatar)
            const SizedBox(width: 32)
          else if (me)
            const SizedBox(width: 32),
        ],
      ),
    );
  }

  void _showMessageOptions(MessageModel message) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy'),
              onTap: () {
                // Copy message text to clipboard
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteMessage(message);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentMenu() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _attachmentOption(
            icon: Icons.photo_library,
            label: 'Gallery',
            color: Colors.purple,
            onTap: _pickImage,
          ),
          _attachmentOption(
            icon: Icons.insert_drive_file,
            label: 'Document',
            color: Colors.blue,
            onTap: _pickDocument,
          ),
          _attachmentOption(
            icon: Icons.location_on,
            label: 'Location',
            color: Colors.green,
            onTap: () {
              setState(() => _showAttachmentMenu = false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Location sharing coming soon')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _attachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                _showAttachmentMenu ? Icons.close : Icons.add,
                color: AppColors.primary,
              ),
              onPressed: _handleAttachment,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _ctrl,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  minLines: 1,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: _isTyping ? AppColors.primary : Colors.grey[300],
              shape: const CircleBorder(),
              child: InkWell(
                onTap: _isTyping ? _send : null,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  child: Icon(
                    _isTyping ? Icons.send : Icons.mic,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}