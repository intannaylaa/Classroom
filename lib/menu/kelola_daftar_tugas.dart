import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class KelolaTugasAkademikPage extends StatefulWidget {
  const KelolaTugasAkademikPage({super.key});

  @override
  _KelolaTugasAkademikPageState createState() =>
      _KelolaTugasAkademikPageState();
}

class _KelolaTugasAkademikPageState extends State<KelolaTugasAkademikPage> {
  final List<Map<String, dynamic>> _tugasList = [];
  final TextEditingController _judulTugasController = TextEditingController();
  final TextEditingController _deskripsiTugasController = TextEditingController();
  final TextEditingController _batasWaktuController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  final String apiUrlTambah = 'http://teknologi22.xyz/project_api/api_intan/tugas/tambahdata.php';
  final String apiUrlAmbil = 'http://teknologi22.xyz/project_api/api_intan/tugas/ambildata.php';
  final String apiUrlUpdate = 'http://teknologi22.xyz/project_api/api_intan/tugas/updatedata.php';
  final String apiUrlHapus = 'http://teknologi22.xyz/project_api/api_intan/tugas/hapusdata.php';

  String _filterStatus = 'semua'; // Default filter is all tasks

  @override
  void initState() {
    super.initState();
    _loadTugas();
  }

  Future<void> _loadTugas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('kelolatugas');
    if (data != null) {
      setState(() {
        _tugasList.clear();
        _tugasList.addAll(List<Map<String, dynamic>>.from(json.decode(data)));
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
            _tugasList.clear();
            _tugasList.addAll(data.map((tugas) => {
              'id': tugas['id'] ?? tugas['id_tugas'],  // Sesuaikan nama kolom jika berbeda
              'judul_tugas': tugas['judul_tugas'],
              'deskripsi_tugas': tugas['deskripsi_tugas'],
              'batas_waktu': tugas['batas_waktu'],
              'status': tugas['status'],
            }).toList());
          });
          _saveTugas();
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

  Future<void> _saveTugas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('kelolatugas', json.encode(_tugasList));
  }

