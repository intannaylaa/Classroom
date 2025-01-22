import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TugasPage extends StatefulWidget {
  const TugasPage({super.key});

  @override
  _TugasPageState createState() => _TugasPageState();
}

class _TugasPageState extends State<TugasPage> {
  final List<Map<String, dynamic>> _tugasList = [];
  final String apiUrlAmbilTugas = 'http://teknologi22.xyz/project_api/api_intan/tugas/ambildata.php'; // API for fetching tasks
  final String apiUrlUpdateStatus = 'http://teknologi22.xyz/project_api/api_intan/tugas/updatestatus.php'; // API for updating task status

  @override
  void initState() {
    super.initState();
    _fetchTugasData(); // Fetch tasks from the server when the page loads
  }

  Future<void> _fetchTugasData() async {
    try {
      final response = await http.get(Uri.parse(apiUrlAmbilTugas));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          final List<dynamic> data = jsonResponse['data'] ?? [];
          setState(() {
            _tugasList.clear();
            _tugasList.addAll(data.map((tugas) => Map<String, dynamic>.from(tugas)).toList());
          });
          _saveToSharedPreferences(); // Save fetched data to SharedPreferences
        }
      }
    } catch (error) {
      _showErrorDialog('Kesalahan koneksi: $error');
    }
  }

  Future<void> _saveToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('tugasList', json.encode(_tugasList)); // Save data to shared preferences
  }

  Future<void> _loadFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('tugasList');
    if (data != null) {
      setState(() {
        _tugasList.clear();
        _tugasList.addAll(List<Map<String, dynamic>>.from(json.decode(data)));
      });
    }
  }

  Future<void> _updateStatus(int index) async {
    setState(() {
      // Change status from "belum dikumpulkan" to "sudah dikumpulkan"
      _tugasList[index]['status'] = 'sudah dikumpulkan';
    });
    await _saveToSharedPreferences(); // Save updated status to SharedPreferences

    // Update status in the database via API
    try {
      final response = await http.post(
        Uri.parse(apiUrlUpdateStatus),
        body: {'id_tugas': _tugasList[index]['id'].toString()},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _showSnackbar('Status tugas berhasil diperbarui!', Colors.green);
        } else {
          _showErrorDialog('Gagal memperbarui status tugas: ${data['message']}');
        }
      } else {
        _showErrorDialog('Gagal mengirim data ke server (status code: ${response.statusCode})');
      }
    } catch (error) {
      _showErrorDialog('Terjadi kesalahan: $error');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tugas Akademik'),
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
                      const Icon(Icons.assignment, color: Colors.indigo, size: 40),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Lihat tugas yang sudah ditambahkan oleh admin di halaman ini!',
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
              child: _tugasList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: _tugasList.length,
                itemBuilder: (context, index) {
                  final tugas = _tugasList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        tugas['judul_tugas'] ?? '-',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      subtitle: Text(
                        'Deskripsi: ${tugas['deskripsi_tugas'] ?? '-'}\n'
                            'Batas Waktu: ${tugas['batas_waktu'] ?? '-'}\n'
                            'Status: ${tugas['status'] ?? 'belum dikumpulkan'}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => _updateStatus(index), // Update task status
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 2,
                        ),
                        child: const Text('Kumpulkan Tugas'),
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
