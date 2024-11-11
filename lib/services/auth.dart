import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = FlutterSecureStorage();

  Future<String?> login(String username, String password) async {
    var url = Uri.parse('http://10.0.10.58:3000/api/login');
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final token = json['data']['token'];
      final refreshToken = json['data']['refreshToken'];

      await storage.write(key: 'jwt_token', value: token);
      await storage.write(key: 'refresh_token', value: refreshToken);

      return null;
    } else {
      final json = jsonDecode(response.body);
      final pesan = json['pesan'];
      print(pesan);
      return pesan;
    }
  }

  Future<void> refreshJwtToken() async {
    final refreshToken = await storage.read(key: 'refresh_token');

    if (refreshToken == null) {
      throw Exception('Refresh token not found');
    }

    var url = Uri.parse('http://10.0.10.58:3000/api/refreshToken');
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newToken = data['token'];

      await storage.write(key: 'jwt_token', value: newToken);
    } else {
      throw Exception('Terjadi Kesalahan');
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
    await storage.delete(key: 'refresh_token');
  }
}