class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final DateTime createdAt;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.createdAt,
    this.isRead = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> j) => MessageModel(
        id: j['_id'] as String,
        conversationId: j['conversationId'] as String,
        senderId: j['senderId'] as String,
        text: j['text'] as String,
        createdAt: DateTime.parse(j['createdAt'] as String),
        isRead: j['isRead'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'conversationId': conversationId,
        'senderId': senderId,
        'text': text,
      };
}