import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart'; // Import halaman login

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = '';
  String email = '';
  String role = '';

  Future<void> _fetchUserData() async {
    final response = await http.get(Uri.parse('http://teknologi22.xyz/project_api/api_intan/user_profile.php?id=2'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'])),
        );
      } else {
        setState(() {
          username = data['username'];
          email = data['email'];
          role = data['role'];
        });
      }
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_logged_in');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Berhasil logout. Anda akan dialihkan ke halaman login.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/user.png'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    username.isNotEmpty ? username : 'Loading...',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email.isNotEmpty ? email : 'Loading...',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    role.isNotEmpty ? role : 'Loading...',
                    style: const TextStyle(fontSize: 14, color: Colors.black38),
                  ),
                  const Divider(height: 30, thickness: 1.5),
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.indigo),
                    title: Text(email.isNotEmpty ? email : 'Loading...'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.indigo),
                    title: Text(role.isNotEmpty ? role : 'Loading...'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent, // Mengganti 'primary' dengan 'backgroundColor'
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
