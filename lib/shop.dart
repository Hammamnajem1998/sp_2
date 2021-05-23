import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class Shop  {
  String id;
  String name;
  String type;
  LatLng location = LatLng(0,0);
  String photoURL;
  String timeUnit;
  String openAt;
  String closeAt;
  String rating;
  int ratedUsers;
  String userID;


  Shop({
    this.id: '',
    this.name: '',
    this.type: '',
    this.location,
    this.photoURL: '',
    this.timeUnit: '',
    this.openAt: '',
    this.closeAt: '',
    this.rating: '',
    this.ratedUsers: 0,
    this.userID: '',
  });

  Future <bool> getShopInformation() async {

    Response response = await get("https://dont-wait.herokuapp.com/shop/$userID",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['error'] != null ) return false;
    this.id = jsonResponse['id'].toString();
    this.name = jsonResponse['name'];
    this.type = jsonResponse['type'];
    this.location = LatLng(jsonResponse['location']['x'], jsonResponse['location']['y']);
    this.photoURL = jsonResponse['photo'];
    this.timeUnit = jsonResponse['time_unit'].toString();
    this.openAt = jsonResponse['open_at'].toString();
    this.rating = jsonResponse['rating'].toString();
    this.closeAt = jsonResponse['close_at'].toString();
    return true;
  }

  Future <bool> rate(String customerId, double rating) async {

    Response response = await post("https://dont-wait.herokuapp.com/shopRate",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'customer': customerId, 'shop': this.id, 'rating': rating})
    );

    var jsonResponse = jsonDecode(response.body);
    this.rating = jsonResponse['rating'].toString();
    this.ratedUsers = int.parse(jsonResponse['rated_users'].toString());
    print(jsonResponse);
    return true;
  }

}
