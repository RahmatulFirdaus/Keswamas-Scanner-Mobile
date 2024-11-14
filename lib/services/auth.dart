import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = const FlutterSecureStorage();

  Future<String?> login(String username, String password) async {
    var url = Uri.parse('http://192.168.1.8:3000/api/login');
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'username': username, 'password': password}));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final token = json['data']['token'];
      final refreshToken = json['data']['refresh_token'];

      await storage.write(key: 'jwt_token', value: token);
      await storage.write(key: 'refresh_token', value: refreshToken);

      return null;
    } else {
      final json = jsonDecode(response.body);
      final pesan = json['pesan'];
      return pesan;
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
    await storage.delete(key: 'refresh_token');
  }
}

class RefreshToken {
  static const storage = FlutterSecureStorage();

  static Future<String> refreshJwtToken(String token) async {
    final refreshToken = await storage.read(key: 'refresh_token');

    if (refreshToken == null) {
      throw Exception('Refresh token not found');
    }

    var url = Uri.parse('http://192.168.1.8:3000/api/refreshToken');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      var newToken = json['data']['token'];
      var newRefreshToken = json['data']['refresh_token'];
      await storage.write(key: 'jwt_token', value: newToken);
      await storage.write(key: 'refresh_token', value: newRefreshToken);

      return "Berhasil";
    } else {
      final json = jsonDecode(response.body);
      return json['pesan'] ?? 'Failed to refresh token';
    }
  }
}
