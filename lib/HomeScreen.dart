import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testing/LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void signout()async{
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: GestureDetector(
          onTap: (){
            setState(() {
              signout();
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
            });
          },
          child: const Text("Home")),),
    );
  }
}
