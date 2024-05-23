

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:myproject/models/items.dart';

// class ServiceTile extends StatefulWidget {
//   final Services services;
//   ServiceTile({Key? key, required this.services}) : super(key: key);

//   @override
//   _ServiceTileState createState() => _ServiceTileState();
// }

// class _ServiceTileState extends State<ServiceTile> {
//   int? enteredValue;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(left: 23),
//       width: 200,
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           AspectRatio(
//             aspectRatio: 14 / 9,
//             child: Image.asset(
//               widget.services.imagepath,
//               fit: BoxFit.contain,
//             ),
//           ),
//           Text(widget.services.name, style: const TextStyle(fontSize: 22)),
//           Text(widget.services.description),
//           Text(widget.services.expiry),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 children: [
//                   Text(widget.services.budget),
//                   if (enteredValue != null)
//                     Text('Highest Bid: $enteredValue'),
//                 ],
//               ),
//               GestureDetector(
//                 onTap: () {
//                   _showInputDialog(context);
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: const BoxDecoration(
//                     color: Colors.black,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(12),
//                       bottomRight: Radius.circular(12),
//                     ),
//                   ),
//                   child: const Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         FontAwesomeIcons.hammer,
//                         color: Colors.white,
//                       ),
                      
                    
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _showInputDialog(BuildContext context) async {
//     int? userInput = await showDialog<int>(
//       context: context,
//       builder: (BuildContext context) {
//         TextEditingController _controller = TextEditingController();

//         return AlertDialog(
//           title: Text('Enter Value'),
//           content: TextField(
//             controller: _controller,
//             decoration: InputDecoration(hintText: 'Enter an integer value'),
//             keyboardType: TextInputType.number,
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 int? value = int.tryParse(_controller.text);
//                 if (value != null) {
//                   setState(() {
//                     enteredValue = value;
//                   });
//                   Navigator.pop(context, value);
//                 } else {
//                   // Show error or handle invalid input
//                 }
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );

//     if (userInput != null) {
//       // Handle the user input here, such as updating state or performing arithmetic operations
//       print('User entered: $userInput');
//     }
//   }
// }



import 'package:flutter/material.dart';

import 'package:myproject/models/items.dart';

class ServiceTile extends StatefulWidget {
  final Services services;
  ServiceTile({Key? key, required this.services}) : super(key: key);

  @override
  _ServiceTileState createState() => _ServiceTileState();
}

class _ServiceTileState extends State<ServiceTile> {
  int? enteredValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IndivService(
            services: widget.services,
          ),
        ),
      ),
      child: Container(
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
              child: Image.asset(
                widget.services.imagepath,
                fit: BoxFit.contain,
              ),
            ),
            Text(widget.services.name, style: const TextStyle(fontSize: 22)),
            Text(widget.services.description),
            Text(widget.services.expiry),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(widget.services.budget),
                    if (enteredValue != null)
                      Text('Highest Bid: $enteredValue'),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    _showInputDialog(context);
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
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      
                        Text(
                          'Bid',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
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
    int? userInput = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _controller = TextEditingController();

        return AlertDialog(
          title: Text('Enter Value'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter an integer value'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                int? value = int.tryParse(_controller.text);
                if (value != null) {
                  setState(() {
                    enteredValue = value;
                  });
                  Navigator.pop(context, value);
                } else {
                  // Show error or handle invalid input
                }
              },
              child: Text('OK'),
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

class IndivService extends StatelessWidget {
  final Services services;

  IndivService({
    required this.services,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(services.name),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.report),
            onPressed: () => _showReportDialog(context),
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
                  width: 411,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(333)),
                  child: Image.asset(services.imagepath),
                ),
                SizedBox(height: 20),
                Text(
                  services.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  services.description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
              
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _showInputDialog(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      
                      Container(height: 44,width: 107,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
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
          ],
        ),
      ),
    );
  }

  Future<void> _showInputDialog(BuildContext context) async {
    int? userInput = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _controller = TextEditingController();

        return AlertDialog(
          title: Text('Enter Value'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter an integer value'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                int? value = int.tryParse(_controller.text);
                if (value != null) {
                  Navigator.pop(context);
                } else {
                  // Show error or handle invalid input
                }
              },
              child: Text('OK'),
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

  Future<void> _showReportDialog(BuildContext context) async {
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
                controller: controller,
                decoration: InputDecoration(hintText: 'Enter your report'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Handle report submission
                  String report = controller.text;
                  print('Report submitted: $report');
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
