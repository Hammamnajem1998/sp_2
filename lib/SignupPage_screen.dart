import 'package:temp1/app_theme.dart';
import 'package:temp1/main.dart';
import 'package:flutter/material.dart';
import 'package:temp1/map.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);


  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: ListView(
                children: <Widget>[
                  appBar(),
                  getUserNameBarUI(),
                  getUserEmailBarUI(),
                  getUserCreatePasswordBarUI(),
                  getUserConfirmPasswordBarUI(),
                  //  getUserLocationBarUI(),
                  getLocationButtonBarUI(context),
                  //  FlatButton(onPressed: null,
                  //    child: Text("afeef" ,style:TextStyle(fontSize: 30))),
                  getSignupButtonBarUI(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget appBar() {
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Sign UP Page',
                  style: TextStyle(
                    fontSize: 22,
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getUserCreatePasswordBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  //color: HotelAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    validator: (val) => val.length < 6 ? 'Password too short.' : null,
                    obscureText: true,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    //cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Create Password...',
                      prefixIcon:Icon(Icons.lock,size: 30,),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              //color: HotelAppTheme.buildLightTheme().primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getUserConfirmPasswordBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  //color: HotelAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    validator: (val) => val.length < 6 ? 'Password too short.' : null,
                    obscureText: true,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    //cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Confirm Password...',
                      prefixIcon:Icon(Icons.lock,size: 30,),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              //color: HotelAppTheme.buildLightTheme().primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getUserEmailBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  //color: HotelAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onSubmitted:(String txt) {print(txt);} ,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    //cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'User Email...',
                      prefixIcon:Icon(Icons.email_sharp,size: 30,),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              //color: HotelAppTheme.buildLightTheme().primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getSignupButtonBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 50, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  //color: HotelAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.8),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 15, bottom: 15),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                      highlightColor: Colors.transparent,
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 27,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              //color: HotelAppTheme.buildLightTheme().primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getUserNameBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  //color: HotelAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onSubmitted:(String txt) {print(txt);} ,
                    keyboardType: TextInputType.emailAddress,

                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    //cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(

                      border: InputBorder.none,
                      hintText: 'User Name...',
                      prefixIcon:Icon(Icons.supervised_user_circle_rounded,size: 30,),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              //color: HotelAppTheme.buildLightTheme().primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
Widget getLocationButtonBarUI(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16, top: 10, bottom: 8),
            child: Container(
              decoration:  BoxDecoration(


                //color: HotelAppTheme.buildLightTheme().backgroundColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(38.0),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      offset: const Offset(0, 2),
                      blurRadius: 8.0),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 15, bottom: 15),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyMap()),
                      );
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    child: Center(
                      child: Text(
                        'Get Location',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 27,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            //color: HotelAppTheme.buildLightTheme().primaryColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(38.0),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  offset: const Offset(0, 2),
                  blurRadius: 8.0),
            ],
          ),
        ),
      ],
    ),
  );
}