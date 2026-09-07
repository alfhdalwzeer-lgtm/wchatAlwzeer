import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Al-Wazir Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Al-Wazir Chat'),
        ),
        body: const Center(
          child: Text(
            'Welcome to Al-Wazir Chat!',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
