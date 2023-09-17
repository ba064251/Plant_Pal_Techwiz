import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:testing/Admin/Accessories/FetchAccessories.dart';
import 'package:testing/Admin/FeedBack/FeedBackView.dart';
import 'package:testing/Admin/Plant/FetchPlant.dart';
import 'package:testing/Admin/Users/FetchUser.dart';
import 'package:testing/reusable_widget/colors.dart';

import '../LoginScreen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  int selectedPage = 0;

  void _pageshifter(int index){
    setState(() {
      selectedPage = index;
    });
  }

  final List<Widget> page = [
    const UserFetch(),
    const PLantFetch(),
    const AccessFetch(),
    const ViewFeedBack(),
  ];

  void signout()async{
    await FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder:  (context) => const LoginScreen(),));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
      // Close the application on back press
        signout();
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
            onTabChange: _pageshifter,
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 14),
            tabs: const [
              GButton(
                  text: "Users",
                  icon: Iconsax.user_search),
              GButton(
                  text: "Plants",
                  icon: Icons.energy_savings_leaf),
              GButton(
                  text: "Accessories",
                  icon: Iconsax.share),
              GButton(
                  text: "Feedback",
                  icon: Iconsax.receipt_item),
            ],
          ),
        ),
      ),
    );
  }
}


