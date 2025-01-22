import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class KRSPage extends StatefulWidget {
  const KRSPage({super.key});  // Fixed the key issue

  @override
  _KRSPageState createState() => _KRSPageState();
}

class _KRSPageState extends State<KRSPage> {
  final List<Map<String, dynamic>> _kelasList = [];
  final List<Map<String, dynamic>> _krsList = [];
  final String apiUrlAmbil = 'http://teknologi22.xyz/project_api/api_intan/kelas_akademik/ambildata.php';
  final String apiUrlSimpanKRS = 'http://teknologi22.xyz/project_api/api_intan/krs/tambahkrs.php';
  final String apiUrlHapusKRS = 'http://teknologi22.xyz/project_api/api_intan/krs/hapuskrs.php';

  @override
  void initState() {
    super.initState();
    _fetchKelasData();
    _loadSavedKRS(); // Memuat data KRS yang sudah tersimpan
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
            _kelasList.addAll(data.map((kelas) => Map<String, dynamic>.from(kelas)).toList());
          });
        }
      }
    } catch (error) {
      _showErrorDialog('Kesalahan koneksi: $error');
    }
  }

  Future<void> _saveToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('savedKRS', json.encode(_krsList));
  }

  Future<void> _loadSavedKRS() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('savedKRS');
    if (data != null) {
      setState(() {
        _krsList.clear();
        _krsList.addAll(List<Map<String, dynamic>>.from(json.decode(data)));
      });
    }
  }

  void _addToKRS(Map<String, dynamic> kelas) {
    final existingKRS = _krsList.any((krs) => krs['nomor_kelas'] == kelas['nomor_kelas']);
    if (existingKRS) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('KRS sudah diambil'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    setState(() {
      _krsList.add(kelas);
    });
    _saveToSharedPreferences(); // Pastikan data lokal tersimpan langsung
    _saveToDatabase(kelas);
  }

  Future<void> _saveToDatabase(Map<String, dynamic> kelas) async {
    try {
      final response = await http.post(Uri.parse(apiUrlSimpanKRS), body: {
        'nomor_kelas': kelas['nomor_kelas'],
        'nama_kelas': kelas['nama_kelas'],
        'nama_dosen': kelas['nama_dosen'],
        'ruang': kelas['ruang'],
        'sks': kelas['sks'],
        'waktu': kelas['waktu'],
      });

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('KRS berhasil disimpan'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          _showErrorDialog('Gagal menyimpan KRS ke database');
        }
      } else {
        _showErrorDialog('Gagal menyimpan data ke database');
      }
    } catch (error) {
      _showErrorDialog('Gagal menyimpan data ke database: $error');
    }
  }

  void _removeFromKRS(int index) async {
    final kelas = _krsList[index];
    final nomorKelas = kelas['nomor_kelas'];

    try {
      final response = await http.post(
        Uri.parse(apiUrlHapusKRS),
        body: {'nomor_kelas': nomorKelas.toString()},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          setState(() {
            _krsList.removeAt(index);
            _saveToSharedPreferences();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('KRS berhasil dihapus'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          _showErrorDialog('Gagal menghapus KRS di database');
        }
      } else {
        _showErrorDialog('Kesalahan server saat menghapus data');
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
        title: const Text('KRS Mahasiswa'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
                      const Icon(Icons.book, color: Colors.indigo, size: 40),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Lihat dan tambahkan KRS Anda di halaman ini!',
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
                      trailing: ElevatedButton(
                        onPressed: () => _addToKRS(kelas),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 2,
                        ),
                        child: const Text('Tambah KRS'),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'KRS Tersimpan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _krsList.length,
                itemBuilder: (context, index) {
                  final kelas = _krsList[index];
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
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeFromKRS(index),
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
