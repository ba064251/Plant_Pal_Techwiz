import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/reusable_widget/text_widget.dart';

class custom_field extends StatelessWidget {

  String label;
  String? Errormsg;
  TextEditingController controller;
  Icon prefixicon;
  IconButton? surfixIcon;
  bool surfixneed;
  bool? ispassword;
  TextInputType? keyboard;

  custom_field(
      {required this.label, required this.controller, required this.prefixicon, this.surfixIcon, required this.surfixneed,
        this.ispassword, this.Errormsg, this.keyboard});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      height: 50,
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade300
      ),
        child: Center(
        child: TextFormField(
          keyboardType: keyboard,
          validator: (value){
            if(value==null||value==""){
              return Errormsg;
            }
            return null;
          },
            controller: controller,
            obscureText: ispassword??false,
            style: GoogleFonts.poppins(textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,

            )),
            decoration: surfixneed==false?InputDecoration(
              label: text_custome(
                text: label,
                size: 16,
                fontWeight: FontWeight.w400,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              prefixIcon: Icon(Icons.email),
              focusColor: Colors.transparent,
              prefixIconColor: Colors.black,
            ):InputDecoration(
              label: text_custome(
                text: label,
                size: 16,
                fontWeight: FontWeight.w400,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              prefixIcon: prefixicon,
              focusColor: Colors.transparent,
              prefixIconColor: Colors.black,
              suffixIcon: surfixIcon,
              suffixIconColor: Colors.black
            )
        ),
      ),
    );
  }
}
