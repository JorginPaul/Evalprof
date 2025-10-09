class UserModel {
  final String id;
  final String name;
  final String email;
  final String? token;
  final String? avatarUrl;
  final bool online;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    this.avatarUrl,
    this.online = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
    id: j['_id'] ?? j['id'] ?? '',
    name: j['name'] ?? '',
    email: j['email'] ?? '',
    token: j['token'] ?? '',
    avatarUrl: j['avatarUrl'],
    online: j['online'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'token': token,
    'avatarUrl': avatarUrl,
    'online': online,
  };
}
