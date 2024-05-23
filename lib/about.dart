import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                         Image.asset(
              'assets/mainIcon.png',
              height: 130,
            ),
              SizedBox(height: 20),
             
              Text(
                'Welcome to Our Auction App!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'At Our Auction App, we aim to provide a seamless and secure platform for users to buy and sell items through online auctions. Our mission is to connect buyers and sellers in a transparent and efficient marketplace, where everyone has an equal opportunity to participate in auctions and find great deals on a variety of items.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Our Story',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Founded in 2023, Our Auction App started with a simple idea: to create a trustworthy and user-friendly auction platform that caters to a wide range of interests. From antiques and collectibles to vehicles and electronics, our platform offers something for everyone. We are committed to continually improving our services and ensuring that our users have the best possible experience.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Our Mission',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Our mission is to empower buyers and sellers by providing a reliable and transparent auction platform. We strive to offer a diverse selection of items, fair bidding processes, and exceptional customer service. Our goal is to build a community where users can confidently buy and sell items, knowing that they are part of a safe and supportive marketplace.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Why Choose Us?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '1. **Wide Variety of Items**: Our platform features a diverse range of categories, ensuring that you can find exactly what you\'re looking for.\n'
                '2. **Secure Transactions**: We prioritize the safety of our users by implementing robust security measures to protect your data and transactions.\n'
                '3. **User-Friendly Interface**: Our app is designed with the user in mind, offering an intuitive and easy-to-navigate interface.\n'
                '4. **Customer Support**: Our dedicated support team is here to help you with any questions or issues you may encounter.\n'
                '5. **Community Focused**: We believe in building a community of trust and transparency, where buyers and sellers can connect and thrive.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Contact Us',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'If you have any questions or need assistance, feel free to reach out to our support team at support@ourauctionapp.com. We are here to help and ensure you have the best experience possible.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
             
            ],
          ),
        ),
      ),
    );
  }
}
