import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:testing/PageView/editProfile.dart';
import 'package:testing/UserMain/AccessoriesScreen.dart';
import 'package:testing/UserMain/main_screen.dart';
import '../ContactScreen.dart';
import '../reusable_widget/colors.dart';


class MainHome extends StatefulWidget {

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {



  @override

  int selectedPage = 0;

  void pageShifter(int index){
    setState(() {
      selectedPage = index;
    });
  }

  final List<Widget> page = [
    main_screen(),
    const AccessoriesScreen(),
    const ContactScreen(),
    const EditProfile(),
  ];
  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async {
        // Close the application on back press
          SystemNavigator.pop();
          return true;
      },
      child: Scaffold(
        body: page[selectedPage],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          child: GNav(
            tabBackgroundColor: MyColors.background_color.withOpacity(0.4),
            activeColor: MyColors.heading_color,
            gap: 6,
            curve: Curves.easeInExpo,
            selectedIndex: selectedPage,
            onTabChange: pageShifter,
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 14),
            tabs: const [
              GButton(
                  text: "Plants",
                  icon: Icons.energy_savings_leaf),
              GButton(
                  text: "Accessories",
                  icon: Iconsax.share),
              GButton(
                  text: "FeedBack",
                  icon: Iconsax.receipt_item),
              GButton(
                  text: "Profile",
                  icon: Iconsax.user),
            ],
          ),
        ),
      ),
    );
  }
}
