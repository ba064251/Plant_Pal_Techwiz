import 'package:flutter/material.dart';
import 'package:testing/PageView/pageViewWidget.dart';
class pageView2 extends StatefulWidget {
  const pageView2({super.key});

  @override
  State<pageView2> createState() => _pageView2State();
}

class _pageView2State extends State<pageView2> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          top: true,
          child: pageView2Body()),
    );
  }
}
class pageView2Body extends StatefulWidget {
  const pageView2Body({super.key});

  @override
  State<pageView2Body> createState() => _pageView2BodyState();
}

class _pageView2BodyState extends State<pageView2Body> {
  @override
  Widget build(BuildContext context) {
    return pageViewWidget(
      jsonPath: 'images/plant.json',
      text: 'Plantixs Plant Care Wisdom at Your Fingertips',
    );
  }
}

