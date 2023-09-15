import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:testing/Admin/Plant/AddPlant.dart';
import 'package:testing/Admin/Plant/UpdatePlant.dart';
import 'package:testing/reusable_widget/colors.dart';

import '../../reusable_widget/text_widget.dart';

class PLantFetch extends StatefulWidget {
  const PLantFetch({super.key});

  @override
  State<PLantFetch> createState() => _PLantFetchState();
}

class _PLantFetchState extends State<PLantFetch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const PlantAdd(),));
      },
          child: Center(child: Icon(Icons.add,color: MyColors.heading_color,),),
          backgroundColor: MyColors.background_color),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              text_custome(text: "Fetching Plants", size: 16, fontWeight: FontWeight.w600),
              const SizedBox(height: 20,),

              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Plants").snapshots(),
                builder: (context, snapshot) {

                  if(snapshot.hasData){
                    var plantmap1 = snapshot.data!.docs.length;
                    return plantmap1!=0?ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const ScrollPhysics(),
                      itemCount: plantmap1,
                      itemBuilder: (context, index) {
                        var plantmap = snapshot.data!.docs[index];
                        var name = snapshot.data!.docs[index]["Plant-Name"];
                        var cat= snapshot.data!.docs[index]["Plant-Category"];
                        var desc = snapshot.data!.docs[index]["Plant-Description"];
                        var qty = snapshot.data!.docs[index]["Plant-Quantity"];
                        var price = snapshot.data!.docs[index]["Plant-Price"];
                        var growth = snapshot.data!.docs[index]["Plant-Growth"];
                        String image = snapshot.data!.docs[index]["Plant-Image"];
                        //Gettting ID
                        // print(snapshot.data!.docs[index].id);

                        var plant_id = snapshot.data!.docs[index].id;
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
                                        image: NetworkImage(image))
                                ),
                              ),

                              const SizedBox(width: 10,),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Plant Name
                                  Container(
                                    width: 120,
                                    height: 24,
                                    child: text_custome(text: "${plantmap["Plant-Name"]}", size: 18, fontWeight: FontWeight.w600),
                                  ),

                                  const SizedBox(height: 3,),
                                  // Category

                                  Container(
                                    width: 120,
                                    height: 20,
                                    child: text_custome(text: "${plantmap["Plant-Category"]}", size: 14, fontWeight: FontWeight.w600),
                                  ),


                                  const SizedBox(height: 3,),
                                  // Price

                                  Container(
                                    width: 120,
                                    height: 24,
                                    child: text_custome(text: "${plantmap["Plant-Price"]}", size: 14, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),

                              const SizedBox(width: 34,),

                              // Update Button

                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                      PlantUpdate(id: plant_id, name: name, cat: cat, desc: desc, qty: qty, price: price, growth: growth,image: image)
                                    ,));
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

                              const SizedBox(width: 6,),

                              // Update Button

                              GestureDetector(
                                onTap: ()async{
                                  await FirebaseFirestore.instance.collection("Plants").doc(plant_id).delete();
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Plant Deleted")));
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
      )
    );
  }
}
