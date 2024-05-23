import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  void Function()? onTap;
  
  MyButton({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
        
        decoration: BoxDecoration(color: Color.fromARGB(213, 0, 0, 0),borderRadius: BorderRadius.circular(5)),
        child:const Text('',
      
        style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 14),
      
        
      
      
      ) ,
      
      
      
      
      
      
      
      
      ),
    );
  }
}