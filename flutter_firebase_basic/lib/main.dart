import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_basic/components/routes.dart';
import 'package:flutter_firebase_basic/screens/classroom/home_classroom.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
    apiKey: "AIzaSyAWXfcrNOFisCPCiUCB3ovTcNM09UoIL4Y",
    appId: "1:26625192605:android:a2c44f50f02161bf2d1a74",
    messagingSenderId: "26625192605",
    projectId: "flutterbasicapp-28150",
    storageBucket: "flutterbasicapp-28150.appspot.com",
  ));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: HomeClassroom(),
      initialRoute: HomeClassroom.routeName,
        //initialRoute: SignInScreen.routeName,
        //initialRoute: ProfileScreen.routeName,
        //initialRoute: HomeScreen.routeName,
      routes: routes,
    );
  }
}
