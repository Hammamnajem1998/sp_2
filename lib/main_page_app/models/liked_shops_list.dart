import 'package:temp1/customer.dart';
import '../../shop.dart';

class LikedShopsListData {
  LikedShopsListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.meals,
    this.kacl = 0,
    this.shop,
    this.customer
  });

  Shop shop;
  Customer customer;
  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String> meals;
  double kacl;

}
