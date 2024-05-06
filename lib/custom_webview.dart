import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class CustomWebView extends StatefulWidget {
  final String url;
  final List<String>? urlLauncher;
  const CustomWebView(this.url, {this.urlLauncher, super.key});

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  late bool isPDFAndroid;
  late final WebViewController _controller;

  late File pFile;
  bool isLoading = false;

  Future<void> loadNetwork() async {
    setState(() {
      isLoading = true;
    });
    var url = widget.url;
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    if (mounted) {
      setState(() {
        pFile = file;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    isPDFAndroid = widget.url.contains(".pdf", widget.url.length - 5) &&
        Platform.isAndroid;
    super.initState();
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: false,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{
            PlaybackMediaTypes.audio,
            PlaybackMediaTypes.video
          },
          limitsNavigationsToAppBoundDomains: true);
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          if (widget.urlLauncher != null) {
            if (widget.urlLauncher!.contains(request.url)) {
              openURL(request.url);
              return NavigationDecision.prevent;
            }
          }
          return NavigationDecision.navigate;
        },
      ));
    _controller = controller;
    if (isPDFAndroid) {
      loadNetwork();
    } else {
      _controller.loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return isPDFAndroid
        ? isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              )
            : PDFView(
                filePath: pFile.path,
                autoSpacing: false,
                fitPolicy: FitPolicy.BOTH,
              )
        : WebViewWidget(controller: _controller);
  }

  Future<void> openURL(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
