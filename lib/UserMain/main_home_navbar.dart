import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:testing/PageView/editProfile.dart';
import 'package:testing/UserMain/AccessoriesScreen.dart';
import 'package:testing/UserMain/main_screen.dart';
import 'package:testing/UserMain/helpMenu.dart';
import '../ContactScreen.dart';
import '../reusable_widget/colors.dart';


class MainHome extends StatefulWidget {

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {



  @override

  int selected_page = 0;

  void _pageshifter(int index){
    setState(() {
      selected_page = index;
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
        body: page[selected_page],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          child: GNav(
            tabBackgroundColor: MyColors.background_color.withOpacity(0.4),
            activeColor: MyColors.heading_color,
            gap: 6,
            curve: Curves.easeInExpo,
            selectedIndex: selected_page,
            onTabChange: _pageshifter,
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 14),
            tabs: [
              const GButton(
                  text: "Plants",
                  icon: Icons.energy_savings_leaf),
              const GButton(
                  text: "Accessories",
                  icon: Iconsax.share),
              const GButton(
                  text: "FeedBack",
                  icon: Iconsax.receipt_item),
              const GButton(
                  text: "Profile",
                  icon: Iconsax.user),
            ],
          ),
        ),
      ),
    );
  }
}
