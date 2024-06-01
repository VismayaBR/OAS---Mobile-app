import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:myproject/components/Item_tiles.dart';
import 'package:myproject/components/service_tile.dart';
import 'package:myproject/models/itemcart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Realhome extends StatefulWidget {
  const Realhome({Key? key}) : super(key: key);

  @override
  State<Realhome> createState() => _RealhomeState();
}

class _RealhomeState extends State<Realhome> {
    var bid = TextEditingController();

  Future<void> postData(title,duration, image) async {
    
    SharedPreferences spref = await SharedPreferences.getInstance();
    var id = spref.getString('user_id');
    var name = spref.getString('username');
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);

    FirebaseFirestore.instance.collection('bid_collection').add({
      'user_id': id,
      'username': name,
      'bid': bid.text,
      'date': formattedDate,
      'name':title,
      'image':image,
      'duration':duration
    });
  }
  Future<List<Map<String, dynamic>>> getItems() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('items').where('status',isEqualTo: "0").get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }
   Future<List<Map<String, dynamic>>> getServices() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('services').where('status',isEqualTo: "0").get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, value, child) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 23),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular picks",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     // Implement navigation to a detailed list view
                    //   },
                    //   child: Text(
                    //     "see all",
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.blue,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: getItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 290,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return const SizedBox(
                      height: 290,
                      child: Center(child: Text('Error loading data')),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return const SizedBox(
                      height: 290,
                      child: Center(child: Text('No items found')),
                    );
                  } else {
                    return SizedBox(
                      height: 290,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var data = snapshot.data![index];
                          return Container(
                            margin: const EdgeInsets.only(left: 23),
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AspectRatio(
                                  aspectRatio: 14 / 9,
                                  child: GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => IndivItem(
                                         
                                          title: data['title'],
                                          description:data['description'],
                                          duration:data['duration'],
                                          details:data['summary'],
                                          image:data['images'],
                                          amount:data['amount'].toString(),
                                          type:'item',
                                          number:data['mobile']

                                        ),
                                      ),
                                    ),
                                    child: Image.network(
                                        data['images'] ?? 'default_image.png',
                                        fit: BoxFit.contain),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(data['title'] ?? 'No Name',
                                      style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w500)),
                                ),
                                      Text(data['category'] ?? 'No Name'),
                                Expanded(child: SizedBox(
                                  height: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(data['summary'] ?? 'No Name'),
                                  ))),
                              
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        // Text(widget.items.basebid),
                                        // if (enteredValue != null) Text('Highest Bid: $enteredValue'),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _showInputDialog(data['title'],data['duration'],data['images'],data['amount']); // Pass the cart object to the dialog
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          'Bid',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              
                              ],
                            ),
                          );
                          
                          // return ItemTiles(
                          // items: {
                          //   'id': data['id'] ?? '',
                          //   'name': data['name'] ?? 'No Name',
                          //   'price': data['price'] ?? 0.0,
                          //   'description': data['description'] ?? 'No Description',
                          //   'imageUrl': data['imageUrl'] ?? 'default_image.png',
                          // }
                          // );
                        },
                      ),
                    );
                  }
                },
              ),

              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Divider(),
              ),
                const SizedBox(height: 12),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: getServices(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return const SizedBox(
                      height: 290,
                      child: Center(child: Text('Error loading data')),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return const SizedBox(
                      height: 290,
                      child: Center(child: Text('No Services found')),
                    );
                  } else {
                    return SizedBox(
                      height: 290,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var data = snapshot.data![index];
                          return Container(
                            margin: const EdgeInsets.only(left: 23),
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AspectRatio(
                                  aspectRatio: 14 / 9,
                                  child: GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => IndivItem( 
                                            title: data['title'],
                                          description:data['description'],
                                          amount:data['amount'].toString(),
                                          duration:data['duration'],
                                          details:data['summary'],
                                          image:data['images'],
                                          type:'service',
                                          number:data['mobile']
                                        ),
                                      ),
                                    ),
                                    child: Image.network(
                                        data['images'] ?? 'default_image.png',
                                        fit: BoxFit.contain),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(data['title'] ?? 'No Name',
                                      style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w500)),
                                ),
                                Expanded(child: SizedBox(
                                  height: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(data['summary'] ?? 'No Name'),
                                  ))),
                              
                                // Text(data['category'] ?? 'No Name'),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        // Text(widget.items.basebid),
                                        // if (enteredValue != null) Text('Highest Bid: $enteredValue'),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _showInputDialog1(data['title'],data['duration'],data['images'],data['amount']); // Pass the cart object to the dialog
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          'Bid',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              
                              ],
                            ),
                          );
                          
                          // return ItemTiles(
                          // items: {
                          //   'id': data['id'] ?? '',
                          //   'name': data['name'] ?? 'No Name',
                          //   'price': data['price'] ?? 0.0,
                          //   'description': data['description'] ?? 'No Description',
                          //   'imageUrl': data['imageUrl'] ?? 'default_image.png',
                          // }
                          // );
                        },
                      ),
                    );
                  }
                },
              ),
              // Similar section for services goes here
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _showInputDialog(title,duration, image, amount) async {
    int? userInput = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();

        return AlertDialog(
          title: const Text('Enter Value'),
          content: TextField(
            controller: bid,
            decoration: const InputDecoration(hintText: 'Enter your bid'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                int? value = int.tryParse(bid.text);
                if (value != null) {
                  if(value>amount){
                     postData(title,duration,image);
                  }
                 else{
                  Fluttertoast.showToast(msg: 'Please check the starting amount!'); 
                 }
                  Navigator.pop(context);
                } else {
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter number')));
                }
              },
              child: const Text('Bid'),
            ),
          ],
        );
      },
    );

    if (userInput != null) {
      // Handle the user input here, such as updating state or performing arithmetic operations
      print('User entered: $userInput');
    }
  }

Future<void> _showInputDialog1(title,duration, image, amount) async {
    int? userInput = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();

        return AlertDialog(
          title: const Text('Enter Value'),
          content: TextField(
            controller: bid,
            decoration: const InputDecoration(hintText: 'Enter your bid'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                int? value = int.tryParse(bid.text);
                if (value != null) {
                  if(value<amount){
                     postData(title,duration,image);
                  }
                 else{
                  Fluttertoast.showToast(msg: 'Please check the maximum amount!'); 
                 }
                  Navigator.pop(context);
                } else {
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter number')));
                }
              },
              child: const Text('Bid'),
            ),
          ],
        );
      },
    );

    if (userInput != null) {
      // Handle the user input here, such as updating state or performing arithmetic operations
      print('User entered: $userInput');
    }
  }


}
