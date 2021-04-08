import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class Shop  {
  String id;
  String name;
  String type;
  LatLng location;
  String photoURL;
  String timeUnit;
  String openAt;
  String closeAt;
  String userID;


  Shop({
    this.id: "",
    this.name:"",
    this.type: "",
    this.location,
    this.photoURL: "",
    this.timeUnit: "",
    this.openAt: "",
    this.closeAt:'',
    this.userID :'',
  });

  Future <bool> getShopInformation() async {

    Response response = await get("https://dont-wait.herokuapp.com/shop/$userID",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var jsonResponse = jsonDecode(response.body);

    this.id = jsonResponse['id'].toString();
    this.name = jsonResponse['name'];
    this.type = jsonResponse['type'];
    this.location = LatLng(jsonResponse['location']['x'], jsonResponse['location']['y']);
    this.photoURL = jsonResponse['photo'];
    this.timeUnit = jsonResponse['time_unit'].toString();
    this.openAt = jsonResponse['open_at'].toString();
    this.closeAt = jsonResponse['close_at'].toString();

    return true;
  }

}
