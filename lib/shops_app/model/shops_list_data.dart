import 'dart:convert';

import 'package:http/http.dart';

import '../../shop.dart';

class ShopListData {
  ShopListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.subTxt = "",
    this.dist = 1.8,
    this.reviews = 80,
    this.rating = 4.5,
    this.perNight = '',
    this.shop
  });

  Shop shop;
  String imagePath;
  String titleTxt;
  String subTxt;
  double dist;
  double rating;
  int reviews;
  String perNight;

}
