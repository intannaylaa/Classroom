import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class KelolaKelasAkademikPage extends StatefulWidget {
  const KelolaKelasAkademikPage({super.key});

  @override
  _KelolaKelasAkademikPageState createState() =>
      _KelolaKelasAkademikPageState();
}

class _KelolaKelasAkademikPageState extends State<KelolaKelasAkademikPage> {
  final List<Map<String, dynamic>> _kelasList = [];
  final TextEditingController _nomorKelasController = TextEditingController();
  final TextEditingController _namaKelasController = TextEditingController();
  final TextEditingController _dosenController = TextEditingController();
  final TextEditingController _ruanganController = TextEditingController();
  final TextEditingController _sksController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();

  final String apiUrlTambah = 'http://teknologi22.xyz/project_api/api_intan/kelas_akademik/tambahdata.php';
  final String apiUrlAmbil = 'http://teknologi22.xyz/project_api/api_intan/kelas_akademik/ambildata.php';
  final String apiUrlUpdate = 'http://teknologi22.xyz/project_api/api_intan/kelas_akademik/updatedata.php';
  final String apiUrlHapus = 'http://teknologi22.xyz/project_api/api_intan/kelas_akademik/hapusdata.php';

  @override
  void initState() {
    super.initState();
    _loadKelas();
  }

  Future<void> _loadKelas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('kelolakelas');
    if (data != null) {
      setState(() {
        _kelasList.clear();
        _kelasList.addAll(List<Map<String, dynamic>>.from(json.decode(data)));
      });
    } else {
      _fetchDataFromAPI();
    }
  }

  Future<void> _fetchDataFromAPI() async {
    try {
      final response = await http.get(Uri.parse(apiUrlAmbil));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          final List<dynamic> data = jsonResponse['data'] ?? [];
          setState(() {
            _kelasList.clear();
            _kelasList.addAll(data.map((kelas) => Map<String, dynamic>.from(kelas)).toList());
          });
          _saveKelas();
        } else {
          _showErrorDialog(jsonResponse['message'] ?? 'Terjadi kesalahan');
        }
      } else {
        _showErrorDialog('Gagal mengambil data dari server (status code: ${response.statusCode})');
      }
    } catch (error) {
      _showErrorDialog('Kesalahan koneksi: $error');
    }
  }

  Future<void> _saveKelas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('kelolakelas', json.encode(_kelasList));
  }

  Future<void> _hapusKelas(Map<String, dynamic> kelas) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrlHapus),
        body: {'nomor_kelas': kelas['nomor_kelas']},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _kelasList.remove(kelas);
            _saveKelas();
          });
          _showSnackbar('Kelas berhasil dihapus!', Colors.green);
        } else {
          _showErrorDialog('Gagal menghapus kelas: ${data['message']}');
        }
      } else {
        _showErrorDialog('Gagal menghapus data (status code: ${response.statusCode})');
      }
    } catch (error) {
      _showErrorDialog('Kesalahan koneksi: $error');
    }
  }

  Future<void> _updateKelas(Map<String, dynamic> kelas) async {
    _nomorKelasController.text = kelas['nomor_kelas'];
    _namaKelasController.text = kelas['nama_kelas'];
    _dosenController.text = kelas['nama_dosen'];
    _ruanganController.text = kelas['ruang'];
    _sksController.text = kelas['sks'];
    _waktuController.text = kelas['waktu'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Kelas Akademik'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildTextField(_nomorKelasController, 'Nomor Kelas', TextInputType.number),
                _buildTextField(_namaKelasController, 'Nama Kelas'),
                _buildTextField(_dosenController, 'Nama Dosen'),
                _buildTextField(_ruanganController, 'Ruangan'),
                _buildTextField(_sksController, 'SKS', TextInputType.number),
                _buildTextField(_waktuController, 'Waktu'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                await _submitUpdate(kelas);
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitUpdate(Map<String, dynamic> originalKelas) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrlUpdate),
        body: {
          'nomor_kelas': _nomorKelasController.text,
          'nama_kelas': _namaKelasController.text,
          'nama_dosen': _dosenController.text,
          'ruang': _ruanganController.text,
          'sks': _sksController.text,
          'waktu': _waktuController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            int index = _kelasList.indexOf(originalKelas);
            if (index != -1) {
              _kelasList[index] = {
                'nomor_kelas': _nomorKelasController.text,
                'nama_kelas': _namaKelasController.text,
                'nama_dosen': _dosenController.text,
                'ruang': _ruanganController.text,
                'sks': _sksController.text,
                'waktu': _waktuController.text,
              };
              _saveKelas();
            }
          });
          _showSnackbar('Kelas berhasil diperbarui!', Colors.green);
        } else {
          _showErrorDialog('Gagal memperbarui kelas: ${data['message']}');
        }
      } else {
        _showErrorDialog('Gagal mengirim data ke server (status code: ${response.statusCode})');
      }
    } catch (error) {
      _showErrorDialog('Terjadi kesalahan: $error');
    }
  }

  Widget _buildTextField(TextEditingController controller, String label, [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        ),
      ),
    );
  }

  void _clearFields() {
    _nomorKelasController.clear();
    _namaKelasController.clear();
    _dosenController.clear();
    _ruanganController.clear();
    _sksController.clear();
    _waktuController.clear();
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

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _tambahKelas() {
    _clearFields(); // Kosongkan semua input
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Kelas Akademik'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildTextField(_nomorKelasController, 'Nomor Kelas', TextInputType.number),
                _buildTextField(_namaKelasController, 'Nama Kelas'),
                _buildTextField(_dosenController, 'Nama Dosen'),
                _buildTextField(_ruanganController, 'Ruangan'),
                _buildTextField(_sksController, 'SKS', TextInputType.number),
                _buildTextField(_waktuController, 'Waktu'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                await _submitTambah();
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitTambah() async {
    final newKelas = {
      'nomor_kelas': _nomorKelasController.text,
      'nama_kelas': _namaKelasController.text,
      'nama_dosen': _dosenController.text,
      'ruang': _ruanganController.text,
      'sks': _sksController.text,
      'waktu': _waktuController.text,
    };
    try {
      final response = await http.post(
        Uri.parse(apiUrlTambah),
        body: newKelas,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _kelasList.add(newKelas);
            _saveKelas();
          });
          _showSnackbar('Kelas berhasil ditambahkan!', Colors.green);
        } else {
          _showErrorDialog('Gagal menambahkan kelas: ${data['message']}');
        }
      } else {
        _showErrorDialog('Gagal mengirim data ke server (status code: ${response.statusCode})');
      }
    } catch (error) {
      _showErrorDialog('Terjadi kesalahan: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kelola Kelas Akademik',
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.book, color: Colors.indigo, size: 30),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Halo admin, tambahkan Kelas Akademik mu!',
                          style: TextStyle(
                            fontSize: 14,
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
            const Text(
              'Daftar Kelas Akademik',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _kelasList.length,
                itemBuilder: (context, index) {
                  final kelas = _kelasList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Text(kelas['nama_kelas'], style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          'Dosen: ${kelas['nama_dosen']} - Ruang: ${kelas['ruang']}',
                          style: TextStyle(color: Colors.grey[600])),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () {
                              _updateKelas(kelas);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _hapusKelas(kelas);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahKelas,
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
