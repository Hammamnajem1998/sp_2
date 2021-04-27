import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:temp1/shop.dart';

class Queue  {

  Shop shop ;
  List<QueueItem> queueItemsList = <QueueItem>[];

  Future <bool> fillQueueInformation() async {


    Response response = await get("https://dont-wait.herokuapp.com/queue/${shop.id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var jsonResponse = jsonDecode(response.body);

    this.queueItemsList.clear();
    var length = jsonResponse['length'];
    for (int i=0; i < length; i++){
      addQueueItem( jsonResponse['message'][i]['customerID'] );
    }
    return true;
  }

  void addQueueItem (String customerId) async{
    if(customerId != 'none'){
      Response response = await get("https://dont-wait.herokuapp.com/user/$customerId",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      queueItemsList.add(
          QueueItem(
              photoURL: jsonResponse['photo'],
              customerName: jsonResponse['first_name'] + jsonResponse['last_name'],
              customerEmail: jsonResponse['email'],
              shopID: this.shop.id
          )
      );
    } else {
      queueItemsList.add( QueueItem() );
    }
  }
}

class QueueItem {
  String customerName;
  String customerEmail;
  String photoURL;
  String shopID;

  QueueItem({
    this.customerName:'',
    this.customerEmail: '',
    this.photoURL: '',
    this.shopID :'',
  });
}