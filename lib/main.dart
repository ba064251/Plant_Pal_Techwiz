import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/Admin/Plant/AddPlant.dart';
import 'package:testing/Admin/Plant/FetchPlant.dart';
import 'package:testing/HomeScreen.dart';
import 'package:testing/LoginScreen.dart';
import 'package:testing/PageView/mainPageView.dart';
import 'package:testing/RegisterScreen.dart';
import 'package:testing/firebase_options.dart';

import 'Admin/AdminHome.dart';
import 'Admin/Users/FetchUser.dart';
import 'UserMain/main_home_navbar.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  var val;

  // Splash Screen Timer Setting


  void skipping_pageview()async{
    SharedPreferences onetime = await SharedPreferences.getInstance();
    val = onetime.get("done");
  }

  @override
  void initState(){
    // TODO: implement initState
    skipping_pageview();
    Timer(
        const Duration(seconds: 5),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => val==true?(FirebaseAuth.instance.currentUser!=null)?(FirebaseAuth.instance.currentUser!.email=="admin@gmail.com")?const AdminScreen():MainHome():const LoginScreen():const main_pageView())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Logo Section

      body: Center(
        child: Container(
          width: 290,
          height: 290,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("images/logo.png"))
          ),


        ),
      ),
    );
  }
}
