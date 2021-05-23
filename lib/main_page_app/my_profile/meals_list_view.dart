import 'dart:convert';
import 'package:temp1/shops_app/shop_info_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:temp1/main_page_app/main_page_app_theme.dart';
import 'package:temp1/main_page_app/models/liked_shops_list.dart';
import 'package:temp1/main.dart';
import 'package:flutter/material.dart';
import 'package:temp1/customer.dart';
import 'package:temp1/shop.dart';

// import '../../main.dart';

class MealsListView extends StatefulWidget {
  const MealsListView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation, this.customer})
      : super(key: key);

  final Customer  customer;
  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;

  @override
  _MealsListViewState createState() => _MealsListViewState();
}

class _MealsListViewState extends State<MealsListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<LikedShopsListData> mealsListData = <LikedShopsListData>[] ;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    getData();
    super.initState();
  }

  Future<bool> getData() async {
    await getShopsInformation();
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
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
            child: Container(
              height: 216,
              width: double.infinity,
              child: FutureBuilder<bool>(
                future: getData(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.only(
                          top: 0, bottom: 0, right: 16, left: 16),
                      itemCount: mealsListData.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        final int count =
                        mealsListData.length > 10 ? 10 : mealsListData.length;
                        final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                        animationController.forward();

                        return MealsView(
                          mealsListData: mealsListData[index],
                          animation: animation,
                          animationController: animationController,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> getShopsInformation() async{
    var id = widget.customer.id;
    Response response = await get("https://dont-wait.herokuapp.com/user/like/$id",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var jsonResponse = await jsonDecode(response.body);
    print(jsonResponse);
    mealsListData.clear();
    addShopsToList(jsonResponse);
    return true;
  }

  void addShopsToList(shopsList){
    int length = shopsList['length'];
    var list = shopsList['message'];
    for (int i=0 ; i< length ; i++){
      LatLng shopLocation = LatLng( list[i]['location']['x'] ,list[i]['location']['y'] );
      Shop shop = Shop(
          id: list[i]['id'].toString(),
          name: list[i]['name'],
          type: list[i]['type'],
          photoURL: list[i]['photo'],
          timeUnit: list[i]['time_unit'].toString(),
          openAt: list[i]['open_at'].toString(),
          closeAt: list[i]['close_at'].toString(),
          rating: list[i]['rating'].toString(),
          location: shopLocation,
          userID: list[i]['user_id'].toString()
      );

      mealsListData.add(
          LikedShopsListData(
            imagePath: shop.photoURL,
            titleTxt: shop.name,
            kacl: double.parse(shop.rating),
            meals: <String>[
              'Open at ${shop.openAt}',
              'Close at ${shop.closeAt}',
              'Serving time ${shop.timeUnit}',
            ],
            startColor: '#FFFAFAFA',
            endColor: '#FF213333',
            customer: widget.customer,
            shop: shop,
          ));
    }
  }
}

class MealsView extends StatelessWidget {
  const MealsView(
      {Key key, this.mealsListData, this.animationController, this.animation})
      : super(key: key);

  final LikedShopsListData mealsListData;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: SizedBox(
              width: 130,
              child: InkWell(
                onTap: () {
                  Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => ShopInfoScreen(shop : mealsListData.shop, customer: mealsListData.customer,),
                    ),
                  );
                },
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 32, left: 8, right: 8, bottom: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: HexColor(mealsListData.endColor)
                                    .withOpacity(0.6),
                                offset: const Offset(1.1, 4.0),
                                blurRadius: 8.0),
                          ],
                          gradient: LinearGradient(
                            colors: <HexColor>[
                              HexColor(mealsListData.startColor),
                              HexColor(mealsListData.endColor),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(54.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 54, left: 16, right: 16, bottom: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                mealsListData.titleTxt,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: MainPageAppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.2,
                                  color: MainPageAppTheme.white,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        mealsListData.meals.join('\n'),
                                        style: TextStyle(
                                          fontFamily: MainPageAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          letterSpacing: 0.2,
                                          color: MainPageAppTheme.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              mealsListData.kacl != 0.0
                                  ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    mealsListData.kacl.toStringAsFixed(2),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: MainPageAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 24,
                                      letterSpacing: 0.2,
                                      color: MainPageAppTheme.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, bottom: 3),
                                    child: Text(
                                      '/5',
                                      style: TextStyle(
                                        fontFamily:
                                        MainPageAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                        letterSpacing: 0.2,
                                        color: MainPageAppTheme.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                                  : Container(
                                decoration: BoxDecoration(
                                  color: MainPageAppTheme.nearlyWhite,
                                  shape: BoxShape.circle,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: MainPageAppTheme.nearlyBlack
                                            .withOpacity(0.4),
                                        offset: Offset(8.0, 8.0),
                                        blurRadius: 8.0),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.add,
                                    color: HexColor(mealsListData.endColor),
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          color: MainPageAppTheme.nearlyWhite.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 8,
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child:
                        ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(60.0)),
                          child: mealsListData.imagePath != null
                              ? Image.network(mealsListData.imagePath,fit: BoxFit.cover,)
                              : Image.asset('assets/hotel/hotel_2.png'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
