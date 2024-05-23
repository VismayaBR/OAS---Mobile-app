import 'package:flutter/material.dart';
class MyTextField extends StatelessWidget {
 
  final String hintText;
  final bool obscureText;
  var controller;

   MyTextField({
    super.key,
    
    required this.hintText,
    required this.obscureText,
  required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return   Padding(
             padding:  EdgeInsets.symmetric(horizontal: 40,vertical: 10),
             child: TextField(
              
              obscureText: obscureText,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
             
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 190, 190, 190))),

                fillColor: const Color.fromARGB(255, 255, 255, 255),
                filled: true,
                hintText: hintText,
              ),
             
             ),
           );
  }
}