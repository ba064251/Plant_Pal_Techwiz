import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/Admin/AdminHome.dart';
import 'package:testing/HomeScreen.dart';
import 'package:testing/RegisterScreen.dart';
import 'package:testing/reusable_widget/colors.dart';
import 'package:testing/reusable_widget/reusable_textformfield.dart';
import 'package:testing/reusable_widget/text_widget.dart';

import 'UserMain/main_home_navbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool ischeck = true;

  bool loader = false;

  final _email = TextEditingController();
  final _pass = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void loginuser()async{
    try{
      setState(() {
        loader = !loader;
      });
      UserCredential userCredential =  await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email.text.toString(), password: _pass.text.toString());
        if(FirebaseAuth.instance.currentUser!.email=="admin@gmail.com"){
          setState(() {
            loader = !loader;
          });
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminScreen(),));
        }
        else{
          SharedPreferences user = await SharedPreferences.getInstance();
          user.setString("email", _email.text.toString());
          setState(() {
            loader = !loader;
          });
          Navigator.push(context, MaterialPageRoute(builder: (context) => MainHome(),));
        }
      } on FirebaseAuthException catch(ex){
      setState(() {
        loader = !loader;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ex.code.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [

                ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(250)),
                  child: Container(
                    width: double.infinity,
                    height: 240,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('images/register.jpg'))
                    ),
                  ),
                ),

                const SizedBox(
                  height: 60,
                ),

                Center(
                  child: text_custome(
                    color: MyColors.heading_color,
                    fontWeight: FontWeight.w600,
                    size: 24,
                    text: "Welcome Back",
                  ),
                ),

                const SizedBox(height: 40,),

                // Text Fields


                Form(
                    key: _key,
                    child: Column(

                  children: [
                    custom_field(label: "Enter Your Email",controller: _email,Errormsg: "Email is Required", prefixicon: const Icon(Iconsax.message_notif), surfixneed: false),

                    const SizedBox(height: 20,),

                    custom_field(label: "Enter Your Password",controller: _pass,Errormsg:  "Password is Required", prefixicon: const Icon(Iconsax.key), surfixneed: true,surfixIcon: IconButton(onPressed: (){setState(() {
                      ischeck = !ischeck;
                    });},icon: ischeck==false?const Icon(Iconsax.password_check):const Icon(Icons.remove_red_eye)),ispassword: ischeck==false?false:true,),


                    const SizedBox(height: 20,),

                    GestureDetector(
                      onTap: (){
                       if(_key.currentState!.validate()){
                          loginuser();
                       }
                      },
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: MyColors.button_color
                        ),
                        child:  Center(child: loader==false?text_custome(text: "Login", size: 14, fontWeight: FontWeight.w400,color: Colors.white):const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: CircularProgressIndicator(color: Colors.white,),
                        ),),
                      ),
                    ),
                  ],
                )),

                const SizedBox(height: 20,),

                GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const REgisterScreen(),));
                    },
                    child: text_custome(text: "Create An Account", size: 14, fontWeight: FontWeight.w300))

              ],
            ),
          ),
        ),
      ),
    );
  }
}




