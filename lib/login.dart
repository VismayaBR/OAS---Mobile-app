// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/components/my_textfield.dart';
import 'package:myproject/home.dart';
import 'package:myproject/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signInUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Implement your sign-in logic here

 final QuerySnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('name', isEqualTo: usernameController.text)
            .where('password', isEqualTo: passwordController.text)
            .get();
    if (userSnapshot.docs.isNotEmpty) {
      String userId = userSnapshot.docs[0].id;
      String username = userSnapshot.docs[0]['name'];
      String occupation = userSnapshot.docs[0]['occupation'];
      String phone = userSnapshot.docs[0]['phone'];
      String place = userSnapshot.docs[0]['place'];
      SharedPreferences spref = await SharedPreferences.getInstance();
      spref.setString('user_id', userId);
      spref.setString('username', username);
      spref.setString('occupation', occupation);
      spref.setString('phone', phone);
      spref.setString('place', place);

       ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );
      print('Customer ID: $userId');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomeP(currentIndex: 0,);
      }));
    }
    else{
       ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid username or password!')),
          );
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 252, 225),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, size: 100),
                    SizedBox(height: 20),
                    Text(
                      "Hello, You've been Missed",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                     TextFormField(
                                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                             
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 190, 190, 190))),
                
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  filled: true,
                  hintText: 'Username',
                ),
                  controller: usernameController,
                  // hintText: "Phone",
                  obscureText: false,
                ),
                    SizedBox(height: 10),
                    TextFormField(
                                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                             
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 190, 190, 190))),
                
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  filled: true,
                  hintText: 'Password',
                ),
                  controller: passwordController,
                  // hintText: "Phone",
                  obscureText: false,
                ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: signInUser,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 166, 15, 15),
                        ),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 252, 252),
                        ),
                      ),
                    ),
                    SizedBox(height: 33),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Not a member?'),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Register(),
                            ));
                          },
                          child: Text(
                            'Click here',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