  Future<void> _hapusTugas(Map<String, dynamic> tugas) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrlHapus),
        body: {'id_tugas': tugas['id'].toString()}, // Use 'id_tugas' here
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _tugasList.remove(tugas);
            _saveTugas();
          });
          _showSnackbar('Tugas berhasil dihapus!', Colors.green);
        } else {
          _showErrorDialog('Gagal menghapus tugas: ${data['message']}');
        }
      } else {
        _showErrorDialog('Gagal menghapus data (status code: ${response.statusCode})');
      }
    } catch (error) {
      _showErrorDialog('Kesalahan koneksi: $error');
    }
  }


  Future<void> _updateTugas(Map<String, dynamic> tugas) async {
    _judulTugasController.text = tugas['judul_tugas'];
    _deskripsiTugasController.text = tugas['deskripsi_tugas'];
    _batasWaktuController.text = tugas['batas_waktu'];
    _statusController.text = tugas['status'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Tugas Akademik'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildTextField(_judulTugasController, 'Judul Tugas'),
                _buildTextField(_deskripsiTugasController, 'Deskripsi Tugas'),
                _buildTextField(_batasWaktuController, 'Batas Waktu'),
                _buildTextField(_statusController, 'Status'),
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
                await _submitUpdate(tugas);
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitUpdate(Map<String, dynamic> originalTugas) async {
    if (_judulTugasController.text.isEmpty ||
        _deskripsiTugasController.text.isEmpty ||
        _batasWaktuController.text.isEmpty ||
        _statusController.text.isEmpty) {
      _showErrorDialog('Semua kolom harus diisi');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrlUpdate),
        body: {
          'id': originalTugas['id'].toString(),
          'judul_tugas': _judulTugasController.text,
          'deskripsi_tugas': _deskripsiTugasController.text,
          'batas_waktu': _batasWaktuController.text,
          'status': _statusController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            int index = _tugasList.indexOf(originalTugas);
            if (index != -1) {
              _tugasList[index] = {
                'id': originalTugas['id'],
                'judul_tugas': _judulTugasController.text,
                'deskripsi_tugas': _deskripsiTugasController.text,
                'batas_waktu': _batasWaktuController.text,
                'status': _statusController.text,
              };
              _saveTugas();
            }
          });
          _showSnackbar('Tugas berhasil diperbarui!', Colors.green);
        } else {
          _showErrorDialog('Gagal memperbarui tugas: ${data['message']}');
        }
      } else {
        _showErrorDialog('Gagal mengirim data ke server (status code: ${response.statusCode})');
      }
    } catch (error) {
      _showErrorDialog('Terjadi kesalahan: $error');
    }
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        controller: controller,
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
    _judulTugasController.clear();
    _deskripsiTugasController.clear();
    _batasWaktuController.clear();
    _statusController.clear();
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

  void _showAddTugasDialog() {
    _clearFields();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Tugas Akademik'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildTextField(_judulTugasController, 'Judul Tugas'),
                _buildTextField(_deskripsiTugasController, 'Deskripsi Tugas'),
                _buildTextField(_batasWaktuController, 'Batas Waktu'),
                _buildTextField(_statusController, 'Status'),
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
                await _submitAddTugas();
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitAddTugas() async {
    if (_judulTugasController.text.isEmpty ||
        _deskripsiTugasController.text.isEmpty ||
        _batasWaktuController.text.isEmpty ||
        _statusController.text.isEmpty) {
      _showErrorDialog('Semua kolom harus diisi');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrlTambah),
        body: {
          'judul_tugas': _judulTugasController.text,
          'deskripsi_tugas': _deskripsiTugasController.text,
          'batas_waktu': _batasWaktuController.text,
          'status': 'belum',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final newTugas = {
            'id': data['id'], // Gunakan ID yang dikembalikan oleh server
            'judul_tugas': _judulTugasController.text,
            'deskripsi_tugas': _deskripsiTugasController.text,
            'batas_waktu': _batasWaktuController.text,
            'status': 'belum',
          };
          setState(() {
            _tugasList.add(newTugas);
            _saveTugas();
          });
          _showSnackbar('Tugas berhasil ditambahkan!', Colors.green);
        } else {
          _showErrorDialog('Gagal menambahkan tugas: ${data['message']}');
        }
      } else {
        _showErrorDialog('Gagal mengirim data ke server (status code: ${response.statusCode})');
      }
    } catch (error) {
      _showErrorDialog('Kesalahan koneksi: $error');
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredTugasList = _tugasList;

    if (_filterStatus != 'semua') {
      filteredTugasList = _tugasList.where((tugas) => tugas['status'] == _filterStatus).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Tugas Akademik'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                _filterStatus = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return {'semua', 'belum', 'sudah'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice == 'semua'
                      ? 'Semua Tugas'
                      : (choice == 'belum' ? 'Belum Dikumpulkan' : '')),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredTugasList.length,
        itemBuilder: (context, index) {
          final tugas = filteredTugasList[index];
          Color statusColor = tugas['status'] == 'belum' ? Colors.red : Colors.green;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 5,
            child: ListTile(
              title: Text(tugas['judul_tugas']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${tugas['deskripsi_tugas']}'),
                  Text('Batas Waktu: ${tugas['batas_waktu']}'),
                  // Displaying the ID here
                  Text('ID: ${tugas['id']}', style: TextStyle(color: Colors.grey)),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: statusColor,
                    size: 24,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _hapusTugas(tugas);
                    },
                  ),
                ],
              ),
              onTap: () {
                _updateTugas(tugas);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTugasDialog,
        tooltip: 'Tambah Tugas',
        child: const Icon(Icons.add),
      ),
    );
  }
}
