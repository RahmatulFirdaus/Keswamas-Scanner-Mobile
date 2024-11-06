import 'dart:convert'; // Add this import for JSON encoding
import 'dart:ui';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class TambahDataDroppingPasien extends StatefulWidget {
  const TambahDataDroppingPasien({super.key});

  @override
  State<TambahDataDroppingPasien> createState() =>
      _TambahDataDroppingPasienState();
}

class _TambahDataDroppingPasienState extends State<TambahDataDroppingPasien> {
  List<String> _pictures = [];
  List<File> _files = []; // Declare _files to store File objects
  final tanggalController = TextEditingController();
  final temaController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  void clearForm() {
    temaController.clear();
    tanggalController.clear();
    setState(() {
      _files = [];
      _pictures = [];
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );

      if (pickedTime != null) {
        setState(() {
          selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          String formattedDateTime =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDate);
          tanggalController.text = formattedDateTime;
        });
      }
    }
  }

  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Tambah Data Dropping Pasien',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tema Kegiatan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: temaController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan tema kegiatan',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon:
                        const Icon(Icons.note_outlined, color: Colors.blue),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Dokumen",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    if (_pictures.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.document_scanner,
                              size: 48,
                              color: Colors.blue.shade300,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Belum ada dokumen yang dipilih",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Column(
                        children: _pictures.map((picture) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(picture),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: scanDocument,
                            icon: const Icon(Icons.document_scanner),
                            label: const Text("Scan Dokumen"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Tanggal Kegiatan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: tanggalController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Pilih tanggal dan waktu',
                    prefixIcon:
                        const Icon(Icons.calendar_today, color: Colors.blue),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onTap: () => _selectDateTime(context),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (tanggalController.text.isEmpty ||
              _files.isEmpty ||
              temaController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Harap Inputkan Semua Data'),
              ),
            );
          } else {
            tambahData();
          }
        },
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        label: Row(
          children: const [
            Icon(
              Icons.add_circle_outline,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              'Tambahkan Data',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scanDocument() async {
    List<String> pictures;
    try {
      pictures = await CunningDocumentScanner.getPictures(
            noOfPages: 1,
            isGalleryImportAllowed: true,
          ) ??
          [];
      if (!mounted) return;
      setState(() {
        _pictures = pictures;
        _files = pictures.map((path) => File(path)).toList();
      });
    } catch (exception) {
      if (!mounted) return;
      print("exception: $exception");
    }
  }

  Future<void> tambahData() async {
    String url = 'http://10.0.10.58:3000/api/uploadFile';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add text fields
    request.fields['tema_kegiatan'] = temaController.text;
    request.fields['tanggal_kegiatan'] = tanggalController.text;
    request.fields['tanggal_pembuatan'] = DateTime.now().toString();

    // Add files
    for (File file in _files) {
      var stream = http.ByteStream(file.openRead().cast());
      var length = await file.length();
      request.files.add(http.MultipartFile(
        'file',
        stream,
        length,
        filename: file.path.split('/').last,
      ));
    }

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        // Handle successful response
        var responseData = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responseData.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil ditambahkan')),
        );
        print('Data added successfully: $jsonResponse');
        clearForm(); // Clear the form after successful submission
        Navigator.pop(context);
      } else {
        // Handle error response
        print('Failed to add data: ${response.statusCode}');
        print('Tema: ${temaController.text}');
        print('Tanggal: ${tanggalController.text}');
        print('Tanggal Pembuatan: ${DateTime.now()}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Gagal menambahkan data: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan saat mengirim data')),
      );
    }
  }
}
