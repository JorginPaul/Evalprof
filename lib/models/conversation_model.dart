import '../models/message_model.dart';
import '../models/user_model.dart';

class ConversationModel {
  final String id;
  final List<UserModel> participants;
  final MessageModel? lastMessage;

  ConversationModel({
    required this.id,
    required this.participants,
    this.lastMessage,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> j) {
    final parts = (j['participants'] as List<dynamic>? ?? [])
        .map((p) => UserModel.fromJson(p as Map<String, dynamic>))
        .toList();
    return ConversationModel(
      id: j['_id'] as String,
      participants: parts,
      lastMessage:
          j['lastMessage'] != null ? MessageModel.fromJson(j['lastMessage']) : null,
    );
  }
}
