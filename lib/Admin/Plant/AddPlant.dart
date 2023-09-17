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

class PlantAdd extends StatefulWidget {
  const PlantAdd({super.key});

  @override
  State<PlantAdd> createState() => _PlantAddState();
}

class _PlantAddState extends State<PlantAdd> {

  // TextEditing Controllers for Fields

  final _name = TextEditingController();
  final _cat = TextEditingController();
  final _desc = TextEditingController();
  final _qty = TextEditingController();
  final _price = TextEditingController();
  final _growth = TextEditingController();

  // File For Image
  File? Profilepic;

  // Gettings DownloadUrl From Firebase Storage
  String DownloadUrl = '';

  // DropDown Default Selected Value
  String selectedValue = 'Flower';


  // Date Upload with Image in Plant Collection using Firebase Firestore
  Future imageupload()async{
    UploadTask uploadTask = FirebaseStorage.instance.ref().child("Plant-Images").child(const Uuid().v1()).putFile(Profilepic!);
    TaskSnapshot taskSnapshot = await uploadTask;
    DownloadUrl = await taskSnapshot.ref.getDownloadURL();
    _addplant(imgurl: DownloadUrl);
  }

  // Plant Detail Method
  void _addplant({String? imgurl})async{
    Map<String, dynamic> plantadd = {
      "Plant-Name":_name.text.toString(),
      "Plant-Category":selectedValue,
      "Plant-Description":_desc.text.toString(),
      "Plant-Quantity":_qty.text.toString(),
      "Plant-Price":_price.text.toString(),
      "Plant-Growth":_growth.text.toString(),
      "Plant-Image": imgurl,
    };
    await FirebaseFirestore.instance.collection("Plants").add(plantadd);

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
    _growth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),

          // TextFormFields of Image -> Name -> Category -> Description -> Quantity -> Price -> Growth Habit -> Add Button

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

              custom_field(label: "Plant Name", controller: _name, prefixicon: const Icon(Iconsax.directbox_notif), surfixneed: false),

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
                  child: DropdownButtonFormField<String>(
                    value: selectedValue,
                    onChanged: (newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                    items: <String>['Flower', 'Fruit', 'Herb', 'Tree']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.hierarchy,color: Colors.black,),
                      focusColor: Colors.black,
                      focusedBorder: InputBorder.none,
                      iconColor: Colors.black,
                      label: text_custome(text: "Select Plant Category", size: 14, fontWeight: FontWeight.w400, color: Colors.black,),
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a plant category';
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

              custom_field(label: "Price", controller: _price,keyboard: TextInputType.number , prefixicon: const Icon(Iconsax.dollar_circle), surfixneed: true),

              const SizedBox(height: 20,),

              custom_field(label: "Growth Habit", controller: _growth, prefixicon: const Icon(Iconsax.diagram), surfixneed: true),

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
                  child: Center(child: text_custome(text: "Add Plant",fontWeight: FontWeight.w600,size: 14,color: Colors.white),),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
