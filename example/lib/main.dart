import 'package:custom_webview/custom_webview.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// list url will open Launcher
  List<String> urlLauncher = [
    'https://play.google.com',
    'https://apps.apple.com'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: CustomWebView(
            'https://pub-e1c1c97ce246453790aed20554092539.r2.dev/ATTACHMENTS/a0G1e000005dbx6EAA/Tho%CC%82ng-bao-cap-nhat-phien-ba-1.0.4.pdf',
            urlLauncher: urlLauncher));
  }
}
