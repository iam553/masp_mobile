import 'package:flutter/material.dart';
import 'webview_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(child: _content()),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Presensi'),
          BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Website'),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xff2f6ce5), Color(0xff4fa3f7)]),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Image.asset('assets/logo.png', width: 42),
          const SizedBox(width: 10),
          Expanded(
            child: Image.network(
              "https://masupra.sch.id/wp-content/uploads/2022/03/logo-masp.png",
              height: 35,
              errorBuilder: (c, e, s) => const SizedBox(),
            ),
          )
        ],
      ),
    );
  }

  Widget _content() {
    if (_index == 1) {
      return const WebViewPage(
        url: "https://presensi.masupra.sch.id",
        title: "Presensi Online",
      );
    } else if (_index == 2) {
      return const WebViewPage(
        url: "https://masupra.sch.id",
        title: "Website Sekolah",
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Selamat Datang 👋",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Row(
            children: [
              _menuCard(
                icon: Icons.timer,
                title: "Presensi Online",
                subtitle: "Akses sistem presensi sekolah",
                label: "Login Presensi",
                color: Colors.blue,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WebViewPage(
                      url: "https://presensi.masupra.sch.id",
                      title: "Presensi",
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _menuCard(
                icon: Icons.public,
                title: "Website Sekolah",
                subtitle: "Kunjungi website resmi",
                label: "Buka Website",
                color: Colors.green,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WebViewPage(
                      url: "https://masupra.sch.id",
                      title: "Website",
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Sistem Presensi Sekolah MASP",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(
                    "Aplikasi presensi modern, cepat, dan realtime terintegrasi sistem sekolah."),
                SizedBox(height: 8),
                Row(children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 18),
                  SizedBox(width: 6),
                  Text("Pantau kehadiran siswa & guru"),
                ]),
                SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 18),
                  SizedBox(width: 6),
                  Text("Laporan presensi realtime"),
                ]),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 6),
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}
