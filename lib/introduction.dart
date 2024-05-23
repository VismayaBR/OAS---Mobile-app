import 'package:flutter/material.dart';
import 'package:myproject/login.dart';
import 'package:myproject/register.dart';

class First_Page extends StatefulWidget {
  const First_Page({super.key});

  @override
  State<First_Page> createState() => _First_PageState();
}

class _First_PageState extends State<First_Page> {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 252, 225),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 28,),
            Image.asset(
              'assets/mainIcon.png',
              height: 230,
            ),
            
            const Padding(
              padding: EdgeInsets.only(left: 44,right: 44),
              child: Text(
                "Auctions for everyone, On everything!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 30, 22, 32),
                ),
              ),
            ),
            const SizedBox(
              height: 93,
            ),
            //start now button

            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Register(),
                  )),
              child: Container(
                width: 320,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadiusDirectional.circular(10),
                  
                ),
                padding: const EdgeInsets.all(19),
                child: const Center(
                    child: Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Color.fromARGB(255, 199, 237, 255), fontSize: 17),
                )),
              ),
            ),
            //login

            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  )),
              child: Container(
                width: 320,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadiusDirectional.circular(10),
                  gradient: const LinearGradient(colors: [Color.fromARGB(255, 6, 6, 76), Color.fromARGB(255, 0, 67, 167)],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: [0.4, 0.7],
                      tileMode: TileMode.repeated,)
                ),
                padding: const EdgeInsets.all(19),
                child: const Center(
                    child: Text(
                  "Log In",
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
