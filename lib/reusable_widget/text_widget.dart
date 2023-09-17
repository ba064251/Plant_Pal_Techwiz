import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'colors.dart';

class text_custome extends StatelessWidget {

  String text;
  Color? color;
  double size;
  FontWeight fontWeight;

  text_custome({required this.text, this.color, required this.size, required this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(text,style: GoogleFonts.lexend(textStyle: TextStyle(
      fontSize: size,
      fontWeight: fontWeight,
      color: color,
    )),);
  }
}

class menu extends StatelessWidget {
  IconData menuIcon;
  String title;


  menu({required this.menuIcon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        child: ListTile(
          leading: const Icon(Iconsax.menu_1,size: 18,),
          title: Text(title,style: GoogleFonts.poppins(
              color: MyColors.button_color
          ),),
        ),
      ),
    );
  }
}