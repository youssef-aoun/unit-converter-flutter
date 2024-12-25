import 'package:flutter/material.dart';
import 'dart:io';
import 'home.dart';

// Override the default HttpClient to bypass SSL validation for development
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;  // Bypass SSL validation
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();  // Apply the custom HttpOverrides
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Homepage',
      debugShowCheckedModeBanner: false,
      home: HomePage(title: 'Homepage'),
    );
  }
}
