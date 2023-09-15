import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/PageView/pageView1.dart';
import 'package:testing/PageView/pageView2.dart';
import 'package:testing/PageView/pageView3.dart';

import '../RegisterScreen.dart';

class main_pageView extends StatefulWidget {
  const main_pageView({super.key});

  @override
  State<main_pageView> createState() => _main_pageViewState();
}

class _main_pageViewState extends State<main_pageView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          top: true,
          child: PageViewBody()),
    );
  }
}

class PageViewBody extends StatefulWidget {
  const PageViewBody({super.key});

  @override
  State<PageViewBody> createState() => _PageViewBodyState();
}

class _PageViewBodyState extends State<PageViewBody> {
  bool lastPage = false;
  PageController _controller = PageController();

  void OneTimeScreen()async{
    SharedPreferences onetime = await SharedPreferences.getInstance();
    onetime.setBool("done", true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                lastPage = (index == 2);
              });
            },
            children: [
              const pageView1(),
              const pageView2(),
              const pageView3(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white
                    ),
                    onPressed: () {
                      _controller.jumpToPage(2);
                    },
                    child: Text('Skip',
                        style: GoogleFonts.poppins(color: const Color(0xff5C941B)))),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const WormEffect(
                      dotColor: Colors.grey, activeDotColor: Color(0xff33961E)),
                ),
                lastPage
                    ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white
                  ),
                        onPressed: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.linear);
                          OneTimeScreen();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const REgisterScreen(),));
                        },
                        child: Text(
                          'Done',
                          style: GoogleFonts.poppins(color: const Color(0xff5C941B)),
                        ))
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white
                  ),
                        onPressed: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.linear);
                        },
                        child: Text('Next',
                            style:
                                GoogleFonts.poppins(color: const Color(0xff5C941B)))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
