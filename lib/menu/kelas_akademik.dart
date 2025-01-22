import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class KelasAkademikPage extends StatefulWidget {
  const KelasAkademikPage({Key? key}) : super(key: key);

  @override
  _KelasAkademikPageState createState() => _KelasAkademikPageState();
}

class _KelasAkademikPageState extends State<KelasAkademikPage> {
  final List<Map<String, dynamic>> _kelasList = [];
  final String apiUrlAmbil =
      'http://teknologi22.xyz/project_api/api_intan/kelas_akademik/ambildata.php';

  @override
  void initState() {
    super.initState();
    _fetchKelasData();
  }

  Future<void> _fetchKelasData() async {
    try {
      final response = await http.get(Uri.parse(apiUrlAmbil));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          final List<dynamic> data = jsonResponse['data'] ?? [];
          setState(() {
            _kelasList.clear();
            _kelasList.addAll(
                data.map((kelas) => Map<String, dynamic>.from(kelas)).toList());
          });
        } else {
          _showErrorDialog(jsonResponse['message'] ?? 'Terjadi kesalahan');
        }
      } else {
        _showErrorDialog('Gagal mengambil data dari server');
      }
    } catch (error) {
      _showErrorDialog('Kesalahan koneksi: $error');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kelas Akademik',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Welcome Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.class_, color: Colors.indigo, size: 40),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Selamat datang di halaman kelas akademik, mari lihat kelas!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Class List
            Expanded(
              child: _kelasList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: _kelasList.length,
                itemBuilder: (context, index) {
                  final kelas = _kelasList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        kelas['nama_kelas'] ?? '-',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      subtitle: Text(
                        'Dosen: ${kelas['nama_dosen'] ?? '-'}\n'
                            'Ruangan: ${kelas['ruang'] ?? '-'}\n'
                            'SKS: ${kelas['sks'] ?? '-'}\n'
                            'Jadwal: ${kelas['waktu'] ?? '-'}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
