import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:testing/DescriptionScreen.dart';
import 'package:testing/reusable_widget/colors.dart';
import 'package:testing/reusable_widget/text_widget.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {


  @override
  void initState() {
    var test=search_product.text="";
    setState(() {
      if(test.length>=1){
        close==true;
      }
      else if(test.length<0){
        close==false;
      }

    });
    print(close);
    super.initState();
  }
  TextEditingController search_product= TextEditingController();
  bool close=false;
  var fav_product=false;
  List cat = ["All","Flower","Fruit","Herb","Tree"];
  int current = 0;
  var check ="All";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: const Icon(Iconsax.arrow_left,size: 16,)),
                    const SizedBox(width: 10,
                      height: 20,),
                    text_custome(text: 'Products',color: MyColors.card_light_color1, size: 24, fontWeight: FontWeight.w600)
                  ],
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  controller: search_product,
                  cursorColor: MyColors.button_color,
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
                    hintText: "Search Products",
                    prefixIcon: const Icon(Iconsax.search_normal,color: Colors.black,),

                    suffixIcon:GestureDetector(
                      onTap: (){
                         search_product.text="";

                      },
                        child: close?const Icon(Iconsax.trash,color: Colors.black):const Icon(Iconsax.trash)),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: text_custome(text: 'Catalog', size: 16, fontWeight: FontWeight.w400),
                ),

    Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 6),
    child: Column(
    children: [
    SizedBox(
    width: double.infinity,
    height: 40,
    child: ListView.builder(
      shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    physics: const BouncingScrollPhysics(),
    itemCount: cat.length,
    itemBuilder: (context, index) {
    return GestureDetector(
    onTap: (){
    setState(() {
    current = index;
    check = cat[index];
    });
    },
    child: AnimatedContainer(
    curve: decelerateEasing,
    duration: const Duration(milliseconds: 400),
    margin: const EdgeInsets.symmetric(horizontal: 4,vertical: 4),
    width: 100,
    height: 30,
    decoration: BoxDecoration(
      color: current==index?MyColors.background_color.withOpacity(0.4):Colors.transparent,
    borderRadius: current==index?BorderRadius.circular(20):BorderRadius.circular(4),
    ),
    child: Center(child: text_custome(text: cat[index], size: 14, fontWeight: FontWeight.w400,color: current==index?MyColors.heading_color:Colors.black,)),
    ),
    );
    },),
    ),])),

                Padding(
                  padding: const EdgeInsets.all(21.0),
                  child: StreamBuilder(
                    stream: check=="Flower"?FirebaseFirestore.instance.collection("Plants").where("Plant-Category",isEqualTo: "Flower").snapshots():
                      check=="Fruit"?FirebaseFirestore.instance.collection("Plants").where("Plant-Category",isEqualTo: "Fruit").snapshots():
                      check=="Herb"?FirebaseFirestore.instance.collection("Plants").where("Plant-Category",isEqualTo: "Herb").snapshots():
                      check=="Tree"?FirebaseFirestore.instance.collection("Plants").where("Plant-Category",isEqualTo: "Tree").snapshots():
                      FirebaseFirestore.instance.collection("Plants").snapshots(),
                    builder: (context, snapshot) {

                      if(snapshot.hasData){

                        var plantmap1 = snapshot.data!.docs.length;


                        return GridView.builder(
                          shrinkWrap: true,
                          //  physics: NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 40,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            mainAxisExtent: 230,
                          ),
                          itemCount: plantmap1,
                          itemBuilder: (_,index){
                            var plantmap = snapshot.data!.docs[index];
                            var plant_id = snapshot.data!.docs[index].id;

                            var name = snapshot.data!.docs[index]["Plant-Name"];
                            var cat= snapshot.data!.docs[index]["Plant-Category"];
                            var desc = snapshot.data!.docs[index]["Plant-Description"];
                            var qty = snapshot.data!.docs[index]["Plant-Quantity"];
                            var price = snapshot.data!.docs[index]["Plant-Price"];
                            var growth = snapshot.data!.docs[index]["Plant-Growth"];
                            String image = snapshot.data!.docs[index]["Plant-Image"];
                            return Container(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                decoration:BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade200
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DescriptionScreen(plant_name: name,
                                        plant_category: cat,plant_description: desc,price: price,plant_growth: growth,plant_img: image),));
                                      },
                                      child: Container(

                                        decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                            image: NetworkImage(plantmap["Plant-Image"])
                                            ),
                                          // color: Colors.black
                                        ),
                                        width: double.infinity,
                                        height: 110,
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        text_custome(text: '${plantmap["Plant-Name"]}', size: 14, fontWeight: FontWeight.w600),

                                        text_custome(text: '${plantmap["Plant-Category"]}', size: 12, fontWeight: FontWeight.w400),

                                      ],
                                    ),


                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:[
                                        text_custome(text: '${plantmap["Plant-Price"]}', size: 14, fontWeight: FontWeight.w600),
                                        IconButton(onPressed: (){
                                          setState(() {
                                            fav_product=!fav_product;
                                          });
                                        }, icon: Icon(fav_product?FontAwesomeIcons.gratipay:FontAwesomeIcons.heart,color: Colors.red,size:18))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }

                      if(snapshot.hasError){
                        return const Icon(Icons.error);
                      }

                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const CircularProgressIndicator();
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
