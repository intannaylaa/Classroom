import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class KonsultasiPage extends StatefulWidget {
  const KonsultasiPage({Key? key}) : super(key: key);

  @override
  _KonsultasiPageState createState() => _KonsultasiPageState();
}

class _KonsultasiPageState extends State<KonsultasiPage> {
  final TextEditingController _topikController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _pesanController = TextEditingController();
  final TextEditingController _nomorController = TextEditingController();

  List<Map<String, dynamic>> konsultasiData = [];
  final String apiUrlTambah = 'http://teknologi22.xyz/project_api/api_intan/konsultasi/tambahkonsultasi.php';
  final String apiUrlAmbil = 'http://teknologi22.xyz/project_api/api_intan/konsultasi/ambildata.php';
  final String apiUrlUpdate = 'http://teknologi22.xyz/project_api/api_intan/konsultasi/updatekonsultasi.php';
  final String apiUrlHapus = 'http://teknologi22.xyz/project_api/api_intan/konsultasi/hapuskonsultasi.php';

  @override
  void initState() {
    super.initState();
    _loadKonsultasiData();
  }

  Future<void> _loadKonsultasiData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('konsultasiData');
    if (data != null) {
      setState(() {
        konsultasiData = List<Map<String, dynamic>>.from(json.decode(data));
      });
    } else {
      _fetchDataFromAPI();
    }
  }

  Future<void> _fetchDataFromAPI() async {
    try {
      final response = await http.get(Uri.parse(apiUrlAmbil));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          konsultasiData = responseData is List
              ? List<Map<String, dynamic>>.from(responseData)
              : List<Map<String, dynamic>>.from(responseData['data']);
        });
        _saveKonsultasiData();
      } else {
        throw Exception('Gagal mengambil data!');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> _saveKonsultasiData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = json.encode(konsultasiData);
    await prefs.setString('konsultasiData', encodedData);
  }

  Future<void> _addKonsultasi() async {
    if (_topikController.text.isEmpty ||
        _keteranganController.text.isEmpty ||
        _pesanController.text.isEmpty ||
        _nomorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Semua field harus diisi!'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    String tanggalKonsultasi = DateTime.now().toIso8601String();
    Map<String, dynamic> newKonsultasi = {
      'topik': _topikController.text,
      'keterangan': _keteranganController.text,
      'pesan': _pesanController.text,
      'nomor': _nomorController.text,
      'tanggal_konsultasi': tanggalKonsultasi,
    };

    setState(() {
      konsultasiData.add(newKonsultasi);
    });

    _saveKonsultasiData();

    await http.post(Uri.parse(apiUrlTambah), body: newKonsultasi);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Konsultasi berhasil ditambahkan!'),
      backgroundColor: Colors.green,
    ));

    _topikController.clear();
    _keteranganController.clear();
    _pesanController.clear();
    _nomorController.clear();
  }

  Future<void> _hapusKonsultasi(Map<String, dynamic> konsultasi) async {
    try {
      final response = await http.post(Uri.parse(apiUrlHapus), body: {'nomor': konsultasi['nomor']});
      if (response.statusCode == 200 && json.decode(response.body)['status'] == 'success') {
        setState(() {
          konsultasiData.remove(konsultasi);
        });
        _saveKonsultasiData();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data berhasil dihapus!')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _editKonsultasi(Map<String, dynamic> konsultasi) async {
    Map<String, dynamic> updatedKonsultasi = {
      'nomor': konsultasi['nomor'],
      'topik': konsultasi['topik'],
      'keterangan': konsultasi['keterangan'],
      'pesan': konsultasi['pesan'],
      'tanggal_konsultasi': konsultasi['tanggal_konsultasi'],
    };
    await _saveKonsultasiData();
    await http.post(Uri.parse(apiUrlUpdate), body: updatedKonsultasi);
  }

  Widget _buildKonsultasiCard(Map<String, dynamic> konsultasi) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 5,
      color: Colors.indigo[50],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nomor: ${konsultasi['nomor']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo[800])),
            SizedBox(height: 5),
            Text('Topik: ${konsultasi['topik']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo[800])),
            SizedBox(height: 5),
            Text('Keterangan: ${konsultasi['keterangan']}', style: TextStyle(color: Colors.black54)),
            Text('Pesan: ${konsultasi['pesan']}', style: TextStyle(color: Colors.black54)),
            SizedBox(height: 10),
            Text('Tanggal Konsultasi: ${konsultasi['tanggal_konsultasi']}', style: TextStyle(color: Colors.black54)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => _showEditDialog(konsultasi),
                  child: Text('Edit'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _hapusKonsultasi(konsultasi),
                  child: Text('Hapus'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDialog(Map<String, dynamic> konsultasi) async {
    _topikController.text = konsultasi['topik'];
    _keteranganController.text = konsultasi['keterangan'];
    _pesanController.text = konsultasi['pesan'];
    _nomorController.text = konsultasi['nomor'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Konsultasi'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _topikController,
                  decoration: InputDecoration(labelText: 'Topik'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _keteranganController,
                  decoration: InputDecoration(labelText: 'Keterangan'),
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _pesanController,
                  decoration: InputDecoration(labelText: 'Pesan'),
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _nomorController,
                  decoration: InputDecoration(labelText: 'Nomor'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                String topik = _topikController.text;
                String keterangan = _keteranganController.text;
                String pesan = _pesanController.text;
                String nomor = _nomorController.text;

                if (topik.isEmpty || keterangan.isEmpty || pesan.isEmpty || nomor.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Semua field harus diisi!'),
                    backgroundColor: Colors.red,
                  ));
                  return;
                }

                // Data yang diperbarui, tambahkan tanggal konsultasi
                Map<String, dynamic> updatedKonsultasi = {
                  'nomor': nomor,
                  'topik': topik,
                  'keterangan': keterangan,
                  'pesan': pesan,
                  'tanggal_konsultasi': konsultasi['tanggal_konsultasi'], // Pertahankan tanggal asli
                };

                // Kirim data ke API
                await _editKonsultasi(updatedKonsultasi);

                // Update UI secara lokal
                setState(() {
                  konsultasi['topik'] = topik;
                  konsultasi['keterangan'] = keterangan;
                  konsultasi['pesan'] = pesan;
                  konsultasi['nomor'] = nomor;
                });

                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konsultasi'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _topikController,
              decoration: InputDecoration(labelText: 'Topik', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _keteranganController,
              decoration: InputDecoration(labelText: 'Keterangan', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _pesanController,
              decoration: InputDecoration(labelText: 'Pesan', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _nomorController,
              decoration: InputDecoration(labelText: 'Nomor', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addKonsultasi,
              child: Text('Tambah Konsultasi'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            ),
            SizedBox(height: 20),
            Column(
              children: konsultasiData.map((konsultasi) => _buildKonsultasiCard(konsultasi)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
