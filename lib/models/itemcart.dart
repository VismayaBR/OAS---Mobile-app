import 'package:flutter/material.dart';
import 'package:myproject/models/items.dart';

class Cart extends ChangeNotifier {
//list of itwms fr sale

  List<Items> itemShop = [
    Items(
        name: 'Jackfruit',
        description: '4 ripe jackfruits for sale',
        expiry: '12/22/2022',
        basebid: '300 rs',
        imagepath: 'assets/jack.jpg',
        fulldescription: 'good',
        category: 'food'),
    Items(
        name: 'CB 350',
        description: 'less used bike',
        expiry: '11/11/2011',
        basebid: '123332 rs',
        imagepath: 'assets/cbbike.jpg',
        fulldescription: 'fdsfsaf',
        category: 'weapons'),
    Items(
        name: 'Gramaphone',
        description: 'vintage Item',
        expiry: '11/3/2024',
        basebid: '3313 rs',
        imagepath: 'assets/grama.jpg',
        fulldescription: 'dsafdfafdasfdsf',
        category: 'food'),
  ];

  List<Services> serviceShop = [
    Services(
        name: 'Painting',
        description: 'need to paint house',
        expiry: '11/2/2011',
        budget: '3399 rs',
        imagepath: 'assets/house.jpg',
        category: 'manual labor',
        fulldescription: 'lalalal'),
    Services(
        name: 'make a software',
        description: 'need to a commericial software',
        expiry: '11/4/4444',
        budget: '2330 rs',
        imagepath: 'assets/andro.jpg',
        category: 'naise work',
        fulldescription: 'missile go vroom'),
    Services(
        name: 'River clean',
        description: 'need to clean a river',
        expiry: '33/03/3333',
        budget: '90 rs',
        imagepath: 'assets/gard.jpg',
        category: 'aadf',
        fulldescription:
            'naise river only crocs and piranhas and anacondas hehe')
  ];
//bidded items

  List<Items> myAuctionedThings = [];

//get list of items for sale
  List<Items> getItemList() {
    return itemShop;
  }

  List<Services> getServiceList() {
    return serviceShop;
  }

//get myauction
  List<Items> getUserCart() {
    return myAuctionedThings;
  }

void addItemToCart(Items items){
  myAuctionedThings.add(items);
}
}
