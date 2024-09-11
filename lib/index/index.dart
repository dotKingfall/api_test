import 'package:apitesting/index/user_card.dart';
import 'package:apitesting/index/user_list.dart';
import "package:flutter/material.dart";
import '../style.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          color: Colors.grey[800],
          height: 150,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "API Testing",
              style: title,
            ),
          ),
        ),
      ),
      body: const Row(
        children: [
          UserCard(),
          UserList(),
        ],
      ),
    );
  }
}