import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:testing/reusable_widget/colors.dart';
import 'package:testing/reusable_widget/reusable_textformfield.dart';
import 'package:testing/reusable_widget/text_widget.dart';

import '../DescriptionScreen.dart';

class AccessoriesScreen extends StatefulWidget {
  const AccessoriesScreen({super.key});

  @override
  State<AccessoriesScreen> createState() => _AccessoriesScreenState();
}

class _AccessoriesScreenState extends State<AccessoriesScreen> {
  final List<Map<String,dynamic>> accessories=[
    {
      "title":"Grow Lights",
      "price":"\$50",
      "images":"images/growlight1.png"

    },

    {
      "title":"Grow Lights",
      "price":"\$20",
      "images":"images/growlight2.png"

    },
    {
      "title":"Grow Lights",
      "price":"\$30",
      "images":"images/growlight3.png"

    },
    {
      "title":"Grow Lights",
      "price":"\$40",
      "images":"images/growlight4.png"

    },
    {
      "title":"Mister In Gold",
      "price":"\$90",
      "images":"images/mister1.png"

    },
    {
      "title":"Black Arclyric Mister",
      "price":"\$100",
      "images":"images/mister2.png"

    },
    {
      "title":"Mister",
      "price":"\$70",
      "images":"images/mister3.png"

    },

  ];
  var search_controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 10,
                    height: 20,),
                    text_custome(text: 'Accessories',color: MyColors.card_light_color1, size: 24, fontWeight: FontWeight.w600)
                  ],
                ),
                    SizedBox(height: 20,),
                    TextFormField(
                      decoration: InputDecoration(

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            width: 0.8,
                            color: MyColors.card_light_color1
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: MyColors.card_light_color1,
                          )
                        ),
                        hintText: "Search Accessories",
                        prefixIcon: Icon(Icons.search),
                        suffixIcon:Icon(Icons.clear),
                      ),
                    ),

                Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: text_custome(text: 'Catalog', size: 16, fontWeight: FontWeight.w400),
                ),
               Padding(
                 padding: const EdgeInsets.all(21.0),
                 child: StreamBuilder(
                   stream: FirebaseFirestore.instance.collection("Accessories").snapshots(),
                   builder: (context, snapshot) {
                     var accessmap1 = snapshot.data!.docs.length;
                     if(snapshot.hasData){
                       return GridView.builder(
                         shrinkWrap: true,
                         //  physics: NeverScrollableScrollPhysics(),
                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                           crossAxisSpacing: 40,
                           mainAxisSpacing: 10,
                           crossAxisCount: 2,
                           mainAxisExtent: 230,
                         ),
                         itemCount: accessmap1,
                         itemBuilder: (_,index){

                           var accessmap = snapshot.data!.docs[index];
                           var access_id = snapshot.data!.docs[index].id;

                           var name = snapshot.data!.docs[index]["Accessories-Name"];
                           var cat= snapshot.data!.docs[index]["Accessories-Category"];
                           var desc = snapshot.data!.docs[index]["Accessories-Description"];
                           var qty = snapshot.data!.docs[index]["Accessories-Quantity"];
                           var price = snapshot.data!.docs[index]["Accessories-Price"];
                           String image = snapshot.data!.docs[index]["Accessories-Image"];

                           return GestureDetector(
                             onTap: (){
                               Navigator.push(context, MaterialPageRoute(builder: (context) => DescriptionScreen(plant_name: name,
                                   plant_category: cat,plant_description: desc,price: price,plant_img: image),));
                             },
                             child: Container(
                               decoration:BoxDecoration(
                                   borderRadius: BorderRadius.circular(20),
                                   color: Colors.grey.shade200
                               ),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.all(5),
                                     child: Container(
                                       decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(20),
                                         image: DecorationImage(
                                           fit: BoxFit.cover,
                                           image:
                                           NetworkImage(
                                               image
                                           ),
                                         ),
                                         // color: Colors.black
                                       ),
                                       width: 140,
                                       height: 120,
                                     ),
                                   ),
                                   Padding(
                                     padding: const EdgeInsets.only(left: 10),
                                     child: text_custome(text: name, size: 14, fontWeight: FontWeight.w600),
                                   ),

                                   Row(
                                     children:[
                                       Padding(
                                         padding: const EdgeInsets.only(left: 10),
                                         child: text_custome(text: "\$${price}", size: 14, fontWeight: FontWeight.w600),
                                       ),
                                       IconButton(onPressed: (){}, icon: Icon(Iconsax.heart,color: Colors.red,size:18))
                                     ],
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   ),
                                 ],
                               ),
                             ),
                           );
                         },
                       );
                     }

                     if(snapshot.hasError){
                       return Icon(Icons.error);
                     }

                     if(snapshot.connectionState == ConnectionState.waiting){
                       return CircularProgressIndicator();
                     }

                     return Container();
                   }
                 ),
               )
              ],


            ),
          ),
        ),
      ),
    );
  }
}


