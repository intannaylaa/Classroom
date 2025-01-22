import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);  // Konstruktor untuk kelas HomePage yang menerima parameter opsional key.

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

  Widget _buildTodayScheduleCard(List<Map<String, String>> schedule) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Jadwal Hari Ini',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 10),
            ...schedule.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 20,
                    color: Colors.indigo,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${item['time']} - ${item['subject']}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    // Contoh data jadwal hari ini
    final todaySchedule = [
      {'time': '08:00 - 10:00', 'subject': 'Matematika'},
      {'time': '10:30 - 12:30', 'subject': 'Pemrograman'},
      {'time': '13:00 - 15:00', 'subject': 'Sistem Informasi'},
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang, Mahasiswa!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Ayo mulai belajar dan atur jadwalmu.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            // Card Jadwal Hari Ini
            _buildTodayScheduleCard(todaySchedule),
            const SizedBox(height: 20),
            // Grid Menu
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Dua kolom
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _buildMenuCard(
                    'Kelas Akademik',

                    Icons.school,
                        () {
                      Navigator.pushNamed(context, '/menu/kelas_akademik');
                    },
                  ),

                  _buildMenuCard(
                    'Tugas Belum Dikumpulkan',
                    Icons.assignment_late,
                        () {
                      Navigator.pushNamed(context, '/menu/tugas');
                    },
                  ),

                  _buildMenuCard(
                    'KRS',
                    Icons.list_alt,
                        () {
                      Navigator.pushNamed(context, '/menu/krs');
                    },
                  ),
                  _buildMenuCard(
                    'Konsultasi Dosen',
                    Icons.person,
                        () {
                      Navigator.pushNamed(context, '/menu/konsultasi');
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
