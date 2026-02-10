import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MaspApp());
}

/// ================= MAIN APP =================
class MaspApp extends StatefulWidget {
  const MaspApp({super.key});

  @override
  State<MaspApp> createState() => _MaspAppState();
}

class _MaspAppState extends State<MaspApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MA Sunan Prawoto',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF6F8FB),
        primaryColor: const Color(0xFF1B5E20),
        fontFamily: 'Roboto',
        cardColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: SplashScreen(toggleTheme: toggleTheme),
    );
  }
}

/// ================= SPLASH SCREEN =================
class SplashScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  const SplashScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Image.asset(
          'assets/logo.png',
          width: 260,
          fit: BoxFit.contain,
        ),
      ),
      nextScreen: HomePage(toggleTheme: toggleTheme),
      splashIconSize: 320,
      duration: 2400,
      splashTransition: SplashTransition.scaleTransition,
      pageTransitionType: PageTransitionType.fade,
      backgroundColor: const Color(0xFF1B5E20),
    );
  }
}

/// ================= HOME PAGE =================
class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  const HomePage({super.key, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final String visi =
      "Menjadi lembaga pendidikan Islam unggulan yang berakhlak mulia dan berprestasi di bidang akademik dan non-akademik.";

  final List<String> misi = [
    "Meningkatkan kualitas pendidikan berbasis agama dan sains.",
    "Membentuk karakter siswa yang disiplin, kreatif, dan berakhlak mulia.",
    "Mengembangkan kegiatan ekstrakurikuler yang bermanfaat bagi siswa.",
    "Menjalin kerja sama dengan masyarakat dan instansi terkait."
  ];

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6)));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// ================= MENU BUTTON =================
  Widget _buildMenuButton(
      {required String title,
      required IconData icon,
      required Color color,
      required bool isDark,
      required String url}) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => WebPage(title: title, url: url)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: isDark ? Colors.black54 : Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 42, color: color),
            const SizedBox(height: 10),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black87)),
          ],
        ),
      ),
    );
  }

  /// ================= VISI & MISI CARD =================
  Widget _buildInfoCard(String text, bool isDark, {bool isVisi = false}) {
    return Card(
      color: isDark ? Colors.grey[850] : Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isVisi ? Icons.visibility_rounded : Icons.check_circle,
              color: isDark ? Colors.orangeAccent : Colors.orange,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                /// ================= HEADER =================
                Container(
                  height: 260,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF1B5E20),
                        Color(0xFF4CAF50),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(50)),
                  ),
                  child: SafeArea(
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/logo.png',
                                  height: 110,
                                ),
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'MA Sunan Prawoto',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 16,
                          child: IconButton(
                            icon: Icon(
                              isDark ? Icons.light_mode : Icons.dark_mode,
                              color: Colors.white,
                            ),
                            onPressed: widget.toggleTheme,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// ================= DESKRIPSI =================
                const PremiumCard(
                  child: Column(
                    children: [
                      Icon(Icons.school_rounded,
                          size: 46, color: Color(0xFF2E7D32)),
                      SizedBox(height: 12),
                      Text(
                        'Aplikasi Resmi MA Sunan Prawoto',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Layanan digital sekolah untuk presensi dan akses website resmi.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                /// ================= MENU PRESENSI & WEBSITE =================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildMenuButton(
                            title: 'Presensi Online',
                            icon: Icons.fingerprint_rounded,
                            color: Colors.green,
                            isDark: isDark,
                            url: 'https://presensi.masupra.sch.id'),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _buildMenuButton(
                            title: 'Website Sekolah',
                            icon: Icons.language_rounded,
                            color: Colors.blue,
                            isDark: isDark,
                            url: 'https://masupra.sch.id'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// ================= JUDUL VISI =================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Visi',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                /// ================= VISI CARD =================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildInfoCard(visi, isDark, isVisi: true),
                ),

                const SizedBox(height: 16),

                /// ================= JUDUL MISI =================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Misi',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                /// ================= MISI CARD =================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: misi
                        .map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: _buildInfoCard(item, isDark),
                            ))
                        .toList(),
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  '© 2026 MA Sunan Prawoto',
                  style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : Colors.grey),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ================= CARD =================
class PremiumCard extends StatelessWidget {
  final Widget child;
  const PremiumCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
              // ignore: deprecated_member_use
              color: isDark ? Colors.black54 : Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 6))
        ],
      ),
      child: child,
    );
  }
}

/// ================= WEBVIEW =================
class WebPage extends StatefulWidget {
  final String title;
  final String url;
  const WebPage({super.key, required this.title, required this.url});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setUserAgent(
          "Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 Chrome/120 Safari/537.36")
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            setState(() => isLoading = false);

            /// paksa reload image + lazy load fix
            controller.runJavaScript(
                "document.querySelectorAll('img').forEach(img => { img.loading='eager'; img.decoding='sync'; img.style.opacity='1'; });");
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.url),
        headers: {
          "Referer": widget.url,
          "Access-Control-Allow-Origin": "*",
        },
      );
  }

  /// HANDLE BACK BUTTON (ANDROID + APPBAR)
  Future<bool> _handleBack() async {
    if (await controller.canGoBack()) {
      controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _handleBack,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await controller.canGoBack()) {
                controller.goBack();
              } else {
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: controller),

            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
