import 'package:flutter/material.dart';
import 'package:testing/PageView/pageViewWidget.dart';
class pageView1 extends StatefulWidget {
  const pageView1({super.key});

  @override
  State<pageView1> createState() => _pageView1State();
}

class _pageView1State extends State<pageView1> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          top: true,
          child: pageView1Body()),
    );
  }
}
class pageView1Body extends StatefulWidget {
  const pageView1Body({super.key});

  @override
  State<pageView1Body> createState() => _pageView1BodyState();
}

class _pageView1BodyState extends State<pageView1Body> {
  @override
  Widget build(BuildContext context) {
    return pageViewWidget(
      jsonPath: 'images/guide.json',
      text: "Welcome to Plantix: Grow with Us!",
    );
  }
}



