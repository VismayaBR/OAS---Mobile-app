import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myproject/home.dart';

class Userfeedback extends StatefulWidget {
  const Userfeedback({super.key});

  @override
  State<Userfeedback> createState() => _UserfeedbackState();
}

class _UserfeedbackState extends State<Userfeedback> {
  double _rating = 3;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  Future<void> _submitFeedback() async {
    try {
      await FirebaseFirestore.instance.collection('feedback').add({
        'rating': _rating,
        'name': _nameController.text,
        'email': _emailController.text,
        'comments': _commentsController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback submitted successfully')),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return HomeP(currentIndex: 0);
        },
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit feedback: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Feedback'),
      ),
      backgroundColor: Color.fromARGB(255, 255, 248, 227),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          height: 580,
          width: 440,
          child: ListView(
            children: [
              Column(
                children: [
                  const SizedBox(height: 22),
                  const Text(
                    'Rate Us',
                    style: TextStyle(
                        color: Color.fromARGB(186, 19, 7, 7),
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.favorite,
                      color: Color.fromARGB(255, 205, 2, 2),
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField('Name', _nameController, Icons.person),
                  const SizedBox(height: 19),
                  _buildTextField('Email', _emailController, Icons.email),
                  const SizedBox(height: 19),
                  _buildTextField('Add your comments.....', _commentsController,
                      Icons.comment,
                      maxLines: 5),
                  const SizedBox(height: 17),
                  ElevatedButton(
                    onPressed: _submitFeedback,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 166, 15, 15)),
                    ),
                    child: const Text("Submit",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 252, 252))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String hintText, TextEditingController controller, IconData icon,
      {int maxLines = 1}) {
    return Container(
      width: 370,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.grey),
        ),
        maxLines: maxLines,
      ),
    );
  }
}
