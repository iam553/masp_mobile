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
  bool loading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() {
              loading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  /// ✅ HANDLE TOMBOL BACK ANDROID
  // ignore: unused_element
  Future<bool> _onWillPop() async {
    if (await controller.canGoBack()) {
      controller.goBack();
      return false; // jangan keluar app
    }
    return true; // keluar halaman
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) async {
        if (didPop) return;

        if (await controller.canGoBack()) {
          controller.goBack();
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),

          /// ✅ TOMBOL BACK DI APPBAR
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

          actions: [
            /// 🔥 tombol refresh (bonus biar keren)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                controller.reload();
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: controller),

            if (loading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
