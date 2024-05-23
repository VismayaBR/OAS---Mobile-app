import 'package:flutter/material.dart';
import 'package:myproject/closedauc.dart';
import 'package:myproject/openauc.dart';

import 'mineauc.dart';



class MyAuction extends StatefulWidget {
  @override
  _MyAuctionState createState() => _MyAuctionState();
}

class _MyAuctionState extends State<MyAuction> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom row for the tab bar
          Container(
            color: const Color.fromARGB(255, 247, 242, 234), // Tab bar background color
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      border: _currentIndex == 0
                          ? const Border(bottom: BorderSide(color: Colors.white, width: 3))
                          : null,
                    ),
                    child: Text(
                      'Open',
                      style: TextStyle(
                        color: _currentIndex == 0 ? Color.fromARGB(255, 240, 84, 0) : Colors.black,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      border: _currentIndex == 1
                          ? Border(bottom: BorderSide(color: Colors.white, width: 3))
                          : null,
                    ),
                    child: Text(
                      'Closed',
                      style: TextStyle(
                        color: _currentIndex == 1 ? Color.fromARGB(255, 138, 71, 0) : Colors.black,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      border: _currentIndex == 2
                          ? Border(bottom: BorderSide(color: Colors.white, width: 3))
                          : null,
                    ),
                    child: Text(
                      'Mine',
                      style: TextStyle(
                        color: _currentIndex == 2 ? Color.fromARGB(255, 152, 73, 0) : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
               OpenAuction(),
           ClosedAuc(),
           MineAuc()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
