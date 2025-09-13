// Stubbed API client.
// Replace with http or dio and real endpoints later.

class ApiService {
  final String baseUrl;
  ApiService({required this.baseUrl});

  // Examples (replace with real HTTP later):
  Future<Map<String, dynamic>> get(String path) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {'ok': true, 'path': path};
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return {'ok': true, 'path': path, 'body': body};
  }
}
