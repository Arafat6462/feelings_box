import 'package:flutter/material.dart';

void main() {
  runApp(const FeelingsApp());
}

class FeelingsApp extends StatelessWidget {
  const FeelingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feelings App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feelings Box'),
      ),
      body: const Center(
        child: Text(
          '🧠 Ready to build your Feelings App!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
