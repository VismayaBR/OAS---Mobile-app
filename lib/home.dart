import 'package:flutter/material.dart';

import 'package:myproject/OGhome.dart';
import 'package:myproject/additem.dart';
import 'package:myproject/login.dart';
import 'package:myproject/myauction.dart';
import 'package:myproject/search.dart';
import 'package:myproject/settings.dart';

// ignore: must_be_immutable
class HomeP extends StatefulWidget {
  int currentIndex = 0;
  HomeP({super.key, required this.currentIndex});

  @override
  State<HomeP> createState() => _HomePState();
}

class _HomePState extends State<HomeP> {
  List<Widget> pages = [
    Realhome(),
    MyAuction(),
    AddItem(),
    Search(),
    settings()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 248, 227),

//

/////

        body: Center(
          child: pages[widget.currentIndex],
        ),
       
        appBar: AppBar(
          toolbarHeight: 34,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
        ),
        bottomNavigationBar: MyBottomNavBar(
          currentIndex: widget.currentIndex,
          onTap: (p0) {
            setState(() {
              widget.currentIndex = p0;
            });
          },
        ));
  }
}

// ignore: must_be_immutable
class MyBottomNavBar extends StatelessWidget {
  int currentIndex;
  void Function(int)? onTap;
  MyBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: true,
      unselectedItemColor: Color.fromARGB(255, 0, 0, 0),
      fixedColor: const Color.fromARGB(255, 214, 14, 14),
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          backgroundColor: Color.fromARGB(255, 249, 247, 246),
          label: "home",
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: "MyAuction",
          icon: Icon(Icons.store_mall_directory_rounded),
        ),
        BottomNavigationBarItem(
          label: "add",
          icon: Icon(
            Icons.control_point_duplicate_sharp,
            size: 33,
            color: Color.fromARGB(255, 99, 0, 129),
            weight: 12,
          ),
        ),
        BottomNavigationBarItem(
          label: "search",
          icon: Icon(Icons.search_sharp),
        ),
        BottomNavigationBarItem(
          label: "settings",
          icon: Icon(Icons.settings),
        ),
      ],
    );
  }
}
