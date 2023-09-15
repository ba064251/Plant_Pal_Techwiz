import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testing/LoginScreen.dart';

import '../../reusable_widget/text_widget.dart';

class DetailSiteMap extends StatefulWidget {
  const DetailSiteMap({super.key});

  @override
  State<DetailSiteMap> createState() => _DetailSiteMapState();
}

class _DetailSiteMapState extends State<DetailSiteMap> {

  void signout()async{
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
            onTap: (){
              signout();
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
            },
            child: text_custome(text: "SiteMap Panel", size: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
