import 'package:flutter/material.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: DemoNetwork(),
        ),
      ),
    );
  }
}

class DemoNetwork extends StatefulWidget {
  const DemoNetwork({super.key});
  @override
  State<StatefulWidget> createState() {
    return _DemoNetworkState();
  }
}

class _DemoNetworkState extends State<DemoNetwork> {
  String title="";

  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$title",
            style: TextStyle(fontSize: 20),
          ),
          ElevatedButton(
            onPressed: (){},
             child: Text("Make request", style: TextStyle(color: Colors.white),),
             style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              elevation: 0
             ),
          )
        ],
      ),
    );
  }
}


