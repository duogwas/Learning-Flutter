import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateless widget'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Home page'),
              MyStateFullWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class MyStateFullWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyStateFullWidgetState();
  }
}

class _MyStateFullWidgetState extends State<MyStateFullWidget> {
  int _count = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Text(
          '$_count',
          style: const TextStyle(fontSize: 25),
        ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                _count++;
              });
            },
            child: const Text('Click me'),)
      ],
    ));
  }
}
