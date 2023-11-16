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
          // child: MyWidget(true),
          child: MyWidget2(false),
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

class MyWidget2 extends StatefulWidget {
  final bool loading;
  const MyWidget2(this.loading);

  @override
  State<StatefulWidget> createState() {
    return MyWidget2State();
  }
}

class MyWidget2State extends State<MyWidget2> {
  late bool _localloading;

  //khoi tao gia tri truoc build
  @override
  void initState() {
    _localloading = widget.loading;
  }

  //build
  @override
  Widget build(BuildContext context) {
    return _localloading ? const CircularProgressIndicator() : FloatingActionButton(onPressed: onPressed);
  }

  void onPressed(){
    setState(() {
      _localloading=true;
    });
  }
  
}
