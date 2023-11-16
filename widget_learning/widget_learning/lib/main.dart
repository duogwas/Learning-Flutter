import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: const Text('Widget Learning'),
        ),
        body: const Center(
          // child: Text('Hello world'),
          child: MyWidget(true),
        ),
      )),
      debugShowCheckedModeBanner: false,
    );
  }
}

//state: trang thai cua input dau vao
class MyWidget extends StatelessWidget {
  final bool loading;
  const MyWidget(this.loading);

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const CircularProgressIndicator();
    } else {
      return const Text('State');
    }
  }
}
