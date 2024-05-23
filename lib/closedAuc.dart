import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClosedAuc extends StatefulWidget {
  const ClosedAuc({super.key});

  @override
  State<ClosedAuc> createState() => _ClosedAucState();
}

class _ClosedAucState extends State<ClosedAuc> {
  late Future<double?> _futureMaxBid;
  final bid = TextEditingController();

  Future<double?> bidValue(String itemName) async {
    print('Fetching highest bid for $itemName...');

    // Fetching the documents from Firestore
    final querySnapshot = await FirebaseFirestore.instance
        .collection('bid_collection')
        .where('name', isEqualTo: itemName)
        .get();

    // Extracting bid values and finding the maximum bid
    final bids = querySnapshot.docs.map((doc) {
      var bid = doc.data()['bid'];
      if (bid is String) {
        return double.tryParse(bid) ?? 0.0;
      } else if (bid is num) {
        return bid.toDouble();
      } else {
        return 0.0;
      }
    }).toList();

    if (bids.isEmpty) {
      return null; // Handle the case where no bids are found
    }

    final maxBid = bids.reduce((a, b) => a > b ? a : b);
    print('Highest bid: $maxBid');
    return maxBid;
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    print('Current Date: $formattedDate');

    try {
      final spref = await SharedPreferences.getInstance();
      final userId = spref.getString('user_id');

      if (userId == null) {
        throw Exception('User ID not found in SharedPreferences'); // Handle missing ID
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('bid_collection')
          .where('user_id', isEqualTo: userId)
          .where('duration', isLessThan: formattedDate)
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: getItems(), // Correct function name here
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading data'));
            } else if (snapshot.data!.isEmpty) {
              return Center(child: Text('No items found'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length, // Define itemCount
              itemBuilder: (context, index) {
                var data = snapshot.data![index]; // Access each item's data
                return Card(
                  child: SizedBox(
                    height: 150,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Image.network(data['image'], fit: BoxFit.fill),
                            height: 120,
                            width: 120,
                            color: Colors.amber, // Placeholder color
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 6,),
                                  Text(data['name'] ?? 'No Name',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Duration :' ?? 'Duration N/A'),
                                      Text(data['duration']?.toString() ?? 'Duration N/A',style: TextStyle(color: Colors.red),),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                     Text('My Bid :'),
                                    Text('${data['bid']}',)
                                  ],
                                ),
                              ),
                              FutureBuilder<double?>(
                                future: bidValue(data['name']),
                                builder: (context, maxBidSnapshot) {
                                  if (maxBidSnapshot.connectionState == ConnectionState.waiting) {
                                    return Text('Fetching highest bid...');
                                  } else if (maxBidSnapshot.hasError) {
                                    return Text('Error fetching highest bid');
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Highest Bid :'),
                                          Text('${maxBidSnapshot.data ?? 'No bids'}',style: TextStyle(color: Colors.green),),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
