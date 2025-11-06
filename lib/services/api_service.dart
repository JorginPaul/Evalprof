// Stubbed API client.
// Replace with http or dio and real endpoints later.
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:EvalProfs/constants/app_constants.dart';

class ApiService {
  final String baseUrl = AppConstants.apiBaseUrl;

  // Examples (replace with real HTTP later):
  Future<dynamic> getRequest(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode == 200) {
      //return jsonDecode(response.body);
      return _handleResponse(response);
    } else {
      throw Exception('Failed to load data');
    }
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw Exception('Bad request');
      case 404:
        throw Exception('Not found');
      default:
        throw Exception("Error: ${response.statusCode} - ${response.body}");
    }
  }

  Future<dynamic> postRequest(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      print('🔴 POST error ($endpoint): $e');
      rethrow;
    }
  }
}