import 'dart:convert';
import 'package:http/http.dart' as http;

class DroppingPasien {
  String id;
  String temaKegiatan;
  String tanggalKegiatan;
  String tanggalPembuatan;

  DroppingPasien(
      {required this.id,
      required this.temaKegiatan,
      required this.tanggalKegiatan,
      required this.tanggalPembuatan});

  static Future<List<DroppingPasien>> getDroppingPasien(String token) async {
    var url = Uri.parse('http:/10.0.10.58:3000/api/getDropping');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var dataList = json['data'] != null ? json['data'] as List : [];
      return dataList.map((e) {
        return DroppingPasien(
          id: e['id'].toString(),
          temaKegiatan: e['tema_kegiatan'],
          tanggalKegiatan: e['tanggal_kegiatan'],
          tanggalPembuatan: e['tanggal_pembuatan'],
        );
      }).toList();
    } else {
      throw Exception("Forbidden");
    }
  }
}

class DroppingPasienDetail {
  String id;
  String temaKegiatan;
  String gambar;
  String tanggalKegiatan;
  String tanggalPembuatan;

  DroppingPasienDetail(
      {required this.id,
      required this.temaKegiatan,
      required this.gambar,
      required this.tanggalKegiatan,
      required this.tanggalPembuatan});

  static Future<DroppingPasienDetail> getDroppingPasienDetail(String id) async {
    var url = Uri.parse('http:/10.0.10.58:3000/api/getDroppingDetail/$id');
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    var user = json['data'][0];
    return DroppingPasienDetail(
      id: user['id'].toString(),
      temaKegiatan: user['tema_kegiatan'],
      gambar: user['gambar'],
      tanggalKegiatan: user['tanggal_kegiatan'],
      tanggalPembuatan: user['tanggal_pembuatan'],
    );
  }
}

class GetFile {
  String gambar;

  GetFile({required this.gambar});

  static Future<GetFile> getFile(String id) async {
    var url = Uri.parse('http:/10.0.10.58:3000/api/getFileLink/$id');
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    var file = json['data']['file'];
    return GetFile(gambar: file);
  }
}

class GetFileEach {
  String id, idDropping, gambar;

  GetFileEach(
      {required this.id, required this.idDropping, required this.gambar});

  static Future<List<GetFileEach>> getFileEach(String id) async {
    var url = Uri.parse('http:/10.0.10.58:3000/api/getFileEach/$id');
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    var dataList = json['data'] as List;
    return dataList.map((e) {
      return GetFileEach(
        id: e['id'].toString(),
        idDropping: e['id_dropping'].toString(),
        gambar: e['gambar'],
      );
    }).toList();
  }
}

class RegisterUser {
  Future<String?> register(String username, String password,
      String confirmPassword, String email) async {
    var url = Uri.parse('http:/10.0.10.58:3000/api/registerUser');
    var response = await http.post(url, body: {
      'username': username,
      'password': password,
      'confirmPassword': confirmPassword,
      'email': email
    });
    var json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return json['pesan'];
    } else {
      return json['pesan'];
    }
  }
}
