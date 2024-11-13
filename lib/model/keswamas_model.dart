import 'dart:convert';
import 'package:http/http.dart' as http;

class DroppingPasien {
  String id;
  String tema_kegiatan;
  String tanggal_kegiatan;
  String tanggal_pembuatan;

  DroppingPasien(
      {required this.id,
      required this.tema_kegiatan,
      required this.tanggal_kegiatan,
      required this.tanggal_pembuatan});

  static Future<List<DroppingPasien>> getDroppingPasien() async {
    var url = Uri.parse('http://10.0.10.58:3000/api/getDropping');
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    var dataList = json['data'] as List;
    return dataList.map((e) {
      return DroppingPasien(
        id: e['id'].toString(),
        tema_kegiatan: e['tema_kegiatan'],
        tanggal_kegiatan: e['tanggal_kegiatan'],
        tanggal_pembuatan: e['tanggal_pembuatan'],
      );
    }).toList();
  }
}

class DroppingPasienDetail {
  String id;
  String tema_kegiatan;
  String gambar;
  String tanggal_kegiatan;
  String tanggal_pembuatan;

  DroppingPasienDetail(
      {required this.id,
      required this.tema_kegiatan,
      required this.gambar,
      required this.tanggal_kegiatan,
      required this.tanggal_pembuatan});

  static Future<DroppingPasienDetail> getDroppingPasienDetail(String id) async {
    var url = Uri.parse('http://10.0.10.58:3000/api/getDroppingDetail/$id');
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    var user = json['data'][0];
    return DroppingPasienDetail(
      id: user['id'].toString(),
      tema_kegiatan: user['tema_kegiatan'],
      gambar: user['gambar'],
      tanggal_kegiatan: user['tanggal_kegiatan'],
      tanggal_pembuatan: user['tanggal_pembuatan'],
    );
  }
}

class GetFile {
  String gambar;

  GetFile({required this.gambar});

  static Future<GetFile> getFile(String id) async {
    var url = Uri.parse('http://10.0.10.58:3000/api/getFileLink/$id');
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    var file = json['data']['file']; // Access the 'file' directly within 'data'
    return GetFile(gambar: file);
  }
}

class GetFileEach {
  String id, id_dropping, gambar;

  GetFileEach(
      {required this.id, required this.id_dropping, required this.gambar});

  static Future<List<GetFileEach>> getFileEach(String id) async {
    var url = Uri.parse('http://10.0.10.58:3000/api/getFileEach/$id');
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    var dataList = json['data'] as List;
    return dataList.map((e) {
      return GetFileEach(
        id: e['id'].toString(),
        id_dropping: e['id_dropping'].toString(),
        gambar: e['gambar'],
      );
    }).toList();
  }
}

class RegisterUser {
  Future<String?> register(String username, String password,
      String confirmPassword, String email) async {
    var url = Uri.parse('http://10.0.10.58:3000/api/registerUser');
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
