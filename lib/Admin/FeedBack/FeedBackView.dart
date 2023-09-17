import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../LoginScreen.dart';
import '../../reusable_widget/colors.dart';
import '../../reusable_widget/text_widget.dart';

class ViewFeedBack extends StatefulWidget {
  const ViewFeedBack({super.key});

  @override
  State<ViewFeedBack> createState() => _ViewFeedBackState();
}

class _ViewFeedBackState extends State<ViewFeedBack> {

  void signout()async{
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20,),

              // Feedback Heading

              text_custome(text: "Fetching FeedBacks", size: 16, fontWeight: FontWeight.w600),
              const SizedBox(height: 20,),


              // Getting Feedbacks

              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("FeedBack").snapshots(),
                builder: (context, snapshot) {

                  if(snapshot.hasData){
                    var feedbackmap1 = snapshot.data!.docs.length;
                    return feedbackmap1!=0?ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const ScrollPhysics(),
                      itemCount: feedbackmap1,
                      itemBuilder: (context, index) {
                        var plantmap = snapshot.data!.docs[index];
                        var name = snapshot.data!.docs[index]["User-Name"];
                        var email= snapshot.data!.docs[index]["User-Email"];
                        var msg = snapshot.data!.docs[index]["User-Message"];
                        //Gettting ID
                        // print(snapshot.data!.docs[index].id);

                        var feedback_id = snapshot.data!.docs[index].id;
                        // print(snapshot.data!.docs[index]);
                        // Map<String, dynamic> plantmap = snapshot.data!.docs[index].data as Map<String, dynamic>;
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                              const SizedBox(width: 10,),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Plant Name
                                  Container(
                                    width: 120,
                                    height: 24,
                                    child: text_custome(text: name, size: 18, fontWeight: FontWeight.w600),
                                  ),

                                  const SizedBox(height: 3,),
                                  // Category

                                  Container(
                                    width: 120,
                                    height: 20,
                                    child: text_custome(text: email, size: 14, fontWeight: FontWeight.w600),
                                  ),


                                  const SizedBox(height: 3,),
                                  // Price

                                  Container(
                                    width: 120,
                                    height: 24,
                                    child: text_custome(text: msg, size: 14, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),

                              const SizedBox(width: 60,),

                              GestureDetector(
                                onTap: ()async{
                                  await FirebaseFirestore.instance.collection("FeedBack").doc(feedback_id).delete();
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("FeedBack Deleted")));
                                },
                                child: Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white
                                  ),
                                  child: Icon(Icons.delete,color: Colors.red.shade400),),
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
      ),
    );
  }
}
