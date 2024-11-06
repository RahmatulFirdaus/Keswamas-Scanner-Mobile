import 'package:final_keswamas/model/keswamas_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    tema_kegiatan: "",
    gambar: "",
    tanggal_kegiatan: "",
    tanggal_pembuatan: "",
  );

  GetFile getFile = GetFile(gambar: '');
  bool isLoading = true;
  bool isImageExpanded = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final dataDrop =
        await DroppingPasienDetail.getDroppingPasienDetail(widget.id);
    final getFileDrop = await GetFile.getFile(widget.id);
    setState(() {
      droppingPasienDetail = dataDrop;
      getFile = getFileDrop;
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

  void _toggleImageSize() {
    setState(() {
      isImageExpanded = !isImageExpanded;
    });
  }

  Widget _buildImageViewer() {
    return GestureDetector(
      onTap: _toggleImageSize,
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
                    onPressed: () => launchUrl(Uri.parse(getFile.gambar)),
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
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
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: getFile.gambar.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        getFile.gambar[index],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                isImageExpanded
                    ? 'Ketuk untuk memperkecil'
                    : 'Ketuk untuk memperbesar',
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

  Widget _buildInfoCard(String title, String value) {
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
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
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
                            droppingPasienDetail.tema_kegiatan,
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
                          _buildImageViewer(),
                          const SizedBox(height: 16),
                          const Text(
                            'Informasi Detail',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoCard(
                            'Tanggal Kegiatan',
                            formatDate(droppingPasienDetail.tanggal_kegiatan),
                          ),
                          _buildInfoCard(
                            'Tanggal Pembuatan',
                            formatDate(droppingPasienDetail.tanggal_pembuatan),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
