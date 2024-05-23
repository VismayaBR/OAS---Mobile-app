import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReciNotif extends StatefulWidget {
  const ReciNotif({Key? key}) : super(key: key);

  @override
  State<ReciNotif> createState() => _ReciNotifState();
}

class _ReciNotifState extends State<ReciNotif> {
  Future<List<Map<String, dynamic>>> _fetchNotifications() async {
    try {
      // Fetch notifications from Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('notification').get();

      // Convert query snapshot to a list of maps
      List<Map<String, dynamic>> notifications =
          querySnapshot.docs.map((doc) => doc.data()).toList();
      SharedPreferences spref = await SharedPreferences.getInstance();
      var name = spref.getString('username');
      // Filter notifications based on type and logged-in user
      notifications = notifications.where((notification) {
        String? type = notification['type'];
        String? user = notification['user'];
        return type == 'global' || user == name;
      }).toList();

      return notifications;
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: const Color.fromARGB(255, 255, 248, 227),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<Map<String, dynamic>> notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return Center(
                child: Text('No new notifications',
                    style: TextStyle(color: Colors.black45, fontSize: 18)));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index];
              return Card(
                child: ListTile(
                  title: Text(notification['notification'] ?? 'No Title'),
                  subtitle: Text(notification['date'] ?? 'No Message'),
                  // Add any additional UI elements for your notification here
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: 4,
        onTap: (p0) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomeP(
              currentIndex: p0,
            ),
          ));
        },
      ),
    );
  }
}
