// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final Icon prefixIcon;
  final Function()? onChanged;

  const MyTextField(
      {super.key,
        required this.controller,
        required this.hintText,
        required this.obscureText,
        required this.prefixIcon,
        this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.black),
      obscureText: obscureText,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        // hintStyle:GoogleFonts.poppins(
        //   fontSize: 15,
        //   color: HexColor("#8d8d8d"),
        enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white)
         ),
        // border: (
        //   // borderRadius: BorderRadius.circular(30),
        //     borderSide: const BorderSide(color: Colors.white, width: 2.0)
        // ),
        prefixIcon: prefixIcon,
        prefixIconColor: HexColor("#4f4f4f"),
        filled: true,
      ),
    );
  }
}
class MyPasswordTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final Icon prefixIcon;
  final bool obscureText;
  const MyPasswordTextField({

    super.key,
  required this.prefixIcon,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (val) => val!.isEmpty ? '' : null,
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.black),

      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
          ),
          suffixIcon: const Icon(Icons.visibility_off),


          prefixIconColor:   HexColor("#4f4f4f"),
          prefix:  prefixIcon,


          filled: true,
          // contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey)



      ),
          // hintStyle: TextStyle(color: Colors.grey[500])),
    );
  }
}