
import 'package:flutter/material.dart';
import 'package:todo_app/layout/app_layout.dart';


void main() async {


  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      home: AppLayout(),
    );
  }
}
