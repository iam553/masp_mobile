import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  /// 🔥 INI YANG PALING PENTING
  Future<bool> _onWillPop() async {
    if (await controller.canGoBack()) {
      controller.goBack(); // mundur di web
      return false; // jangan keluar halaman
    }
    return true; // kalau sudah mentok, baru keluar
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop, // intercept tombol back
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
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
