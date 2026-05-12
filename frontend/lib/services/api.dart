import 'dart:convert';
import 'package:http/http.dart' as http;

const _baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:5000');

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}

class ApiService {
  final String baseUrl;

  ApiService({String? baseUrl}) : baseUrl = baseUrl ?? _baseUrl;

  Future<Map<String, dynamic>> register(
      {required String email,
      required String username,
      required String password}) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'username': username,
        'password': password,
      }),
    );

    if (resp.statusCode != 201) {
      throw ApiException(jsonDecode(resp.body)['message'] ?? 'Register failed');
    }

    return jsonDecode(resp.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> login(
      {required String email, required String password}) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (resp.statusCode != 200) {
      throw ApiException(jsonDecode(resp.body)['message'] ?? 'Login failed');
    }

    return jsonDecode(resp.body) as Map<String, dynamic>;
  }

  Future<List<dynamic>> fetchListings({String? authToken}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    final resp = await http.get(Uri.parse('$baseUrl/listings'), headers: headers);

    if (resp.statusCode != 200) {
      throw ApiException('Failed to load listings');
    }

    return jsonDecode(resp.body) as List<dynamic>;
  }

  Future<Map<String, dynamic>> createListing({
    required String authToken,
    required String title,
    required String description,
    required double price,
    required String condition,
    required String sellerCountry,
    required bool shipsWorldwide,
    required List<String> tagNames,
    List<String>? shippingRegions,
  }) async {
    final resp = await http.post(Uri.parse('$baseUrl/listings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'price': price,
          'condition': condition,
          'sellerCountry': sellerCountry,
          'shipsWorldwide': shipsWorldwide,
          'tagNames': tagNames,
          'shippingRegions': shippingRegions ?? [],
        }));

    if (resp.statusCode != 201) {
      throw ApiException(jsonDecode(resp.body)['message'] ?? 'Create listing failed');
    }

    return jsonDecode(resp.body) as Map<String, dynamic>;
  }
}
