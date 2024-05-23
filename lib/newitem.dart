import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myproject/components/my_textfield.dart';
import 'package:myproject/home.dart';
import 'package:path/path.dart' as Path;

class NewItem extends StatefulWidget {
  const NewItem({Key? key}) : super(key: key);

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
Future<String?> _uploadImages() async {
  String? downloadUrl;  // Declare outside the loop to ensure it's accessible for return.
  try {
    for (var file in images.whereType<File>()) {  // Even if multiple, we handle like a single one.
      var fileName = Path.basename(file.path);
      var storageRef = FirebaseStorage.instance.ref().child('images/$fileName');
      var taskSnapshot = await storageRef.putFile(file);
      downloadUrl = await taskSnapshot.ref.getDownloadURL();  // Get the URL of the uploaded file.
    }
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Failed to upload images: $e",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
    return null;  // Return null if there's an error during upload.
  }
  return downloadUrl;  // Return the URL if successful, or null if there were no images.
}


  Future<void> addItemToFirestore(
      String title,
      String summary,
      String description,
      String category,
      String duration,
      double amount) async {
    var imageUrl = await _uploadImages();
    CollectionReference items = FirebaseFirestore.instance.collection('items');

    await items.add({
      'title': title,
      'summary': summary,
      'description': description,
      'images': imageUrl,
      'category': category,
      'amount': amount,
      'duration':duration,
      'timestamp': FieldValue.serverTimestamp(),
    });

    Fluttertoast.showToast(
      msg: "Item successfully added",
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return HomeP(currentIndex: 0);
    },));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        durationController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  List<File?> images = [];
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  List<String> categories = ['Vehicles', 'Antique', 'others']; // Example categories
  String? selectedCategory;

  final titleController = TextEditingController();
  final summaryController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final amountController = TextEditingController();
  final durationController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    summaryController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    amountController.dispose();
    durationController.dispose();
    super.dispose();
  }

  Future<void> pickImages() async {
    final List<XFile?> pickedFiles = await _picker.pickMultiImage();
    setState(() {
      images = pickedFiles.map((file) => file != null ? File(file.path) : null).toList();
    });
  }

  void submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      addItemToFirestore(
        titleController.text,
        summaryController.text,
        descriptionController.text,
        selectedCategory!,
        durationController.text,
        double.parse(amountController.text),
        
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 248, 227),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 60,
                ),
                GestureDetector(
                  onTap: pickImages,
                  child: Container(
                    height: 133,
                    width: 133,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(54, 105, 240, 175),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.image,
                      size: 33,
                    ),
                  ),
                ),
                if (images.isNotEmpty)
                  Column(
                    children: images.map((image) {
                      return image == null
                          ? const Text("No Image selected")
                          : Image.file(image!);
                    }).toList(),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 190, 190, 190))),
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                      hintText: 'Title',
                    ),
                    controller: titleController,
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 190, 190, 190))),
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                      hintText: 'Summary',
                    ),
                    controller: summaryController,
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a summary';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 190, 190, 190))),
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                      hintText: 'Detailed Description',
                    ),
                    controller: descriptionController,
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a detailed description';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 190, 190, 190)),
                      ),
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                      hintText: 'Select Category',
                    ),
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a category' : null,
                    items: categories
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 190, 190, 190))),
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                      hintText: 'Base Amount',
                    ),
                    controller: amountController,
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a base amount';
                      } else if (double.tryParse(value) == null) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: durationController,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 190, 190, 190)),
                            ),
                            fillColor: const Color.fromARGB(255, 255, 255, 255),
                            filled: true,
                            hintText: 'Duration',
                          ),
                          readOnly: true, // Make this field read-only
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a duration';
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    submitForm();
                  },
                  child: Container(
                    width: 320,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      borderRadius: BorderRadiusDirectional.circular(10),
                    ),
                    padding: const EdgeInsets.all(9),
                    child: const Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Color.fromARGB(255, 199, 237, 255),
                            fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomeP(currentIndex: index),
          ));
        },
      ),
    );
  }
}
