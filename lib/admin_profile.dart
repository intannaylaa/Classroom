import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart'; // Import halaman login

class AdminProfilePage extends StatefulWidget { // Mendefinisikan kelas AdminProfilePage yang merupakan StatefulWidget.
  const AdminProfilePage({Key? key}) : super(key: key);  // Konstruktor kelas AdminProfilePage yang menerima parameter opsional key.

  // Metode yang menghubungkan widget ini ke state-nya.
  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}
// State kelas _AdminProfilePageState yang mengatur logika dan data untuk AdminProfilePage.
class _AdminProfilePageState extends State<AdminProfilePage> {
  String username = ''; // Variabel untuk menyimpan nama pengguna yang akan ditampilkan di profil admin.
  String email = '';
  String role = ''; // Variabel untuk menyimpan peran (role) admin.

  Future<void> _fetchUserData() async {
    // Mengirim permintaan HTTP ke URL untuk mendapatkan data profil pengguna
    final response = await http.get(Uri.parse('http://teknologi22.xyz/project_api/api_intan/user_profile.php?id=1'));
    if (response.statusCode == 200) {   // Mengecek apakah permintaan berhasil dengan kode status 200
      final data = jsonDecode(response.body);    // Mengubah data yang diterima (dalam format JSON) menjadi format yang bisa digunakan
      if (data.containsKey('error')) {       // Jika ada error dalam data, tampilkan pesan kesalahan
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['error'])));
      } else {
        // Jika tidak ada error, simpan data profil ke variabel username, email, dan role
        setState(() {
          username = data['username'];
          email = data['email'];
          role = data['role'];
        });
      }
    } else {
      // Jika permintaan gagal, lemparkan exception atau error
      throw Exception('Failed to load user data');
    }
  }

  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_logged_in');
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Profile'),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/admin.png'),
            ),
            const SizedBox(height: 15),
            Text(
              username.isNotEmpty ? username : 'Loading...',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            const SizedBox(height: 5),
            Text(
              email.isNotEmpty ? email : 'Loading...',
              style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
            const SizedBox(height: 2),
            Chip(
              label: Text(role.isNotEmpty ? role : 'Loading...'),
              backgroundColor: Colors.indigoAccent.shade100,
              labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.indigo),
                title: Text(email.isNotEmpty ? email : 'Loading...', style: const TextStyle(fontSize: 16)),
              ),
            ),
            Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.indigo),
                title: Text(role.isNotEmpty ? role : 'Loading...', style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
