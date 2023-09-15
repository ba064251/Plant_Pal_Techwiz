import 'package:flutter/material.dart';
import 'package:testing/PageView/pageViewWidget.dart';
class pageView3 extends StatefulWidget {
  const pageView3({super.key});

  @override
  State<pageView3> createState() => _pageView3State();
}

class _pageView3State extends State<pageView3> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          top: true,
          child: pageView3Body()),
    );
  }
}
class pageView3Body extends StatefulWidget {
  const pageView3Body({super.key});

  @override
  State<pageView3Body> createState() => _pageView3BodyState();
}

class _pageView3BodyState extends State<pageView3Body> {
  @override
  Widget build(BuildContext context) {
    return pageViewWidget(
      jsonPath: 'images/guide1.json',
      text: 'Elevate Plant Experience with Our Shop',
    );
  }
}

