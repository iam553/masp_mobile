import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;

  const WebViewPage({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;

  bool isLoading = true;

  /// 🔥 PENYELAMAT MASALAH BACK
  final List<String> history = [];

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true)

      /// WAJIB supaya WebView detect perpindahan halaman
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            history.add(url);
            setState(() => isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => isLoading = false);
          },
        ),
      )

      ..loadRequest(Uri.parse(widget.url));
  }

  /// 🔥 LOGIC BACK PALING STABIL
  Future<bool> _goBack() async {
    if (await controller.canGoBack()) {
      controller.goBack();
      return false;
    }

    /// fallback kalau website pakai JS navigation
    if (history.length > 1) {
      history.removeLast();
      controller.loadRequest(Uri.parse(history.last));
      return false;
    }

    return true; // baru keluar ke home
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (await _goBack()) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _goBack()) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: controller),

            if (isLoading)
              const LinearProgressIndicator(minHeight: 3),
          ],
        ),
      ),
    );
  }
}
