import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../models/user_model.dart';
import '../../models/message_model.dart';
import '../../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;
  final UserModel otherUser;

  const ChatScreen({super.key, required this.conversationId, required this.otherUser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scroll = ScrollController();
  late ChatService _chat;

  @override
  void initState() {
    super.initState();
    _chat = Provider.of<ChatService>(context, listen: false);
    if (widget.conversationId.isNotEmpty) {
      _chat.joinConversation(widget.conversationId);
      _chat.fetchMessages(widget.conversationId);
    }
  }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    final myId = 'CURRENT_USER_ID'; // replace with actual current user id from auth
    final convId = widget.conversationId.isNotEmpty ? widget.conversationId : 'temp';
    _chat.sendMessage(conversationId: convId, text: text, senderId: myId);
    _ctrl.clear();
    // scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scroll.hasClients) _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatService>(builder: (context, chat, _) {
      final convId = widget.conversationId;
      final msgs = chat.messages[convId] ?? [];

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                // Fallback: Show first letter of name if no avatar
                child: widget.otherUser.avatarUrl == null ? Text(widget.otherUser.name[0]) : null,
                // Show actual avatar image if URL exists
                foregroundImage: widget.otherUser.avatarUrl != null ? NetworkImage(widget.otherUser.avatarUrl!) : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.otherUser.name, style: const TextStyle(color: Colors.black)),
                  Text(widget.otherUser.online ? 'Online' : 'Offline', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                itemCount: msgs.length,
                itemBuilder: (context, i) {
                  final m = msgs[i];
                  final me = m.senderId == 'CURRENT_USER_ID'; // replace accordingly
                  return _messageBubble(m, me);
                },
              ),
            ),
            _inputBar(),
          ],
        ),
      );
    });
  }

  Widget _messageBubble(MessageModel m, bool me) {
    final bg = me ? AppColors.primary : Colors.grey[200];
    final align = me ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final textColor = me ? Colors.white : Colors.black87;

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 8, left: me ? 60 : 0, right: me ? 0 : 60),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(m.text, style: TextStyle(color: textColor)),
        ),
        Text(
          '${m.createdAt.hour}:${m.createdAt.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _inputBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                decoration: InputDecoration(
                  hintText: 'Write a message...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                minLines: 1,
                maxLines: 5,
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppColors.primary,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _send,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
