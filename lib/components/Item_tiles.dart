import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:myproject/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndivItem extends StatefulWidget {
  final String title;
  final String description;
  final String image;
  final String duration;
  final String details;
  final String amount;
  final String type;
  final String number;

  IndivItem({
    required this.title,
    required this.image,
    required this.description,
    required this.duration,
    required this.details,
    required this.amount,
    required this.type, 
    required this.number,
  });

  @override
  State<IndivItem> createState() => _IndivItemState();
}

class _IndivItemState extends State<IndivItem> {
  late Future<double?> _futureMaxBid;
  final bid = TextEditingController();
  var report = TextEditingController();

Future<double?> bidValue() async {
    print('Fetching bid value...');

    // Fetching the documents from Firestore
    final querySnapshot = await FirebaseFirestore.instance
        .collection('bid_collection')
        .where('name', isEqualTo: widget.title)
        .get();

    // Extracting bid values
    final bids = querySnapshot.docs
        .map((doc) => doc.data()['bid'] is double
            ? doc.data()['bid'] as double
            : double.tryParse(doc.data()['bid'].toString()) ?? 0.0)
        .toList();

    if (bids.isEmpty) {
      return null; // Handle the case where no bids are found
    }

    // Sorting the bid values
    bids.sort();

    if (widget.type == 'service') {
      // Show the lowest bid for services
      return bids.first;
    } else {
      // Show the highest bid for other types
      return bids.last;
    }
  }

  Future<void> postData() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    var id = spref.getString('user_id');
    var name = spref.getString('username');
      
      // var number = spref.getString('phone');
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);

    FirebaseFirestore.instance.collection('bid_collection').add({
      'user_id': id,
      'username': name,
      'bid': double.parse(bid.text),
      'date': formattedDate,
      'name': widget.title,
      'duration': widget.duration,
      'image': widget.image,
      'mobile':widget.number
    });
  }

  @override
  void initState() {
    super.initState();
    _futureMaxBid = bidValue();
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    DateTime bidEndDate = dateFormat.parse(widget.duration);
    DateTime currentDate = DateTime.now();

    bool isBidClosed = currentDate.isAfter(bidEndDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.report),
            onPressed: () => _showReportDialog(widget.title),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(11.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.network(widget.image, fit: BoxFit.cover),
                ),
                SizedBox(height: 20),
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date till',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      widget.duration,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  widget.description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bid starts from',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      widget.amount,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                FutureBuilder<double?>(
                  future: _futureMaxBid,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Text('No bids found');
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.type == 'service'
                                ? 'Lowest bid'
                                : 'Highest bid',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '${snapshot.data!.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: isBidClosed
                      ? null
                      : () => _showInputDialog1(widget.amount),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 44,
                        width: 107,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: isBidClosed ? Colors.grey : Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            isBidClosed ? 'Bid Closed' : 'Bid',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showInputDialog(BuildContext context) async {
    await showDialog<int>(
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
                  postData();
                  setState(() {
                    _futureMaxBid = bidValue();
                  });
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return HomeP(currentIndex: 0);
                    },
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a number')),
                  );
                }
              },
              child: const Text('Bid'),
            ),
          ],
        );
      },
    );
  }
  

  Future<void> _showInputDialog1(amount) async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();

        return AlertDialog(
          title: const Text('Enter Value'),
          content: TextField(
            controller: bid,
            decoration:
                const InputDecoration(hintText: 'Enter your bid amount'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            widget.type=='service'?
            TextButton(
              onPressed: () {
                // Parse the bid value from the text input
                int? value = int.tryParse(bid.text.replaceAll(',', '').trim());

                // Check if the value is valid
                if (value != null) {
                  // Parse the starting amount and compare the bid value
                  var amt = double.tryParse(amount.replaceAll(',', '').trim());
                  if (amt != null && value < amt) {
                    postData();
                    Navigator.pop(context);
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Please check the maximum amount!');
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid number')),
                  );
                }
              },
              child: const Text('Bid'),
            ):
            TextButton(
              onPressed: () {
                // Parse the bid value from the text input
                int? value = int.tryParse(bid.text.replaceAll(',', '').trim());

                // Check if the value is valid
                if (value != null) {
                  // Parse the starting amount and compare the bid value
                  var amt = double.tryParse(amount.replaceAll(',', '').trim());
                  if (amt != null && value > amt) {
                    postData();
                    Navigator.pop(context);
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Please check the maximum amount!');
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid number')),
                  );
                }
              },
              child: const Text('Bid'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showReportDialog(title) async {
    TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Report'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: report,
                decoration: InputDecoration(hintText: 'Enter your report'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences spref =
                      await SharedPreferences.getInstance();
                  var user = spref.getString('username');
                  FirebaseFirestore.instance.collection('report').add(
                      {'user': user, 'report': report.text, 'item': title});
                  // Handle report submission
                  print('Report submitted...');
                  Navigator.pop(context);
                },
                child: Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }
}
