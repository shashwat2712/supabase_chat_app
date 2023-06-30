import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyBullets extends StatelessWidget {
  final String text;
  final IconData leading_icon;
  const MyBullets({super.key, required this.text,required this.leading_icon});

  @override
  Widget build(BuildContext context) {
    return Container(


      decoration:  BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(5),


      child:  Row(
        children: [
          Icon(leading_icon),
          SizedBox(width: 5,),
          Text(
              text,
              style :  GoogleFonts.abel(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
          ),
        ],
      ),
    );

  }
}
