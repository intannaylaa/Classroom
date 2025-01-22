import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menu/kelola_kelas_akademik.dart';
import 'menu/kelola_daftar_tugas.dart';
import 'admin_profile.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  Widget _buildMenuCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.indigo,
              ),
              const SizedBox(height: 15),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear(); // Clear preferences for logout
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/admin_home_page');
              },
            ),
            ListTile(
              leading: const Icon(Icons.class_),
              title: const Text('Kelola Kelas Akademik'),
              onTap: () {
                Navigator.pushNamed(context, '/menu/kelola_kelas_akademik');
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Kelola Daftar Tugas'),
              onTap: () {
                Navigator.pushNamed(context, '/menu/kelola_daftar_tugas');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/admin_profile');
              },
            ),




          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang, Admin!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Ayo kelola aplikasi dan data.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            // Grid Menu untuk Admin
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Dua kolom
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _buildMenuCard(
                    'Kelola Kelas Akademik',
                    Icons.class_,
                        () {
                      Navigator.pushNamed(context, '/menu/kelola_kelas_akademik');
                    },
                  ),
                  _buildMenuCard(
                    'Kelola Daftar Tugas',
                    Icons.assignment,
                        () {
                      Navigator.pushNamed(context, '/menu/kelola_daftar_tugas');
                    },
                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
