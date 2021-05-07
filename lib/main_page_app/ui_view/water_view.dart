import 'dart:convert';

import 'package:http/http.dart';
import 'package:temp1/main_page_app/ui_view/wave_view.dart';
import 'package:temp1/main_page_app/main_page_app_theme.dart';
import 'package:temp1/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../customer.dart';
import '../../shop.dart';

class WaterView extends StatefulWidget {
  const WaterView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation, this.shop, this.customer})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;
  final Shop shop;
  final Customer customer;
  @override
  _WaterViewState createState() => _WaterViewState();
}

class _WaterViewState extends State<WaterView> with TickerProviderStateMixin {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var queueLength  = 0 ;
  var estimatedWaitingTime = 0;
  bool isWaiting = false;
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void initState() {
    super.initState();
    getQueueInformation();

    _firebaseMessaging.subscribeToTopic('temp');
    _firebaseMessaging.configure(
      onMessage: (message) async{
        setState(() {
          if(message['data']['shop_id'] == widget.shop.id){
            getQueueInformation();
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: MainPageAppTheme.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: MainPageAppTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 16, right: 16, bottom: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, bottom: 3),
                                      child: Text(
                                        'Waiting Hall',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: MainPageAppTheme.fontName,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 25,
                                          color: MainPageAppTheme.nearlyDarkBlue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4, top: 2, bottom: 14),
                                  child: Text(
                                    'There are $queueLength people waiting',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: MainPageAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: 0.0,
                                      color: MainPageAppTheme.darkText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 4, right: 4, top: 8, bottom: 16),
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  color: MainPageAppTheme.background,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Icon(
                                          Icons.access_time,
                                          color: MainPageAppTheme.grey
                                              .withOpacity(0.5),
                                          size: 16,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          'Estimating $estimatedWaitingTime min',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                                MainPageAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            color: MainPageAppTheme.grey
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            isWaiting ?
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Image.asset(
                                        'assets/fitness_app/bell.png'),
                                  ),
                                  Flexible(
                                    child: Text(
                                      'When your turn, you will notified !.',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily:
                                        MainPageAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        letterSpacing: 0.0,
                                        color: HexColor('#F65283'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ) :
                            SizedBox(),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 34,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: MainPageAppTheme.nearlyWhite,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: MainPageAppTheme.nearlyDarkBlue
                                          .withOpacity(0.4),
                                      offset: const Offset(4.0, 4.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: InkWell(
                                  onTap: () async {
                                    if(!isWaiting){
                                      addToQueueDataBase();
                                      setState(() {
                                        isWaiting = true;
                                      });
                                    }
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: MainPageAppTheme.nearlyDarkBlue,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 28,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: MainPageAppTheme.nearlyWhite,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: MainPageAppTheme.nearlyDarkBlue
                                          .withOpacity(0.4),
                                      offset: const Offset(4.0, 4.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: InkWell(
                                  onTap: () async {
                                    deleteFromQueueDataBase();
                                  },
                                  child: Icon(
                                    Icons.remove,
                                    color: MainPageAppTheme.nearlyDarkBlue,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16, right: 8, top: 16),
                        child: Container(
                          width: 60,
                          height: 160,
                          decoration: BoxDecoration(
                            color: HexColor('#E8EDFE'),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(80.0),
                                bottomLeft: Radius.circular(80.0),
                                bottomRight: Radius.circular(80.0),
                                topRight: Radius.circular(80.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: MainPageAppTheme.grey.withOpacity(0.4),
                                  offset: const Offset(2, 2),
                                  blurRadius: 4),
                            ],
                          ),
                          child: WaveView(
                            percentageValue: queueLength*20.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  Future<void> getQueueInformation() async{
    var shopID = widget.shop.id;
    Response response = await get("https://dont-wait.herokuapp.com/queue/$shopID",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var jsonResponse = await jsonDecode(response.body);
    var length = jsonResponse['length'];
    if(length != null){
      setState(() {
        queueLength = length;
        estimatedWaitingTime = length * int.parse(widget.shop.timeUnit);
      });
    }
    return true;
  }

  void addToQueueDataBase() async{
    Response response = await post("https://dont-wait.herokuapp.com/addToQueue",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'isFromOwner': 'false' ,
          'shop_id': widget.shop.id,
          'customer_id' : widget.customer.id
        }));
  }

  void deleteFromQueueDataBase() async{
    Response response = await delete("https://dont-wait.herokuapp.com/queue/${widget.shop.id}/${widget.customer.id}",
      headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
    );
  }
}
