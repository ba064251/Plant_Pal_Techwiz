import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../LoginScreen.dart';
import '../../reusable_widget/colors.dart';
import '../../reusable_widget/reusable_textformfield.dart';
import '../../reusable_widget/text_widget.dart';

class UserUpdate extends StatefulWidget {

  var id;
  String email;
  String name;
  String pass;
  String age;
  String gender;
  String? image;

  // Getting User Data

  UserUpdate(
      {required this.id, required this.email, required this.name, required this.pass, required this.age, required this.gender,this.image});

  @override
  State<UserUpdate> createState() => _UserUpdateState(id: id);
}

class _UserUpdateState extends State<UserUpdate> {

  var id;


  // Getting User ID to Update data
  _UserUpdateState({required this.id});

  // Password obsecure check
  bool ischeck = true;

  //TextEditing Controllers for TextForm Fields
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _pass = TextEditingController();
  final _age = TextEditingController();
  final _gender = TextEditingController();

  //File For Image
  File? Profilepic;

  // Getting image DownloadUrl From Firebase Storage
  String DownloadUrl = '';

  // Default Selected DropDown Value
  String? selectedGender;

  // Form Validation Key
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  // Displaying Text in Fields on Scaffold Launch
  @override
  void initState() {
    // TODO: implement initState
    _email.text = widget.email;
    _name.text = widget.name;
    _pass.text = widget.pass;
    _age.text = widget.age;
    DownloadUrl = widget.image!;
    selectedGender = widget.gender;
    super.initState();
  }

  // Clearing Cache
  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _name.dispose();
    _pass.dispose();
    _age.dispose();
    _gender.dispose();
    super.dispose();
  }

  // Method to update user date
  Future imageupload()async{
    UploadTask uploadTask = FirebaseStorage.instance.ref().child("User-Images").child(const Uuid().v1()).putFile(Profilepic!);
    TaskSnapshot taskSnapshot = await uploadTask;
    DownloadUrl = await taskSnapshot.ref.getDownloadURL();
    updateuser(imgurl: DownloadUrl);
    if(widget.email!=_email && widget.pass!=_pass){
      registerUser();
    }
  }

// Method of User Update Data Details
  void updateuser({String? imgurl})async{
    await FirebaseFirestore.instance.collection("Users").doc(id).update({
      "User-Name":_name.text.toString(),
      "User-Gender":selectedGender,
      "User-Age":_age.text.toString(),
      "User-Email":_email.text.toString(),
      "User-Password":_pass.text.toString(),
      "User-Image":imgurl,
    });

    Navigator.pop(context);
  }

  void registerUser() async{
    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text.toString(), password: _pass.text.toString());

      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));

    }on FirebaseAuthException catch(ex){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${ex.code.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
          top: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 20,),

                // Image Picking and Displaying
                GestureDetector(
                    onTap: ()async{
                      XFile? selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if(selectedImage!=null){
                        File convertedFile = File(selectedImage.path);
                        setState(() {
                          Profilepic=convertedFile;
                        });
                      }    else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("No Image Selected")));
                      }},
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: (Profilepic!=null)?FileImage(Profilepic!):null,
                      foregroundImage: DownloadUrl!=null?NetworkImage(DownloadUrl):null,
                    )
                ),

                const SizedBox(
                  height: 30,
                ),

                Center(
                  child: text_custome(
                    color: MyColors.heading_color,
                    fontWeight: FontWeight.w600,
                    size: 24,
                    text: "Register Yourself",
                  ),
                ),

                const SizedBox(height: 20,),

                // TextFormFields of  Name -> Age -> Gender -> Email -> Password -> Update Button

                Form(
                    key: _key,
                    child: Column(
                  children: [
                    custom_field(label: "Enter Your FullName", controller: _name, prefixicon: const Icon(Iconsax.user), surfixneed: true),
                    const SizedBox(height: 10,),
                    custom_field(label: "Enter Your Age", controller: _age,keyboard: TextInputType.number , prefixicon: const Icon(Iconsax.calendar), surfixneed: true),
                    const SizedBox(height: 10,),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade300
                      ),
                      child: Center(
                        child: DropdownButtonFormField<String>(
                          value: selectedGender,
                          onChanged: (newValue) {
                            setState(() {
                              selectedGender = newValue!;
                            });
                          },
                          items: <String>['Male', 'Female']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: text_custome(text: value, size: 14, fontWeight: FontWeight.w400),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Iconsax.user_tick,color: Colors.black,),
                            focusColor: Colors.black,
                            focusedBorder: InputBorder.none,
                            iconColor: Colors.black,
                            label: text_custome(text: "Select Gender", size: 14, fontWeight: FontWeight.w400, color: Colors.black,),
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a gender';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    //custom_field(label: "Enter Your Gender", controller: _gender, prefixicon: const Icon(Icons.male), surfixneed: true),
                    const SizedBox(height: 10,),
                    custom_field(label: "Enter Your Email",controller: _email,keyboard: TextInputType.emailAddress ,Errormsg: "Email is Required", prefixicon: const Icon(Iconsax.message_notif), surfixneed: false),
                    const SizedBox(height: 10,),
                    custom_field(label: "Enter Your Password",controller: _pass,Errormsg:  "Password is Required", prefixicon: const Icon(Iconsax.key), surfixneed: true,surfixIcon: IconButton(onPressed: (){setState(() {
                      ischeck = !ischeck;
                    });},icon: ischeck==false?const Icon(Iconsax.password_check):const Icon(Icons.remove_red_eye)),ispassword: ischeck==false?false:true,),


                    const SizedBox(height: 20,),

                    GestureDetector(
                      onTap: (){
                        imageupload();
                      },
                      child: Container(
                        width: 130,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: MyColors.button_color
                        ),
                        child: Center(child: text_custome(text: "Update User", size: 14, fontWeight: FontWeight.w400,color: Colors.white),),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          )),
    );
  }
}
