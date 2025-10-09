class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final DateTime createdAt;
  bool read;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.createdAt,
    this.read = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> j) => MessageModel(
        id: j['_id'] as String,
        conversationId: j['conversationId'] as String,
        senderId: j['senderId'] as String,
        text: j['text'] as String,
        createdAt: DateTime.parse(j['createdAt'] as String),
        read: j['read'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'conversationId': conversationId,
        'senderId': senderId,
        'text': text,
      };
}