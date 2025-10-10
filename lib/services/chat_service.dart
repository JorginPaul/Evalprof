import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../constants/app_constants.dart';

class ChatService with ChangeNotifier {
  final String token;
  IO.Socket? _socket;
  bool connected = false;

  // In-memory caches
  List<ConversationModel> conversations = [];
  final Map<String, List<MessageModel>> messages = {}; // conversationId -> messages

  ChatService({required this.token});

  String get _base => AppConstants.apiBaseUrl;

  // Initialize and connect socket
  void connect() {
    if (_socket != null && connected) return;
    _socket = IO.io(
      AppConstants.socketUrl,
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .setExtraHeaders({'Authorization': 'Bearer $token'})
        .build(),
    );

    _socket!.on('connect', (_) {
      connected = true;
      notifyListeners();
      debugPrint('Socket connected: ${_socket!.id}');
    });

    _socket!.on('disconnect', (_) {
      connected = false;
      notifyListeners();
      debugPrint('Socket disconnected');
    });

    _socket!.on('message', (data) {
      // data should be message JSON
      try {
        final m = MessageModel.fromJson(Map<String, dynamic>.from(data));
        final convId = m.conversationId;
        messages.putIfAbsent(convId, () => []);
        messages[convId]!.add(m); // newest first
        notifyListeners();
      } catch (e) {
        debugPrint('message decode error: $e');
      }
    });

    _socket!.on('presence', (data) {
      // optional: update user presence
    });

    _socket!.connect();
  }

  // Join a conversation room (so server emits messages to that room)
  void joinConversation(String conversationId) {
    _socket?.emit('join', {'conversationId': conversationId});
  }

  void leaveConversation(String conversationId) {
    _socket?.emit('leave', {'conversationId': conversationId});
  }

  // Fetch conversations via REST
  Future<void> fetchConversations() async {
    try{
      final res = await http.get(
        Uri.parse('$_base/api/conversations'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
          final list = jsonDecode(res.body) as List<dynamic>;
        conversations =
            list.map((c) => ConversationModel.fromJson(c as Map<String, dynamic>)).toList();
        notifyListeners();
      } else {
        debugPrint('fetchConversations failed ${res.statusCode}');
      }
    }catch (e) {
      debugPrint('fetchConversations error: $e');
    }
  }

  // Fetch messages for a conversation (server returns paginated newest last)
  Future<void> fetchMessages(String conversationId) async {
    try{
      final res = await http.get(
        Uri.parse('$_base/api/conversations/$conversationId/messages'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List<dynamic>;
        messages[conversationId] = list
            .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
            .toList()
            .reversed
            .toList(); // we want newest last in UI
        notifyListeners();
      } else {
        debugPrint('fetchMessages failed ${res.statusCode}');
      }
    }catch (e) {
      debugPrint('fetchMessages error: $e');
    }
  }

  // Create conversation or return existing (participants: [otherUserId])
  Future<ConversationModel?> createConversationWith(String otherUserId) async {
    try{
      final res = await http.post(
        Uri.parse('$_base/api/conversations'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'participantId': otherUserId}),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final conv = ConversationModel.fromJson(jsonDecode(res.body));
        // add/replace local list
        conversations.removeWhere((c) => c.id == conv.id);
        conversations.insert(0, conv);
        notifyListeners();
        return conv;
      }
    }catch (e) {
      debugPrint('createConversationWith error: $e');
    }
    return null;
  }

  // Send message: emits socket + persist via REST
  Future<void> sendMessage({
    required String conversationId,
    required String text,
    required String senderId,
  }) async {
    final payload = {
      'conversationId': conversationId,
      'text': text,
      'senderId': senderId,
    };

    final optimistic = MessageModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      conversationId: conversationId,
      senderId: senderId,
      text: text,
      createdAt: DateTime.now(),
      isRead: false,
    );

    messages.putIfAbsent(conversationId, () => []);
    messages[conversationId]!.add(optimistic);
    notifyListeners();

    _socket?.emit('send_message', payload);

    try {
      final res = await http.post(
        Uri.parse('$_base/api/messages'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(payload),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final saved = MessageModel.fromJson(jsonDecode(res.body));
        final list = messages[conversationId]!;
        final idx = list.indexWhere((m) => m.id == optimistic.id);
        if (idx >= 0) list[idx] = saved;
        notifyListeners();
      } else {
        debugPrint('persist message failed: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('sendMessage error: $e');
    }
  }

  void disposeService() {
    // Fully reset state on Logout
    _socket?.disconnect();
    _socket = null;
    connected = false;
    messages.clear();
    conversations.clear();
  }
}
