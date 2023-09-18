
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../reusable_widget/colors.dart';
import '../../reusable_widget/reusable_textformfield.dart';
import '../../reusable_widget/text_widget.dart';

class AccessUpdate extends StatefulWidget {

  var id;
  String name;
  String cat;
  String desc;
  String qty;
  String price;
  String? image;


  // Getting Required Fields to be Filled on Scaffold Launch
  AccessUpdate(
      {required this.id,
      required this.name,
      required this.cat,
      required this.desc,
      required this.qty,
      required this.price,
      this.image});

  @override
  State<AccessUpdate> createState() => _AccessUpdateState(id: id);
}

class _AccessUpdateState extends State<AccessUpdate> {

  var id;


  // Getting To be Update Data
  _AccessUpdateState({required this.id });

  // TextEditing Controllers for Textfields
  final _name = TextEditingController();
  final _cat = TextEditingController();
  final _desc = TextEditingController();
  final _qty = TextEditingController();
  final _price = TextEditingController();

  // File For Image
  File? Profilepic;

  // DownloadUrl For Getting Firebase Storage Download URL
  String DownloadUrl = '';

  // DropDown Selected Category
  String? selectedCategory;

  bool loader = false;

  // Image Upload Method for Accessories
  Future imageupload()async{
    setState(() {
      loader = !loader;
    });
    UploadTask uploadTask = FirebaseStorage.instance.ref().child("Accessories-Images").child(const Uuid().v1()).putFile(Profilepic!);
    TaskSnapshot taskSnapshot = await uploadTask;
    DownloadUrl = await taskSnapshot.ref.getDownloadURL();
    _updateaccess(imgurl: DownloadUrl);
    setState(() {
      loader = !loader;
    });
  }

  // Accessories Updated Data Upload to Firebase Firestore
  void _updateaccess({String? imgurl})async{

    await FirebaseFirestore.instance.collection("Accessories").doc(id).update({
      "Accessories-Category":selectedCategory,
      "Accessories-Description":_desc.text.toString(),
      "Accessories-Name":_name.text.toString(),
      "Accessories-Price":_price.text.toString(),
      "Accessories-Quantity":_qty.text.toString(),
      "Accessories-Image":imgurl,
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Updated")));
    setState(() {
      Navigator.pop(context);
    });
  }

  // Displaying Text in Fields on Scaffold Launch
  @override
  void initState() {
    // TODO: implement initState
    _name.text = widget.name;
    selectedCategory = widget.cat;
    _desc.text = widget.desc;
    _qty.text = widget.qty;
    _price.text = widget.price;
    DownloadUrl = widget.image!;
    super.initState();
  }

  // Clearing Cache
  @override
  void dispose() {
    // TODO: implement dispose
    _name.dispose();
    _cat.dispose();
    _desc.dispose();
    _qty.dispose();
    _price.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),

          // Form Having Image -> Name -> Description -> Quantity -> Price -> Update Button

          child: Form(
              child: Column(
                children: [

                  const SizedBox(height: 40,),

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
                        foregroundImage: NetworkImage(DownloadUrl),
                      )
                  ),

                  const SizedBox(height: 20,),

                  custom_field(label: "Accessories Name", controller: _name, prefixicon: const Icon(Iconsax.directbox_notif), surfixneed: false),

                  const SizedBox(height: 20,),

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
                      child:   DropdownButtonFormField<String>(
                        value: selectedCategory,
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                          });
                        },
                        items: <String>[
                          'Grow Lights',
                          'Misters',
                          'Plant Hangers',
                          'Plant Label and Markers',
                          'Plant Pots and Planters',
                          'Plant Stands',
                          'Plant Trellises and Supporters',
                          'Plant Trolleys and Cadides',
                          'Soil Moisture Meters',
                          'Watering Cans'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: text_custome(text: value, size: 14, fontWeight: FontWeight.w400),
                          );
                        }).toList(),
                        decoration:InputDecoration(
                          prefixIcon: const Icon(Iconsax.hierarchy,color: Colors.black,),
                          focusColor: Colors.black,
                          focusedBorder: InputBorder.none,
                          iconColor: Colors.black,
                          label: text_custome(text: "Select Accessories Category", size: 14, fontWeight: FontWeight.w400, color: Colors.black,),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  // custom_field(label: "Category", controller: _cat, prefixicon: Icon(Icons.category), surfixneed: true),

                  const SizedBox(height: 20,),

                  custom_field(label: "Description", controller: _desc, prefixicon: const Icon(Iconsax.element_equal), surfixneed: true),

                  const SizedBox(height: 20,),

                  custom_field(label: "Quantity",keyboard: TextInputType.number , controller: _qty, prefixicon: const Icon(Iconsax.export), surfixneed: true),

                  const SizedBox(height: 20,),

                  custom_field(label: "Price",keyboard: TextInputType.number , controller: _price, prefixicon: const Icon(Iconsax.dollar_circle), surfixneed: true),

                  const SizedBox(height: 20,),

                  GestureDetector(
                    onTap: (){
                      imageupload();
                    },
                    child: Container(
                      width: 120,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: MyColors.button_color
                      ),
                      child: Center(child: loader==false?text_custome(text: "Update Access", size: 14, fontWeight: FontWeight.w400,color: Colors.white):const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: CircularProgressIndicator(color: Colors.white,),
                      ),),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
