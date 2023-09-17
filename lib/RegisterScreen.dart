import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing/LoginScreen.dart';
import 'package:testing/reusable_widget/colors.dart';
import 'package:testing/reusable_widget/reusable_textformfield.dart';
import 'package:testing/reusable_widget/text_widget.dart';
import 'package:uuid/uuid.dart';

class REgisterScreen extends StatefulWidget {
  const REgisterScreen({super.key});

  @override
  State<REgisterScreen> createState() => _REgisterScreenState();
}

class _REgisterScreenState extends State<REgisterScreen> {

  bool ischeck = true;

  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController gender = TextEditingController();
  File? Profilepic;
  String DownloadUrl = '';
  String selectedGender = 'Male';

  bool loader = false;

  final serviceId = 'service_w3jn09a';
  final templateId = 'template_gqcym6k';
  final userId = '16HPUTlRcbd96_yj1';
  final userSubject = 'PlantPal Registration';
  final userMessage = "We're absolutely thrilled to welcome you to the PlantPal family! \n"
      "Your decision to join us not only shows your love for plants but also your commitment to nurturing them, just like a true nature enthusiast\n"
      "Thank you for choosing PlantPal. Let's embark on this green adventure together and create a world filled with healthier, happier plants!\n"
      "Happy planting!";

  final GlobalKey<FormState> _key = GlobalKey<FormState>();


  Future imageupload()async{

    setState(() {
      loader = !loader;
    });

    UploadTask uploadTask = FirebaseStorage.instance.ref().child("User-Images").child(const Uuid().v1()).putFile(Profilepic!);
    TaskSnapshot taskSnapshot = await uploadTask;
    DownloadUrl = await taskSnapshot.ref.getDownloadURL();
    registerUser();
    addinguser(imgurl: DownloadUrl);
    emailSender();
    setState(() {
      loader = !loader;
    });
  }

  // Adding User
  void addinguser({String? imgurl})async{

    Map<String,dynamic> adduser ={
      "User-Name":name.text.toString(),
      "User-Gender":gender.text.toString(),
      "User-Age":selectedGender,
      "User-Email":email.text.toString(),
      "User-Password":pass.text.toString(),
      "User-Image": imgurl,
    };

    await FirebaseFirestore.instance.collection("Users").add(adduser);
    }

  Future emailSender()async{
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin':'http://localhost',
        'Content-Type':'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params':{
          'userName': name.text,
          'userEmail': 'plantpal@gmail.com',
          'toEmail': email.text,
          'userSubject': userSubject,
          'userMessage': userMessage,
        },
      }),
    );
    print(response);
  }

  //Registration User
  void registerUser() async{
    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.toString(), password: pass.text.toString());

      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));

    }on FirebaseAuthException catch(ex){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ex.code.toString())));
    }
  }
  //
  // void mail_sender()async{
  //   final Email email_sender = Email(
  //     body: "Thank you for choosing Plantix! We're delighted to have you as part of our community. Your account has been successfully created on our mobile app. Get ready to explore a world of plant care and gardening tips. Happy growing with Plantix!",
  //     subject: "Hey! Thanks For Creating An Account",
  //     recipients: ["${_email.text.toString()}"],
  //     cc: ["${_email.text.toString()}"],
  //     isHTML: false,
  //   );
  //
  //   try{
  //     await FlutterEmailSender.send(email_sender);
  //   }catch(error){
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${error.toString()}")));
  //   }
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    email.dispose();
    name.dispose();
    pass.dispose();
    age.dispose();
    gender.dispose();
    super.dispose();
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

                // Text Fields


                Form(
                    key: _key,
                    child: Column(
                  children: [
                    custom_field(label: "Enter Your FullName", controller: name,Errormsg: "Name is Required", prefixicon: const Icon(Iconsax.user), surfixneed: true),
                    const SizedBox(height: 10,),
                    custom_field(label: "Enter Your Age",keyboard: TextInputType.number , controller: age,Errormsg: "Age is Required", prefixicon: const Icon(Iconsax.calendar), surfixneed: true),
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
                    // custom_field(label: "Enter Your Gender", controller: gender,Errormsg: "Gender is Required", prefixicon: Icon(Icons.male), surfixneed: true),
                    const SizedBox(height: 10,),
                    custom_field(label: "Enter Your Email",controller: email,keyboard: TextInputType.emailAddress , Errormsg: "Email is Required", prefixicon: const Icon(Iconsax.message_notif), surfixneed: false),
                    const SizedBox(height: 10,),
                    custom_field(label: "Enter Your Password",controller: pass,Errormsg:  "Password is Required", prefixicon: const Icon(Iconsax.key), surfixneed: true,surfixIcon: IconButton(onPressed: (){setState(() {
                      ischeck = !ischeck;
                    });},icon: ischeck==false?const Icon(Iconsax.password_check):const Icon(Icons.remove_red_eye)),ispassword: ischeck==false?false:true,),


                    const SizedBox(height: 20,),

                    GestureDetector(
                      onTap: (){
                          if(_key.currentState!.validate()){
                            imageupload();
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email and Password is not Provided")));
                        }
                      },
                      child: Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: MyColors.button_color
                        ),
                        child: Center(child: loader==false?text_custome(text: "Register", size: 14, fontWeight: FontWeight.w400,color: Colors.white):const Padding(
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
                    },
                    child: text_custome(text: "Already Have an Account! Login", size: 14, fontWeight: FontWeight.w300))

              ],
            ),
          )),
    );
  }
}
