import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/DescriptionScreen.dart';
import 'package:testing/reusable_widget/text_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  int cartValue=1;
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
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle
                    ),
                    width: 40,
                    height: 40,
                    child: const Center(
                      child: Icon(Icons.arrow_back_ios_new,size: 15,),
                    ),
                  ),
                ),
                const SizedBox(width:30,),
                text_custome(text: 'Shopping Cart', size: 16, fontWeight: FontWeight.w600)
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Flexible(
                    child: SizedBox(
                        height: 550,
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance.collection("Cart").where("User-Email",isEqualTo: userId).snapshots(),
                            builder: (context, snapshot) {
                              var cartLength = snapshot.data!.docs.length;
                              if (snapshot.hasData) {
                                return cartLength!=0?ListView.builder(
                                  itemCount: cartLength,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {

                                    var cartId = snapshot.data!.docs[index].id;
                                    var name = snapshot.data!.docs[index]["Plant-Name"];
                                    var cat= snapshot.data!.docs[index]["Plant-Category"];
                                    var desc = snapshot.data!.docs[index]["Plant-Description"];
                                    var price = snapshot.data!.docs[index]["Plant-Price"];
                                    var growth = snapshot.data!.docs[index]["Plant-Growth"];
                                    String image = snapshot.data!.docs[index]["Plant-Image"];

                                    return GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DescriptionScreen(plant_name: name,
                                            plant_category: cat,plant_description: desc,price: price,plant_growth: growth,plant_img: image),));
                                      },
                                      child: Card(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                 SizedBox(
                                                    width: 60,
                                                    height: 60,
                                                    child: Image(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(image),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                          width: 120,
                                                          child: text_custome(text: name, size: 14, fontWeight: FontWeight.w600)),
                                                      const SizedBox(height: 8,),
                                                      text_custome(text: '\$$price', size: 14, fontWeight: FontWeight.w400)
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [

                                                  GestureDetector(
                                                    onTap: (){
                                                      FirebaseFirestore.instance.collection("Cart").doc(cartId).delete();
                                                    },
                                                    child: Container(
                                                      width: 45,
                                                      height: 45,

                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.grey.shade200,
                                                      ),
                                                      child: Icon(Iconsax.trash,size: 18,color: Colors.red.shade400,),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );

                                  },):Center(child: text_custome(
                                    text: "Nothing to Show",
                                    size: 16.0,
                                    fontWeight: FontWeight.w400),);
                              } if (snapshot.hasError) {
                                return const Icon(Icons.error_outline);
                              } if(snapshot.connectionState==ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              return Container();
                            })),
                  ),
                  const SizedBox(height: 10),

                ],
              ),
            ),



          ],
        ),
      ),
    );
  }
}
