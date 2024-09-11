import 'package:flutter/material.dart';
import 'index/index.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Landing(),
    );
  }
}

class User {
  User({
    required this.id,
    required this.fName,
    required this.lName,
    required this.hobbies,
    required this.age,
  });

  int id;
  String fName;
  String lName;
  String hobbies;
  int age;
}