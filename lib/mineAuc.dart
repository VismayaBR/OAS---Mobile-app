import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MineAuc extends StatefulWidget {
  const MineAuc({Key? key}) : super(key: key);

  @override
  State<MineAuc> createState() => _MineAucState();
}

class _MineAucState extends State<MineAuc> {
  Future<List<Map<String, dynamic>>> _fetchData() async {
    try {
      // Fetch winner data
      QuerySnapshot<Map<String, dynamic>> winnerSnapshot =
          await FirebaseFirestore.instance.collection('winner').get();

      List<Map<String, dynamic>> winners = winnerSnapshot.docs
          .map((doc) => {'winnerId': doc.id, ...doc.data()})
          .toList();

      // Fetch bid data
      QuerySnapshot<Map<String, dynamic>> bidSnapshot =
          await FirebaseFirestore.instance.collection('bid_collection').get();

      Map<String, Map<String, dynamic>> bids = {
        for (var doc in bidSnapshot.docs) doc.id: doc.data()
      };

      // Filter bid data based on the item name
      List<Map<String, dynamic>> filteredBids = bidSnapshot.docs
          .map((doc) => {'bidId': doc.id, ...doc.data()})
          .where((bid) =>
              winners.any((winner) => winner['item'] == bid['name']))
          .toList();

      // Combine data from both collections
      List<Map<String, dynamic>> combinedData = winners.map((winner) {
        var relatedBid = filteredBids.firstWhere(
            (bid) => bid['name'] == winner['item'],
            orElse: () => {});
        return {
          'bid': winner['bid'],
          'item': winner['item'],
          'details': relatedBid,
        };
      }).toList();

      return combinedData;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No winners found'));
          }

          List<Map<String, dynamic>> data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var item = data[index];
              return Card(
                child: SizedBox(
                  height: 150,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Image.network(item['details']['image'] ?? '', fit: BoxFit.fill),
                          height: 120,
                          width: 120,
                          color: Colors.amber, // Placeholder color
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              
                                Text(item['details']['name'] ?? 'No Name',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                                SizedBox(width: 50,child: Image.asset('assets/winner.png',fit: BoxFit.cover,),)
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Duration :' ?? 'Duration N/A'),
                                  Text(item['details']['duration']?.toString() ?? 'Duration N/A',style: TextStyle(color: Colors.red),),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('My Bid :'),
                                  Text('${item['bid']}',)
                                ],
                              ),
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
    );
  }
}
