
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

class PlantUpdate extends StatefulWidget {

  var id;
  String name;
  String cat;
  String desc;
  String qty;
  String price;
  String growth;
  String image;

  // Getting Required Data to Update

  PlantUpdate(
      {required this.id,
      required this.name,
      required this.cat,
      required this.desc,
      required this.qty,
      required this.price,
      required this.growth,
      required this.image});

  @override
  State<PlantUpdate> createState() => _PlantUpdateState(id: id);
}

class _PlantUpdateState extends State<PlantUpdate> {

  var id;

// Getting Plant ID to Update
  _PlantUpdateState({required this.id });


  //TextEditing Controllers For TextForm Fields
  final _name = TextEditingController();
  final _cat = TextEditingController();
  final _desc = TextEditingController();
  final _qty = TextEditingController();
  final _price = TextEditingController();
  final _growth = TextEditingController();

  // File For Image
  File? Profilepic;

  // Getting Image Download Url From Firebase Storage
  String DownloadUrl = '';

  // Default Selected Value of Plant Category
  String? selectedValue;

  bool loader = false;

  // Image and Data Upload Method
  Future imageupload()async{
    setState(() {
      loader = !loader;
    });
    UploadTask uploadTask = FirebaseStorage.instance.ref().child("Plant-Images").child(const Uuid().v1()).putFile(Profilepic!);
    TaskSnapshot taskSnapshot = await uploadTask;
    DownloadUrl = await taskSnapshot.ref.getDownloadURL();
    _updateplant(imgurl: DownloadUrl);
    setState(() {
      loader = !loader;
    });
  }

  // Plant Details Upload Method
  void _updateplant({String? imgurl})async{

    await FirebaseFirestore.instance.collection("Plants").doc(id).update({
      "Plant-Category":selectedValue,
      "Plant-Description":_desc.text.toString(),
      "Plant-Growth":_growth.text.toString(),
      "Plant-Name":_name.text.toString(),
      "Plant-Price":_price.text.toString(),
      "Plant-Quantity":_qty.text.toString(),
      "Plant-Image":imgurl,
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
    selectedValue = widget.cat;
    _desc.text = widget.desc;
    _qty.text = widget.qty;
    _growth.text = widget.growth;
    _price.text = widget.price;
    DownloadUrl = widget.image;
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

          // TextFormFields of Image -> Name -> Category -> Description -> Quantity -> Price -> Growth Habit -> Update Button

          child: Form(
              child: Column(
                children: [

                  const SizedBox(height: 40,),

                  // Image picking and Displaying
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
                      width: 120,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: MyColors.button_color
                      ),
                      child: Center(child: loader==false?text_custome(text: "Update Plant", size: 14, fontWeight: FontWeight.w400,color: Colors.white):const Padding(
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
