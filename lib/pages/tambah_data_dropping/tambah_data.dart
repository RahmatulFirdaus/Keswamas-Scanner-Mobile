import 'dart:convert'; // Add this import for JSON encoding
import 'dart:ui';

import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
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
  List<String> _extractedFiles = [];

  Future<void> extractZipAndDisplay(String zipFilePath) async {
    try {
      // Open the ZIP file
      File zipFile = File(zipFilePath);
      List<int> bytes = await zipFile.readAsBytes();

      // Decode the ZIP file
      Archive archive = ZipDecoder().decodeBytes(bytes);

      // Get the app's document directory to store extracted files
      Directory tempDir = await getTemporaryDirectory();
      String extractPath = '${tempDir.path}/extracted_files';
      await Directory(extractPath).create(recursive: true);

      // Extract the files
      List<String> extractedFilePaths = [];
      for (var file in archive) {
        if (file.isFile) {
          // Write the file to disk
          String filePath = '$extractPath/${file.name}';
          File outputFile = File(filePath);
          await outputFile.writeAsBytes(file.content);

          extractedFilePaths.add(filePath);
        }
      }

      // Update state to display the extracted files
      setState(() {
        _extractedFiles = extractedFilePaths;
      });
    } catch (e) {
      print("Error extracting ZIP file: $e");
    }
  }

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

  // Fungsi untuk memindai dokumen menggunakan plugin CunningDocumentScanner
  void scanDocument() async {
    List<String> pictures; // Daftar untuk menyimpan path gambar hasil scan
    try {
      // Memanggil plugin CunningDocumentScanner untuk mengambil gambar, dengan pengaturan:
      // - noOfPages: 1 (jumlah halaman yang ingin discan)
      // - isGalleryImportAllowed: true (mengizinkan impor dari galeri)
      pictures = await CunningDocumentScanner.getPictures(
            noOfPages: 100,
            isGalleryImportAllowed: true,
          ) ??
          [];

      // Jika widget ini tidak lagi terpasang di layar, hentikan proses
      if (!mounted) return;

      // Update state dengan hasil gambar
      setState(() {
        _pictures = pictures; // Menyimpan path gambar dalam state
        _files = pictures
            .map((path) => File(path))
            .toList(); // Mengonversi path menjadi daftar objek File
      });
    } catch (exception) {
      // Jika terjadi kesalahan, periksa apakah widget masih terpasang, lalu cetak error
      if (!mounted) return;
      print("exception: $exception"); // Mencetak pesan error
    }
  }

// Fungsi untuk mengirim data ke server
  Future<void> tambahData() async {
    // URL API untuk upload file
    String url = 'http://192.168.1.9:3000/api/uploadFile';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Menambahkan field teks ke dalam request
    request.fields['tema_kegiatan'] = temaController.text; // Tema kegiatan
    request.fields['tanggal_kegiatan'] =
        tanggalController.text; // Tanggal kegiatan
    request.fields['tanggal_pembuatan'] = DateTime.now()
        .toString(); // Tanggal pembuatan otomatis (tanggal saat ini)

    // Menambahkan file ke dalam request
    for (File file in _files) {
      var stream = http.ByteStream(
          file.openRead().cast()); // Membaca file sebagai stream
      var length = await file.length(); // Mendapatkan ukuran file
      request.files.add(http.MultipartFile(
        'file', // Nama field untuk file pada server
        stream, // Stream data file
        length, // Panjang file dalam byte
        filename: file.path.split('/').last, // Nama file
      ));
    }

    try {
      // Mengirim request ke server
      var response = await request.send();

      if (response.statusCode == 200) {
        // Jika respons berhasil (status 200)
        var responseData = await http.Response.fromStream(
            response); // Membaca data respons dari stream
        var jsonResponse =
            jsonDecode(responseData.body); // Mengonversi respons menjadi JSON

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Data berhasil ditambahkan')), // Menampilkan pesan sukses
          );
        }
        print(
            'Data added successfully: $jsonResponse'); // Mencetak data hasil respons

        clearForm(); // Mengosongkan form setelah pengiriman sukses
        Navigator.pop(context); // Kembali ke halaman sebelumnya
      } else {
        // Jika terjadi kesalahan saat menambahkan data
        var responseData = await http.Response.fromStream(response);
        print(
            'Failed to add data: ${response.statusCode}'); // Mencetak status kode error
        print(
            'Response body: ${responseData.body}'); // Mencetak data error dari server
        print('Tema: ${temaController.text}'); // Debug: mencetak nilai tema
        print(
            'Tanggal: ${tanggalController.text}'); // Debug: mencetak nilai tanggal kegiatan
        print(
            'Tanggal Pembuatan: ${DateTime.now()}'); // Debug: mencetak nilai tanggal pembuatan

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Gagal menambahkan data: ${response.reasonPhrase}')), // Menampilkan pesan error
          );
        }
      }
    } catch (e) {
      // Penanganan kesalahan saat mengirim data
      print('Exception: $e'); // Mencetak pesan error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Terjadi kesalahan saat mengirim data')), // Menampilkan pesan error
        );
      }
    }
  }
}
