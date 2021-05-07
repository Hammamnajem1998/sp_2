import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:temp1/main_page_app/ui_view/queue_item_view.dart';
import 'package:temp1/shops_app/shops_app_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:temp1/queue_item.dart';
import 'package:temp1/shop.dart';

class CareerQueue extends StatefulWidget {
  CareerQueue({Key key, this.title, this.shop}) : super(key: key);
  final String title;
  final Shop shop;
  @override
  _CareerQueueState createState() => _CareerQueueState();
}

class _CareerQueueState extends State<CareerQueue> {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<QueueItemView> queueItemsListUI = <QueueItemView>[];
  List<QueueItem> queueItemsList = <QueueItem>[];
  Future<bool> updateListView;

  @override
  void initState() {
    super.initState();
    updateListView = getData();

    _firebaseMessaging.subscribeToTopic('temp');
    _firebaseMessaging.configure(
      onMessage: (message) async{
        setState(() {
          if(message['data']['shop_id'] == widget.shop.id){
            getData();
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _firebaseMessaging.unsubscribeFromTopic('temp');
    super.dispose();
  }


  Future<bool> getData() async {

    await getQueueInformation();
    fillQueueItemsListUI();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: getAppBarUI(),
      body: Container(
        margin: const EdgeInsets.only(top: 0),
        color: ShopAppTheme.buildLightTheme().backgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Column(
               children: [
                 getQueueItemViews(),
               ],
              )
            ]
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _asyncInputDialog(context).then((customerName) => {
                addToQueueDataBase(customerName),
              });
            },
            child: const Icon(Icons.add, size: 30),
            backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          ),
        ),
      )

    );
  }

  Widget getQueueItemViews(){
    return FutureBuilder<bool>(
      future: updateListView,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: this.queueItemsListUI.length,
                itemBuilder: (BuildContext context, int index) {
                  return queueItemsListUI[index];
                },
              ),
          );
        }
      },
    );
  }

  Future<bool> getQueueInformation() async{
    var shopID = widget.shop.id;
    Response response = await get("https://dont-wait.herokuapp.com/queue/$shopID",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var jsonResponse = await jsonDecode(response.body);
    // print(jsonResponse);
    if(jsonResponse['error'] != null) return false;
    addQueueItems( jsonResponse );
    return true;
  }

  void addQueueItems (queueResponse) {
    this.queueItemsList.clear();
    var length = queueResponse['length'];
    var queue = queueResponse['message'];
    for (int i=0 ; i< length ; i++){
      queueItemsList.add(
          QueueItem(
            photoURL: queue[i]['photo'],
            customerName: '${queue[i]['first_name']} ',//${queue['message'][i]['last_name']}',
            customerEmail: queue[i]['email'],
            customerID: queue[i]['customerID'],
            shopID: widget.shop.id,
          )
      );
    }
  }

  void addToQueueDataBase(String customer) async{
    Response response = await post("https://dont-wait.herokuapp.com/addToQueue",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'isFromOwner': 'true' ,
          'shop_id': widget.shop.id,
          'user_name' : customer,
          'customer_id' : 'none'
        }));
  }

  void fillQueueItemsListUI(){

    setState(() {
      this.queueItemsListUI.clear();
      for(int i =0 ; i< this.queueItemsList.length ; i++){
        this.queueItemsListUI.add(
          QueueItemView(
            photoURL: this.queueItemsList[i].photoURL,
            title: this.queueItemsList[i].customerName,
            subTitle: this.queueItemsList[i].customerEmail,
            customerID: this.queueItemsList[i].customerID,
            shopID: widget.shop.id,
          ),
        );
      }
    });
  }

  Widget getAppBarUI() {
    return PreferredSize(
        preferredSize: const Size(double.infinity, kToolbarHeight),
        child:Container(
          decoration: BoxDecoration(
            color: ShopAppTheme.buildLightTheme().backgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  offset: const Offset(0, 2),
                  blurRadius: 4.0),
            ],
          ),
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, left: 8, right: 8),
          child: Row(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                width: AppBar().preferredSize.height + 40,
                height: AppBar().preferredSize.height,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 21,
                    ),
                  ),
                ),
              ),
              Container(
                width: AppBar().preferredSize.height + 40,
                height: AppBar().preferredSize.height,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _asyncInputDialog(BuildContext context) {
    String customerName = '';
    return showDialog(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter new customer name'),
          content: new Row(
            children: [
              new Expanded(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Customer Name', hintText: 'Jone Smith'),
                    onChanged: (value) {
                      customerName = value;
                    },
                  ))
            ],
          ),
          actions: [
            FlatButton(
              child: Text('Add'),
              onPressed: () {
                Navigator.of(context).pop(customerName);
              },
            ),
          ],
        );
      },
    );
  }
}