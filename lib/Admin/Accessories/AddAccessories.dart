import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing/reusable_widget/colors.dart';
import 'package:testing/reusable_widget/reusable_textformfield.dart';
import 'package:testing/reusable_widget/text_widget.dart';
import 'package:uuid/uuid.dart';

class AccessAdd extends StatefulWidget {
  const AccessAdd({super.key});

  @override
  State<AccessAdd> createState() => _AccessAddState();
}

class _AccessAddState extends State<AccessAdd> {


  // Text Editing Controllers For TextFields
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
  String selectedCategory = 'Grow Lights';


  // Image Upload Method for Accessories
  Future imageupload()async{
    UploadTask uploadTask = FirebaseStorage.instance.ref().child("Accessories-Images").child(const Uuid().v1()).putFile(Profilepic!);
    TaskSnapshot taskSnapshot = await uploadTask;
    DownloadUrl = await taskSnapshot.ref.getDownloadURL();
    _addaccess(imgurl: DownloadUrl);
  }

  // Accessories Details Upload to Firebase Firestore
  void _addaccess({String? imgurl})async{
    Map<String, dynamic> plantadd = {
      "Accessories-Name":_name.text.toString(),
      "Accessories-Category":selectedCategory,
      "Accessories-Description":_desc.text.toString(),
      "Accessories-Quantity":_qty.text.toString(),
      "Accessories-Price":_price.text.toString(),
      "Accessories-Image": imgurl,
    };
    print(_addaccess);
    await FirebaseFirestore.instance.collection("Accessories").add(plantadd);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Inserted")));
    setState(() {
      Navigator.pop(context);
    });
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

          // Form Having Image -> Name -> Description -> Quantity -> Price -> Add Button

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

              custom_field(label: "Quantity", controller: _qty,keyboard: TextInputType.number , prefixicon: const Icon(Iconsax.export), surfixneed: true),

              const SizedBox(height: 20,),

              custom_field(label: "Price", controller: _price,keyboard: TextInputType.number ,prefixicon: const Icon(Iconsax.dollar_circle), surfixneed: true),

              const SizedBox(height: 20,),

              GestureDetector(
                onTap: (){
                  imageupload();
                },
                child: Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: MyColors.button_color
                  ),
                  child: Center(child: text_custome(text: "Add Access",fontWeight: FontWeight.w600,size: 14,color: Colors.white),),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
