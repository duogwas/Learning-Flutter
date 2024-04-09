import 'package:flutter/material.dart';
import 'package:flutter_firebase_basic/screens/classroom/home_classroom.dart';
import 'package:flutter_firebase_basic/screens/teacher/home_teacher.dart';

final Map<String, WidgetBuilder> routes = {
  HomeTeacher.routeName: (context) => const HomeTeacher(),
  HomeClassroom.routeName: (context) => const HomeClassroom(),
};
