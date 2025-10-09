// services/friend_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'package:EvalProfs/constants/app_constants.dart';

class FriendService {
  static Future<List<UserModel>> fetchFriends() async {
    try {
      final res = await http.get(Uri.parse('${AppConstants.apiBaseUrl}/friends'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => UserModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load friends');
      }
    } catch (e) {
      print('❌ Error: $e');
      return [];
    }
  }
}
