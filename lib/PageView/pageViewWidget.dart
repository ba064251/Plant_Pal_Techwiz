import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:testing/reusable_widget/text_widget.dart';
class pageViewWidget extends StatelessWidget {
  String jsonPath;
  String text;


  pageViewWidget({required this.jsonPath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              child: Lottie.asset('$jsonPath',

              ),
            ),
            const SizedBox(
              height: 20,
            ),
            text_custome(text: text, size: 14, fontWeight: FontWeight.w600)
          ],
        ),
      ),
    );
  }
}