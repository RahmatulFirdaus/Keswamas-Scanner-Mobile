import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:final_keswamas/model/keswamas_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DataDroppingPasienDetail extends StatefulWidget {
  final String id;
  const DataDroppingPasienDetail({super.key, required this.id});

  @override
  State<DataDroppingPasienDetail> createState() =>
      _DataDroppingPasienDetailState();
}

class _DataDroppingPasienDetailState extends State<DataDroppingPasienDetail> {
  DroppingPasienDetail droppingPasienDetail = DroppingPasienDetail(
    id: "",
    temaKegiatan: "",
    gambar: "",
    tanggalKegiatan: "",
    tanggalPembuatan: "",
  );

  GetFile getFile = GetFile(gambar: '');
  List<GetFileEach> getFileEach = [];
  bool isLoading = true;
  bool isImageExpanded = false;
  List<String> extractedFiles = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final dataDrop =
        await DroppingPasienDetail.getDroppingPasienDetail(widget.id);
    final getFileDrop = await GetFile.getFile(widget.id);
    final getFileEachDrop = await GetFileEach.getFileEach(widget.id);
    setState(() {
      droppingPasienDetail = dataDrop;
      getFile = getFileDrop;
      getFileEach = getFileEachDrop;
      isLoading = false;
    });
  }

  String formatDate(String date) {
    try {
      final DateTime parsed = DateTime.parse(date);
      return DateFormat('dd MMMM yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }

  void toggleImageSize() {
    setState(() {
      isImageExpanded = !isImageExpanded;
    });
  }

  Future<void> downloadAndExtractZip(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<int> bytes = response.bodyBytes;

        Archive archive = ZipDecoder().decodeBytes(bytes);

        Directory tempDir = await getTemporaryDirectory();
        String extractPath = '${tempDir.path}/extracted_files';
        await Directory(extractPath).create(recursive: true);

        List<String> extractedFilePaths = [];
        for (var file in archive) {
          if (file.isFile) {
            String filePath = '$extractPath/${file.name}';
            File outputFile = File(filePath);
            await outputFile.writeAsBytes(file.content);

            extractedFilePaths.add(filePath);
          }
        }

        setState(() {
          extractedFiles = extractedFilePaths;
        });
      } else {
        throw Exception('Failed to download the file');
      }
    } catch (e) {
      print("Error downloading or extracting ZIP file: $e");
    }
  }

  Widget buildImageViewer() {
    return GestureDetector(
      onTap: toggleImageSize,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Preview Data',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => downloadAndExtractZip(getFile.gambar),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Display Image'),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: isImageExpanded
                    ? MediaQuery.of(context).size.height * 0.7
                    : 250,
              ),
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 16,
                  ),
                  itemCount: extractedFiles.length,
                  itemBuilder: (context, index) {
                    return Image.file(
                      File(extractedFiles[index]),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                isImageExpanded ? 'Tap to reduce size' : 'Tap to enlarge',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(String title, String value) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Detail Dropping Pasien'),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => fetchData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue[700]!, Colors.blue[500]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue[300]!.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tema Kegiatan',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            droppingPasienDetail.temaKegiatan,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildImageViewer(),
                          const SizedBox(height: 16),
                          const Text(
                            'Informasi Detail',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              buildInfoCard(
                                'Tanggal Kegiatan',
                                formatDate(
                                    droppingPasienDetail.tanggalKegiatan),
                              ),
                              Spacer(),
                              buildInfoCard(
                                'Tanggal Pembuatan',
                                formatDate(
                                    droppingPasienDetail.tanggalPembuatan),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          String url = getFile.gambar;
          launchUrl(Uri.parse(url));
        },
        child: const Icon(Icons.download, color: Colors.white),
      ),
    );
  }
}
