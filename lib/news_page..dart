import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Berita Terkini Pendidikan',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: List.generate(3, (index) {
                String imageUrl;
                String title;
                String description;

                //gambar network
                switch (index) {
                  case 0:
                    imageUrl =
                    'https://images.unsplash.com/photo-1521481137585-72bf570cff34?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDJ8fHxlbnwwfHx8fHw%3D';
                    title = 'Pendidikan untuk Masa Depan';
                    description =
                    'Teknologi pendidikan semakin berkembang pesat, dan kini memberikan lebih banyak peluang untuk siswa di seluruh dunia.';
                    break;
                  case 1:
                    imageUrl =
                    'https://images.unsplash.com/photo-1529007196863-d07650a3f0ea?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDh8fHxlbnwwfHx8fHw%3D';
                    title = 'Menghadapi Tantangan Pendidikan';
                    description =
                    'Pendidikan di tengah pandemi menghadirkan tantangan baru yang harus diatasi oleh para pengajar dan siswa.';
                    break;
                  case 2:
                    imageUrl =
                    'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDEzfHx8ZW58MHx8fHx8';
                    title = 'Belajar Mandiri dengan Buku';
                    description =
                    'Buku tetap menjadi sumber daya utama dalam dunia pendidikan, memberikan informasi dan pengetahuan tak terhingga.';
                    break;
                  default:
                    imageUrl = '';
                    title = '';
                    description = '';
                }

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  child: InkWell(
                    onTap: () {
                      // Menampilkan dialog pop-up ketika card diklik
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(title),
                          content: Text(description),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Menutup dialog
                              },
                              child: const Text('Tutup'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              imageUrl,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
