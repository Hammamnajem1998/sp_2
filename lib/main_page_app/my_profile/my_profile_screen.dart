import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:temp1/main_page_app/ui_view/body_measurement.dart';
import 'package:temp1/main_page_app/ui_view/glass_view.dart';
import 'package:temp1/main_page_app/ui_view/mediterranesn_diet_view.dart';
import 'package:temp1/main_page_app/ui_view/title_view.dart';
import 'package:temp1/main_page_app/ui_view/map_view.dart';
import 'package:temp1/main_page_app/main_page_app_theme.dart';
import 'package:temp1/main_page_app/my_profile//meals_list_view.dart';
import 'package:temp1/main_page_app/my_profile//water_view.dart';
import 'package:flutter/material.dart';
import 'dart:convert';


class MyProfileScreen extends StatefulWidget {

  final AnimationController animationController;
  final String email;
  MyProfileScreen({Key key, @required this.email, this.animationController}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen>
    with TickerProviderStateMixin {

  String firstName = '', lastName = '', password = '';
  LatLng location = LatLng(0, 0);

  Animation<double> topBarAnimation;
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    const int count = 9;

      listViews.clear();
      listViews.add(
        TitleView(
          titleTxt: 'First Name:',
          email: widget.email,
          subTxt: firstName,
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: widget.animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController,
        ),
      );

      listViews.add(
        TitleView(
          titleTxt: 'Last Name:',
          subTxt: lastName,
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: widget.animationController,
              curve:
              Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController,
        ),
      );

      listViews.add(
        MediterranesnDietView(
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: widget.animationController,
              curve:
                  Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController,
        ),
      );

      listViews.add(
        MealsListView(
          mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: widget.animationController,
                  curve: Interval((1 / count) * 3, 1.0,
                      curve: Curves.fastOutSlowIn))),
          mainScreenAnimationController: widget.animationController,
        ),
      );

      listViews.add(
        TitleView(
          titleTxt: 'Email:',
          subTxt: widget.email,
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: widget.animationController,
              curve:
              Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController,
        ),
      );

      listViews.add(
        TitleView(
          titleTxt: 'Password:',
          subTxt: password,
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: widget.animationController,
              curve:
              Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController,
        ),
      );

      listViews.add(
        TitleView(
          titleTxt: 'Location:',
          subTxt: 'Change',
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: widget.animationController,
              curve:
              Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController,
        ),
      );

    // listViews.add(
    //   TitleView(
    //     titleTxt: 'Body measurement',
    //     subTxt: 'Today',
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve:
    //             Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController,
    //   ),
    // );
    //
    // listViews.add(
    //   BodyMeasurementView(
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve:
    //             Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController,
    //   ),
    // );
    // listViews.add(
    //   TitleView(
    //     titleTxt: 'Water',
    //     subTxt: 'Aqua SmartBottle',
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController,
    //         curve:
    //             Interval((1 / count) * 6, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController,
    //   ),
    // );
    //
    // listViews.add(
    //   WaterView(
    //     mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
    //         CurvedAnimation(
    //             parent: widget.animationController,
    //             curve: Interval((1 / count) * 7, 1.0,
    //                 curve: Curves.fastOutSlowIn))),
    //     mainScreenAnimationController: widget.animationController,
    //   ),
    // );
    // listViews.add(
    //   GlassView(
    //       animation: Tween<double>(begin: 0.0, end: 1.0).animate(
    //           CurvedAnimation(
    //               parent: widget.animationController,
    //               curve: Interval((1 / count) * 8, 1.0,
    //                   curve: Curves.fastOutSlowIn))),
    //       animationController: widget.animationController),
    // );

  }

  Future<bool> getData() async {
    //await Future<dynamic>.delayed(const Duration(milliseconds: 50));

    String userEmail = widget.email;
    Response response = await get("https://dont-wait.herokuapp.com/user/$userEmail",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var jsonResponse = jsonDecode(response.body);

    this.firstName = jsonResponse['first_name'];
    this.lastName = jsonResponse['last_name'];
    this.password = jsonResponse['password'];
    this.location = LatLng(jsonResponse['location']['x'], jsonResponse['location']['y']);

    addAllListData();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MainPageAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
           // getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: MainPageAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: MainPageAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'My Diary',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: MainPageAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: MainPageAppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {},
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_left,
                                    color: MainPageAppTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: MainPageAppTheme.grey,
                                      size: 18,
                                    ),
                                  ),
                                  Text(
                                    '15 May',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: MainPageAppTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      letterSpacing: -0.2,
                                      color: MainPageAppTheme.darkerText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {},
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: MainPageAppTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

}
