import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:testing/reusable_widget/colors.dart';
import 'package:testing/reusable_widget/text_widget.dart';

class DescriptionScreen extends StatefulWidget {

  var price;
  var plant_name;
  var plant_img;
  var plant_category;
  var plant_growth;
  var plant_description;

  DescriptionScreen(
      {
        required this.price,
        required this.plant_name,
        required this.plant_img,
        required this.plant_category,
        this.plant_growth,
        required this.plant_description}); // String image;


  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState(
    plant_img: plant_img,
    plant_growth: plant_growth,price: price,plant_description: plant_description,plant_name: plant_name,plant_category:plant_category
  );
}

class _DescriptionScreenState extends State<DescriptionScreen> {

  var price;
  var plant_name;
  var plant_img;
  var plant_category;
  var plant_growth;
  var plant_description;

  _DescriptionScreenState(
      {required this.price,
        required this.plant_name,
        required this.plant_img,
        required this.plant_category,
        this.plant_growth,
        required this.plant_description});

  var fav_product=false;
  int count = 1;

  void increment() {
    count++;
    setState(() {});
  }

  void decrement() {
    count--;
    setState(() {});
  }

  var _category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Positioned(
                    child: Container(
                      width: double.infinity,
                      height: 240,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40)),
                        color: MyColors.background_color.withOpacity(0.4),
                        image: DecorationImage(
                            image: NetworkImage('${plant_img}'),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    left:5,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(onTap: (){
                        setState(() {
                          fav_product=!fav_product;
                        });
                        print(fav_product);
                      },
                        child: Icon(
                         fav_product?  FontAwesomeIcons.gratipay:FontAwesomeIcons.heart,
                          size: 20,
                          color: Colors.red,
                        ),
                      )),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text_custome(
                                text: '${plant_name}',
                                size: 24.0,
                                fontWeight: FontWeight.w600),
                            text_custome(

                                text: '${plant_category}',
                                size: 16.0,
                                fontWeight: FontWeight.w400),
                            const SizedBox(
                              height: 20,
                            ),
                            text_custome(text: 'Plant Description', size: 16.0, fontWeight: FontWeight.w600),
                            const SizedBox(height: 5,),
                            text_custome(
                                text:'${plant_description}',
                                    size: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400)
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        text_custome(text: 'Price : \$${price}', size: 18, fontWeight: FontWeight.w600),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            text_custome(
                                text: "Quantity :", size: 14, fontWeight: FontWeight.w600),
                            Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.black)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        if (count <= 0) {
                                        } else {
                                          decrement();
                                        }
                                      },
                                      icon: const Icon(Iconsax.minus)),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12, top: 2, bottom: 2),
                                    child: Text('${count}'),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        increment();
                                      },
                                      icon: const Icon(Iconsax.add))
                                ],
                              ),
                            ),

                          ],
                        ),
                        const SizedBox(height: 20,),
                        plant_growth!=null?text_custome(text: 'Plant Growth: ', size: 16, fontWeight: FontWeight.w600):Container(),
                        plant_growth!=null?text_custome(text:'${plant_growth}' , size: 14, fontWeight: FontWeight.w400):Container(),
                        const SizedBox(height: 30,),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColors.button_color,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(11),
                                  )
                                ),
                                  onPressed: (){

                                  if(count>0)
                                    {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Item Added")));
                                    }
                                  else
                                    {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select an item")));
                                    }
                                  }, child: Padding(
                                    padding: const EdgeInsets.only(left: 15,right: 15,bottom: 8,top: 8),
                                    child: text_custome(text:'Add to Cart',size: 14,fontWeight: FontWeight.w400),
                                  ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade200,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                  children: [
                                    text_custome(text: 'Total Price:', size: 14, fontWeight: FontWeight.w600),
                                    text_custome(
                                      text: '\$${int.parse(price)*count}',
                                      fontWeight: FontWeight.w600,
                                      size: 20,

                                    ),
                                  ],
                                ),
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
