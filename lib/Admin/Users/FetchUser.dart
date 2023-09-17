import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:testing/Admin/Users/AddUser.dart';
import 'package:testing/Admin/Users/UpdateUser.dart';
import 'package:testing/LoginScreen.dart';

import '../../reusable_widget/colors.dart';
import '../../reusable_widget/text_widget.dart';

class UserFetch extends StatefulWidget {
  const UserFetch({super.key});

  @override
  State<UserFetch> createState() => _UserFetchState();
}

class _UserFetchState extends State<UserFetch> {

  // Default Selected Value to display all data based on Gender -> All
  var gender = "All";

  // SignOut Method For Admin
  void signout()async{
    await FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder:  (context) => const LoginScreen(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Floating Button redirect to Login Screen

        floatingActionButton: FloatingActionButton(
            onPressed: (){
              signout();
              },
            child: const Center(child: Icon(Iconsax.login,color: Colors.white,),),
            backgroundColor:Colors.red.shade600),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 20,),

                // Fetch User Heading

                text_custome(text: "Fetching User", size: 16, fontWeight: FontWeight.w600),
                const SizedBox(height: 20,),

                // Filtering Button Based on Gender
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap:(){
                          setState(() {
                            gender = "All";
                          });
                        },
                        child: Container(
                          width: 80,
                          height: 30,
                          decoration: BoxDecoration(
                              border:Border.all(color: gender=="All"?Colors.black:Colors.transparent),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Center(child: text_custome(text: "All", size: 14, fontWeight: FontWeight.w600),),
                        ),
                      ),

                      GestureDetector(
                        onTap:(){
                          setState(() {
                            gender = "Male";
                          });
                        },
                        child: Container(
                          width: 80,
                          height: 30,
                          decoration: BoxDecoration(
                            border:Border.all(color: gender=="Male"?Colors.black:Colors.transparent),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Center(child: text_custome(text: "Male", size: 14, fontWeight: FontWeight.w600),),
                        ),
                      ),

                      const SizedBox(width: 14,),

                      GestureDetector(
                        onTap: (){
                          setState(() {
                            gender = "Female";
                          });
                        },
                        child: Container(
                          width: 80,
                          height: 30,
                          decoration: BoxDecoration(
                              border:Border.all(color: gender=="Female"?Colors.black:Colors.transparent),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Center(child: text_custome(text: "Female", size: 14, fontWeight: FontWeight.w600),),
                        ),
                      )
                    ],
                  ),
                ),
                
                const SizedBox(height: 20,),


                // Getting User From Firebase Firestore based on Gender
                StreamBuilder(
                  stream: gender=="Male"?FirebaseFirestore.instance.collection("Users").where('User-Gender',isEqualTo: 'Male').snapshots():
                  gender=="All"?FirebaseFirestore.instance.collection("Users").snapshots():FirebaseFirestore.instance.collection("Users").where('User-Gender',isEqualTo: 'Female').snapshots(),
                  builder: (context, snapshot) {
                    var userLength = snapshot.data!.docs.length;
                    if(snapshot.hasData){
                      return userLength!=0?ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const ScrollPhysics(),
                        itemCount: userLength,
                        itemBuilder: (context, index) {

                          // Fetchin Data

                          var usermap = snapshot.data!.docs[index];
                          var email = snapshot.data!.docs[index]["User-Email"];
                          var name= snapshot.data!.docs[index]["User-Name"];
                          var pass = snapshot.data!.docs[index]["User-Password"];
                          var age = snapshot.data!.docs[index]["User-Age"];
                          var gender = snapshot.data!.docs[index]["User-Gender"];
                          String? image = snapshot.data!.docs[index]["User-Image"];

                          // Getting ID

                          var user_id = snapshot.data!.docs[index].id;
                          // Main Container
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: MyColors.background_color.withOpacity(0.4),
                            ),
                            child: Row(
                              children: [

                                const SizedBox(width: 10,),

                                // Image Container

                                Container(
                                  width: 80,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      color: MyColors.button_color,
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: image==null?const NetworkImage(''):NetworkImage(image))
                                  ),
                                ),

                                const SizedBox(width: 10,),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Name
                                    SizedBox(
                                      width: 120,
                                      height: 24,
                                      child: text_custome(text: "${usermap["User-Name"]}", size: 18, fontWeight: FontWeight.w600),
                                    ),

                                    const SizedBox(height: 3,),
                                    // Email

                                    SizedBox(
                                      width: 120,
                                      height: 20,
                                      child: text_custome(text: "${usermap["User-Email"]}", size: 14, fontWeight: FontWeight.w600),
                                    ),


                                    const SizedBox(height: 3,),
                                    // Gender

                                    SizedBox(
                                      width: 120,
                                      height: 24,
                                      child: text_custome(text: "${usermap["User-Gender"]}", size: 14, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),

                                const SizedBox(width: 34,),

                                // Update Button

                                GestureDetector(
                                  onTap: (){
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Updated")));
                                  },
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserUpdate(id: user_id,email: email, name: name, pass: pass, age: age, gender: gender,image: image!,),));
                                    },
                                    child: Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white
                                      ),
                                      child: Center(child:Icon(Iconsax.refresh,color: MyColors.heading_color,),),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 6,),

                                // Delete Button

                                GestureDetector(
                                  onTap: ()async{
                                    await FirebaseFirestore.instance.collection("Users").doc(user_id).delete();
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Deleted")));
                                  },
                                  child: Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white
                                    ),
                                    child: Icon(Icons.delete,color: Colors.red.shade400,),),
                                ),
                              ],
                            ),
                          );
                        },):Container(
                          margin: const EdgeInsets.only(top: 300),
                          child: Center(child: text_custome(text: "Nothing to Show", size: 14, fontWeight: FontWeight.w600,color: MyColors.heading_color,),));
                    }
                    if(snapshot.hasError){
                      return const Center(child: Icon(Icons.error),);
                    }
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const CircularProgressIndicator();
                    }
                    return Container();

                  },)
              ],
            ),
          ),
        )
    );
  }
}
