import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = const FlutterSecureStorage();

  Future<String?> login(String username, String password) async {
    var url = Uri.parse('http://192.168.3.9:5000/api/login');
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
