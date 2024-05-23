import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/components/Item_tiles.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final bid = TextEditingController();
  int _selectedCategoryIndex = 0;
  final List<String> categories = ['Vehicles', 'Antique', 'others'];
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Method to fetch items from Firestore
  Future<List<Map<String, dynamic>>> getItems() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('items').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  // Method to fetch the highest bid for a specific item
  Future<double?> bidValue(String itemName) async {
    print('Fetching highest bid for $itemName...');

    final querySnapshot = await FirebaseFirestore.instance
        .collection('bid_collection')
        .where('name', isEqualTo: itemName)
        .get();

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
      return null;
    }

    final maxBid = bids.reduce((a, b) => a > b ? a : b);
    print('Highest bid: $maxBid');
    return maxBid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: List<Widget>.generate(categories.length, (index) {
              return _CategoryButton(
                label: categories[index],
                isActive: _selectedCategoryIndex == index,
                onTap: () => _selectCategory(index),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 50,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: getItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  var filteredItems = snapshot.data!
                      .where((item) =>
                          item['category'] ==
                              categories[_selectedCategoryIndex] &&
                          item['title']
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()))
                      .toList();
                  return ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final name = item['title'] ?? 'Unnamed Item';
                      final category = item['category'] ?? 'Uncategorized';
                      final imageUrl = item['images'] ?? '';

                      return Card(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 150,
                                width: 150,
                                child: imageUrl.isNotEmpty
                                    ? Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                      )
                                    : Placeholder(), // Placeholder for null image URLs
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'Date till: ${item['duration']}',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  FutureBuilder<double?>(
                                    future: bidValue(item['title']),
                                    builder: (context, maxBidSnapshot) {
                                      if (maxBidSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text('Fetching highest bid...');
                                      } else if (maxBidSnapshot.hasError) {
                                        return Text(
                                            'Error fetching highest bid');
                                      } else {
                                        return Text(
                                            'Highest Bid: ${maxBidSnapshot.data ?? 'No bids'}');
                                      }
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return IndivItem(
                                            title: item['title'],
                                            description: item['description'],
                                            duration: item['duration'],
                                            details: item['summary'],
                                            image: item['images'],
                                            amount: item['amount'].toString(),
                                          );
                                        },
                                      ));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
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
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text("No items found."));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _selectCategory(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
  }
}

class _CategoryButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _CategoryButton({
    Key? key,
    required this.label,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive ? Color.fromARGB(255, 239, 227, 189) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
