import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/utils/my_theme.dart';

class MyTextField extends StatelessWidget {
  final hint;
  final double textSize;
  TextEditingController controller;

  MyTextField({required this.hint,required this.textSize , required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      style: TextStyle(fontSize: textSize,color: Colors.white,fontWeight: FontWeight.bold),


      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: greyColor),
        border: InputBorder.none,
        // hint: Text(hint, style: TextStyle(fontSize: 48, color: greyColor)),

      ),
    );
  }
}
