import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: SafeArea(child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: const Text ('Widget Learning'),
        ),
        body: const Center(
          child: Text('Hello world'),
        ),
      )),
      debugShowCheckedModeBanner: false,
    );
  }
}
