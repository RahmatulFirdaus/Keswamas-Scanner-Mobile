import 'package:final_keswamas/model/keswamas_model.dart';
import 'package:final_keswamas/pages/data_dropping_pasien_detail.dart';
import 'package:final_keswamas/pages/tambah_data_dropping/tambah_data.dart';
import 'package:final_keswamas/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class DataDroppingPasien extends StatefulWidget {
  final String username, password;
  const DataDroppingPasien(
      {super.key, required this.username, required this.password});

  @override
  State<DataDroppingPasien> createState() => _DataDroppingPasienState();
}

class _DataDroppingPasienState extends State<DataDroppingPasien> {
  List<DroppingPasien> dataDroppingPasien = [];
  List<DroppingPasien> searchResult = [];
  final TextEditingController _searchController = TextEditingController();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? _token;
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    loadToken();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String formatDate(String date) {
    try {
      final DateTime parsed = DateTime.parse(date);
      return DateFormat('dd MMMM yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }

  void loadToken() async {
    String? token = await _secureStorage.read(key: "jwt_token");
    setState(() {
      _token = token;
    });
    try {
      fetchData();
    } catch (e) {
      refreshToken();
    }
  }

  void refreshToken() async {
    String? token = await _secureStorage.read(key: "refresh_token");
    if (token != null) {
      try {
        final response = await RefreshToken.refreshJwtToken(token);

        if (response == "Berhasil") {
          loadToken();
        } else {
          await authService.logout();
        }
      } catch (e) {
        await authService.logout();
      }
    }
  }

  Future<void> fetchData() async {
    final dataDrop = await DroppingPasien.getDroppingPasien(_token!);
    setState(() {
      dataDroppingPasien = dataDrop;
      searchResult = dataDrop;
    });
  }

  void searchData(String query) {
    setState(() {
      if (query.isEmpty) {
        searchResult = dataDroppingPasien;
      } else {
        searchResult = dataDroppingPasien
            .where((data) =>
                data.temaKegiatan.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: searchData,
      decoration: InputDecoration(
        hintText: 'Cari data kegiatan',
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  searchData('');
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: searchResult.length,
      itemBuilder: (context, index) {
        final data = searchResult[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DataDroppingPasienDetail(
                      id: data.id.toString(),
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.dashboard_customize_outlined,
                        size: 24,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.temaKegiatan,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatDate(data.tanggalKegiatan),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Data tidak ditemukan',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Dropping Pasien'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchData,
          ),
        ],
      ),
      body: _token != null
          ? dataDroppingPasien.isNotEmpty
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildSearchField(),
                        const SizedBox(height: 20),
                        searchResult.isEmpty
                            ? _buildEmptyState()
                            : _buildListView(),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: Text("Kamu tidak memiliki akses data ini"),
                )
          : const Center(
              child: Text("Akses Tidak Ditemukan"),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => const TambahDataDroppingPasien(),
                ),
              )
              .then((_) => fetchData());
        },
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
