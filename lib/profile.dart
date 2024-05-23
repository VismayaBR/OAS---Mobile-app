import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController _nameController;
  late TextEditingController _occupationController;
  late TextEditingController _phoneController;
  late TextEditingController _placeController;
  var id;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _occupationController = TextEditingController();
    _phoneController = TextEditingController();
    _placeController = TextEditingController();

    getData();
  }

  Future<void> getData() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    setState(() {
      id = spref.getString('user_id');
      _nameController.text = spref.getString('username') ?? '';
      _occupationController.text = spref.getString('occupation') ?? '';
      _phoneController.text = spref.getString('phone') ?? '';
      _placeController.text = spref.getString('place') ?? '';
    });
  }

  Future<void> saveData() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    await spref.setString('username', _nameController.text);
    await spref.setString('occupation', _occupationController.text);
    await spref.setString('phone', _phoneController.text);
    await spref.setString('place', _placeController.text);

    if (id != null) {
      FirebaseFirestore.instance.collection('users').doc(id).update({
        'name': _nameController.text,
        'occupation': _occupationController.text,
        'phone': _phoneController.text,
        'place': _placeController.text,
      });
    } else {
      print('User ID not found in SharedPreferences');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _occupationController.dispose();
    _phoneController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHvZ0pbf4bXvAJgVZVuRQqrNWnoWl96cV6wQ&usqp=CAU'),
              ),
              SizedBox(height: 20),
              _buildTextField('Name', _nameController),
              _buildTextField('Occupation', _occupationController),
              _buildTextField('Phone', _phoneController),
              _buildTextField('Place', _placeController),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Save'),
                onPressed: () {
                  saveData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Profile saved')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
