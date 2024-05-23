import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myproject/newitem.dart';
import 'package:myproject/newservice.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 252, 225),
      body: Column(
        children: [
          const SizedBox(
            height: 62,
          ),
          const Text(
            'Posting an Listing? Select one from below!',                         
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 23),
          ),
          const SizedBox(
            height: 62,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //items buttons below

              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewItem(),
                    )),
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(
                              5.0,
                              5.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ), //BoxShadow
                        ],
                      ),
                      child:
                       
                      const Column(
                        children: [
                           SizedBox(height: 22,),
                          Icon(
                            Icons.shopping_bag_rounded,
                            size: 68,
                          ),
                          Text(
                            'Items',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 25,
              ),

              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewService(),
                    )),
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(
                              5.0,
                              5.0,
                            ),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ), //BoxShadow
                        ],
                      ),
                      child: const Column(
                        children: [
                          SizedBox(height: 22,),
                          Icon(
                            FontAwesomeIcons.tags,
                            size: 68,
                          ),
                          Text(
                            'Services',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
