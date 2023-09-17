import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/Wishlist.dart';
import 'package:testing/reusable_widget/colors.dart';

import '../AddtoCart.dart';
import '../Admin/Users/UpdateUser.dart';
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

  String userId = ' ';

  _getUser() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    var id = user.getString('email');
    return id;
  }

  @override
  void initState() {
    _getUser().then((id) {
      //calling setState will refresh your build method.
      setState(() {
        userId = id;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Users").where('User-Email',isEqualTo: userId).snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              var userLength = snapshot.data!.docs.length;
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: userLength,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {

                  var userId = snapshot.data!.docs[index];
                  var email = snapshot.data!.docs[index]["User-Email"];
                  var name= snapshot.data!.docs[index]["User-Name"];
                  var pass = snapshot.data!.docs[index]["User-Password"];
                  var age = snapshot.data!.docs[index]["User-Age"];
                  var gender = snapshot.data!.docs[index]["User-Gender"];
                  String? image = snapshot.data!.docs[index]["User-Image"];

                  return Container(

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
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(image!),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name,style: GoogleFonts.poppins(
                                      fontSize: 14
                                  ),),
                                  Text(email,style: GoogleFonts.poppins(
                                      fontSize: 14
                                  ),),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 120,
                                    padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xff98e3ac),
                                    ),
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => UserUpdate(id: userId,email: email, name: name, pass: pass, age: age, gender: gender,image: image,),));
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(Iconsax.edit,color: Colors.white,),
                                          const SizedBox(width: 5,),
                                          Text("Edit Profile",style: GoogleFonts.poppins(
                                              fontSize: 14,
                                            color: Colors.white
                                          ),)
                                        ],
                                      ),
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
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen(),));
                          },
                          child: EditProfileWidget(
                            text: "Your Cart",
                            icon: Iconsax.shopping_cart,
                            color: MyColors.background_color.withOpacity(0.4),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const WishListScreen(),));
                          },
                          child: EditProfileWidget(
                            text: "Your Wishlist",
                            icon: Iconsax.heart,
                            color: MyColors.background_color.withOpacity(0.4),
                          ),
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
                  );
                },);
              } if (snapshot.hasError) {
                return const Icon(Icons.error_outline);
              } if(snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return Container();
            }),
      ),
    );
  }
}

class EditProfileWidget extends StatelessWidget {
 IconData icon;
 String text;
 Color color;


 EditProfileWidget({super.key, required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 20,),
            Expanded(
              child: Text(text,style: GoogleFonts.poppins(
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

