import '../constants/app_constants.dart';
import 'api_service.dart';

class AuthService {
  final _api = ApiService(baseUrl: AppConstants.apiBaseUrl);

  Future<Map<String, dynamic>> login(String email, String password) async {
    // TODO: connect to Firebase Auth or your backend
    final res = await _api.post('/auth/login', {
      'email': email,
      'password': password,
    });
    return res;
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final res = await _api.post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
    });
    return res;
  }

  Future<void> logout() async {
    // TODO
  }
}
