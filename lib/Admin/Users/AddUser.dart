import 'package:flutter/material.dart';
import 'package:testing/reusable_widget/text_widget.dart';

class UserAdd extends StatefulWidget {
  const UserAdd({super.key});

  @override
  State<UserAdd> createState() => _UserAddState();
}

class _UserAddState extends State<UserAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: text_custome(text: "Users Panel", size: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
