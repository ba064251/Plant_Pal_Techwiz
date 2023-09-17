import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/LoginScreen.dart';
import 'package:testing/reusable_widget/colors.dart';
class helpMenu extends StatefulWidget {
  const helpMenu({super.key});

  @override
  State<helpMenu> createState() => _helpMenuState();
}

class _helpMenuState extends State<helpMenu> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: SingleChildScrollView(child: HelpMenuBody())),
    );
  }
}
class HelpMenuBody extends StatefulWidget {
  const HelpMenuBody({super.key});

  @override
  State<HelpMenuBody> createState() => _HelpMenuBodyState();
}

class _HelpMenuBodyState extends State<HelpMenuBody> {
  void signout()async{
    await FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder:  (context) => const LoginScreen(),));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      child: Column(

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:[ IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back_ios_new_outlined,size: 20,)),
           ]
        ),
          GestureDetector(
            onTap: (){
              signout();
            },
            child: Text("Help Menu",style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: MyColors.heading_color
            ),),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: const DecorationImage(
                image: AssetImage('images/help.png')
              )
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          question(
            question1: 'This is question 1',
            answer: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum',
          ),
          question(
            question1: 'This is question 1',
            answer: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum',
          ),
          question(
            question1: 'This is question 1',
            answer: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum',
          ),
          question(
            question1: 'This is question 1',
            answer: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum',
          ),
          question(
            question1: 'This is question 1',
            answer: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum',
          ),
        ],
      ),
    );
  }
}

class question extends StatelessWidget {
String question1;
String answer;


question({required this.question1, required this.answer});

@override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ExpansionTile(title: Text(question1,style: GoogleFonts.poppins(
        fontSize: 16,

      ),),
      backgroundColor: MyColors.help_menu,
      collapsedBackgroundColor: MyColors.card_light_color2,
      iconColor: Colors.white,
      textColor: Colors.white,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 10),
          child: Text(answer,style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white
          ),
          textAlign: TextAlign.justify,
          ),

        )
      ],
      ),
    );
  }
}

