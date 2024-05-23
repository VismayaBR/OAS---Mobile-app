import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import DateFormat for formatting dates
import 'package:myproject/components/my_textfield.dart';
import 'package:myproject/login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var placeController = TextEditingController();
  var occupationController = TextEditingController();
  var phoneController = TextEditingController();
  var dobController = TextEditingController(); // Default value set to empty
  var passwordController = TextEditingController();

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> register() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseFirestore.instance.collection('users').add({
          'name': nameController.text,
          'place': placeController.text,
          'occupation': occupationController.text,
          'phone': phoneController.text,
          'dob': dobController.text,
          'password': passwordController.text,
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 252, 225),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const SizedBox(height: 50),
              const Center(
                child: Text(
                  "Let's register now!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 190, 190, 190))),
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  filled: true,
                  hintText: 'Name',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: placeController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 190, 190, 190))),
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  filled: true,
                  hintText: 'Place',
                ),
                obscureText: false,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: occupationController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 190, 190, 190))),
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  filled: true,
                  hintText: 'Occupation',
                ),
                obscureText: false,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 190, 190, 190))),
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  filled: true,
                  hintText: 'Phone',
                ),
                obscureText: false,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: dobController,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 190, 190, 190))),
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                      hintText: 'Date of Birth',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 190, 190, 190))),
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  filled: true,
                  hintText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: register,
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Color.fromARGB(255, 255, 252, 252)),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 166, 15, 15),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
