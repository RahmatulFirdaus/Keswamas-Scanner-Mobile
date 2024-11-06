import 'dart:convert';
import 'package:http/http.dart' as http;

class DroppingPasien {
  String id;
  String tema_kegiatan;
  String file;
  String tanggal_kegiatan;
  String tanggal_pembuatan;

  DroppingPasien(
      {required this.id,
      required this.tema_kegiatan,
      required this.file,
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
        file: e['file'],
        tanggal_kegiatan: e['tanggal_kegiatan'],
        tanggal_pembuatan: e['tanggal_pembuatan'],
      );
    }).toList();
  }
}

class DroppingPasienDetail {
  String id;
  String tema_kegiatan;
  String file;
  String tanggal_kegiatan;
  String tanggal_pembuatan;

  DroppingPasienDetail(
      {required this.id,
      required this.tema_kegiatan,
      required this.file,
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
      file: user['file'],
      tanggal_kegiatan: user['tanggal_kegiatan'],
      tanggal_pembuatan: user['tanggal_pembuatan'],
    );
  }
}

class GetFile {
  String file;

  GetFile({required this.file});

  static Future<GetFile> getFile(String id) async {
    var url = Uri.parse('http://10.0.10.58:3000/api/getFileLink/$id');
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    var file = json['data']['file']; // Access the 'file' directly within 'data'
    return GetFile(file: file);
  }
}
