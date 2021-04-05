import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class Customer  {
  String id;
  String firstName;
  String lastName;
  String email;
  String password;
  String confirmPassword;
  LatLng location;

  Customer({
        this.id: "",
        this.firstName:"",
        this.lastName: "",
        this.email: "",
        this.password: "",
        this.confirmPassword: "",
        this.location,
  });


  Future <bool> loginToBackend() async {
    Response response = await post("https://dont-wait.herokuapp.com/login",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': email, 'password': password}));

    var jsonResponse = jsonDecode(response.body);
    if(jsonResponse['error'] != null){
      // print(jsonResponse['error']);
      return false;
    }
    else if (jsonResponse['message'] != null){
      print (jsonResponse['message']);
      return true;
    }
    return false;
  }

  Future <bool> signupToBackend() async {
    if( password != confirmPassword) return false ;
    Response response = await post("https://dont-wait.herokuapp.com/signup",
        // Response response = await post("http://10.0.2.2:5000/signup",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'first_name': firstName ,'last_name': lastName, 'email': email, 'password': password,
          "location":{"latitude": this.location.latitude, "longitude":this.location.longitude} }));

    var jsonResponse = jsonDecode(response.body);
    if(jsonResponse['error'] != null){
      // print(jsonResponse['error']);
      return false;
    }
    else if (jsonResponse['message'] != null){
      // print (jsonResponse['message']);
      return true;
    }
    return false;
  }


  Future <bool> isContainShops() async {



    return true;
  }



}
