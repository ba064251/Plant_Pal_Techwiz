import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/reusable_widget/colors.dart';

import '../LoginScreen.dart';
class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          top: true,
          child: EditProfileBody()),
    );
  }
}
class EditProfileBody extends StatefulWidget {
  const EditProfileBody({super.key});

  @override
  State<EditProfileBody> createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<EditProfileBody> {

  void signout()async{
    await FirebaseAuth.instance.signOut();
    SharedPreferences user = await SharedPreferences.getInstance();
    user.clear();
    Navigator.push(context, MaterialPageRoute(builder:  (context) => const LoginScreen(),));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(

          margin: const EdgeInsets.symmetric(horizontal: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              const SizedBox(
                height: 40,
              ),
              Text("Edit Profile",style: GoogleFonts.poppins(
                color: const Color(0xff386a24),
                fontSize: 24,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage('https://pbs.twimg.com/media/FjU2lkcWYAgNG6d.jpg'),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Saad',style: GoogleFonts.poppins(
                          fontSize: 14
                        ),),
                        Text('saad123@gmail.com',style: GoogleFonts.poppins(
                            fontSize: 14
                        ),),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xff98e3ac),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.edit),
                              const SizedBox(width: 5,),
                              Text("Edit Profile",style: GoogleFonts.poppins(
                                  fontSize: 14
                              ),)
                            ],
                          ),
                        )
                        // ListTile(
                        //   leading: Icon(Icons.edit),
                        //   title: Text("Edit Profile"),
                        // )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              EditProfileWidget(
                text: "Your Cart",
                icon: Iconsax.shopping_cart,
                 color: MyColors.background_color.withOpacity(0.4),
              ),
              const SizedBox(
                height: 30,
              ),
              EditProfileWidget(
                text: "Delete Your Account",
                icon: Iconsax.trash,
                color: Colors.red.shade600,
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: (){
                  signout();
                },
                child: EditProfileWidget(
                  text: "SignOut",
                  icon: Iconsax.login,
                  color: Colors.red.shade600,
                ),
              ),

              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfileWidget extends StatelessWidget {
 IconData icon;
 String text;
 Color color;


 EditProfileWidget({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 20,),
            Expanded(
              child: Text('$text',style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600
              ),),
            )
          ],
        ),
      ),
    );
  }
}

