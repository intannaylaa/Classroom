import 'package:flutter/material.dart';
import 'admin_home_page.dart'; // Halaman untuk Admin
import 'menu/kelola_daftar_tugas.dart'; // Halaman untuk mengelola daftar tugas
import 'menu/kelola_kelas_akademik.dart'; // Halaman untuk mengelola daftar tugas
import 'home_page.dart'; // Halaman HomePage untuk User
import 'menu/kelas_akademik.dart'; // Impor halaman kelas akademik
import 'menu/tugas.dart'; // Impor halaman tugas.dart
import 'menu/krs.dart';
import 'login_page.dart';
import 'menu/konsultasi.dart';
import 'admin_profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Konstruktor untuk kelas MyApp yang menerima parameter opsional key.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classroom & Admin Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.blue.shade800,
          secondary: Colors.blue.shade200,
        ),
        scaffoldBackgroundColor: Colors.blue.shade50,  // Ganti latar belakang dengan biru muda
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,  // Ganti warna teks dengan biru lebih gelap
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey,
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      initialRoute: '/', // Rute awal menuju WelcomeScreen
      routes: {
        '/': (context) => const WelcomeScreen(),  // Menambahkan WelcomeScreen
        '/admin_home_page': (context) => const AdminHomePage(),
        '/menu/kelola_daftar_tugas': (context) => const KelolaTugasAkademikPage(),
        '/menu/kelola_kelas_akademik': (context) => const KelolaKelasAkademikPage(),
        '/home': (context) => const HomePage(),
        '/menu/kelas_akademik': (context) => const KelasAkademikPage(),
        '/login': (context) => const LoginPage(),
        '/menu/tugas': (context) => const TugasPage(),
        '/menu/krs': (context) => const  KRSPage(),
        '/menu/konsultasi': (context) => const KonsultasiPage(),
        '/admin_profile': (context) => const AdminProfilePage(),

      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/kelas4.png',  // Pastikan gambar ini tersedia di folder assets
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedText(), // Perbaiki di sini, hapus const
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );

                      Future.delayed(const Duration(seconds: 3), () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      });
                    },
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    label: const Text('Mulai'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedText extends StatefulWidget {
  const AnimatedText({Key? key}) : super(key: key);

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: const Text(
        'Welcome to Classroom',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 8.0,
              color: Colors.black54,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
      ),
    );
  }
}
