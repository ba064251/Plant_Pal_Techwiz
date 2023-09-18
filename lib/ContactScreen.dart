import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:testing/LoginScreen.dart';
import 'package:testing/reusable_widget/colors.dart';
import 'package:testing/reusable_widget/reusable_textformfield.dart';
import 'package:testing/reusable_widget/text_widget.dart';
class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();

}

class _ContactScreenState extends State<ContactScreen> {

  // TextEditing Controllers For TextFields
  final _sendername= TextEditingController();
  final _senderemail=TextEditingController();
  final _sendermessage=TextEditingController();

  bool loader = false;

  // Feedback Upload Method
  void addingfeedback({String? imgurl})async{
    setState(() {
      loader = !loader;
    });
    Map<String,dynamic> addfeedback ={
      "User-Name":_sendername.text.toString(),
      "User-Email":_senderemail.text.toString(),
      "User-Message": _sendermessage.text.toString(),
    };
    await FirebaseFirestore.instance.collection("FeedBack").add(addfeedback);
    setState(() {
      loader = !loader;
    });
  }

  // Clearing Cache
  @override
  void dispose() {
    // TODO: implement dispose
    _sendername.dispose();
    _senderemail.dispose();
    _sendermessage.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SafeArea(
            top: true,
            child: Container(

              decoration:const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/contactscreenbg1.jpg'),
                  fit: BoxFit.cover
                )
              ),
              height: double.infinity,
                child: Stack(
                  children:[
                    Center(
                    child: Container(
                       width: 300,
                      height: 512,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(21),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 30,),
                          text_custome(text: 'Get In Touch', size: 24, fontWeight: FontWeight.w600),
                          const SizedBox(height: 5,),
                          text_custome(text: 'FEEL FREE TO DROP US A MESSAGE ', size: 12, fontWeight: FontWeight.w300),
                          const SizedBox(height: 20,),
                          custom_field(label: 'Name', controller: _sendername, prefixicon: const Icon(Iconsax.user), surfixneed: true),
                          const SizedBox(height: 10,),
                          custom_field(label: 'Email', controller: _senderemail, prefixicon: const Icon(Iconsax.message_notif), surfixneed: true),
                          const SizedBox(height: 10,),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21),
                                color: Colors.grey.shade300
                            ),
                            child:Column(
                              children: [
                                Row(children: [
                                  const Icon(Iconsax.message,size: 22,),
                                  const SizedBox(width: 10,),
                                  text_custome(text: "Message", size: 16, fontWeight: FontWeight.w400,color: Colors.grey.shade600,)
                                ],),
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Center(child: Divider(
                                     thickness: 1,
                                    color: Colors.grey.shade400,
                                  ),),
                                ),
                                TextField(
                                  maxLength: 250,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(250)
                                  ],
                                  controller: _sendermessage,
                                  decoration: const InputDecoration(
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    hintText: "Type Here",
                                  ),
                                  maxLines: 3,
                                )
                              ],
                            )
                          ),
                            const SizedBox(height: 80,),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(21)
                                ),
                                backgroundColor: MyColors.button_color
                              ),

                                onPressed: (){
                                  addingfeedback();
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("FeedBack Sent")));
                                }, child: Padding(
                                  padding: const EdgeInsets.only(left: 15,right: 15,bottom: 8,top: 8),
                                  child: text_custome(text: 'Submit',size: 18,fontWeight: FontWeight.w400,),
                                ))
                        ],
                      ),
                    ),
                  ),
                  ]
                ),
              ),
          ),

    );
  }
}


