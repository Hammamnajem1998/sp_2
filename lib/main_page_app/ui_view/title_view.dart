import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:temp1/main_page_app/main_page_app_theme.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class TitleView extends StatelessWidget {
  final String titleTxt;
  final String subTxt;
  final AnimationController animationController;
  final Animation animation;

  final fieldController = TextEditingController();

   TitleView(
      {Key key,
      this.titleTxt: "",
      this.subTxt: "",
      this.animationController,
      this.animation,})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        titleTxt,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: MainPageAppTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          letterSpacing: 0.5,
                          color: MainPageAppTheme.lightText,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: this.fieldController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          fontSize: 20,
                          //fontStyle: FontStyle.italic,
                        ),
                        //cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: subTxt,
                        ),
                      ),
                    ),

                    InkWell(
                      highlightColor: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      onTap: () {
                        changeFieldState(this.titleTxt);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Change',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: MainPageAppTheme.fontName,
                                fontWeight: FontWeight.normal,
                                fontSize: 18,
                                letterSpacing: 0.5,
                                color: MainPageAppTheme.nearlyDarkBlue,
                              ),
                            ),
                          ],
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

  Future <bool> changeFieldState(String condition) async {
    String condition_str = condition;

    if (condition == 'First Name:'){
    }
    else if(condition == 'Last Name:'){
    }
    else if (condition == 'Location:'){
    }
    else if (condition == 'Email:'){

    }
    else if (condition == 'Password:'){
    }
    else {
      print('nothing');
    }

    return true;
    // Response response = await post("https://dont-wait.herokuapp.com/login",
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     },
    //     body: jsonEncode({'email': email, 'password': password}));
    //
    // var jsonResponse = jsonDecode(response.body);
    // if(jsonResponse['error'] != null){
    //   // print(jsonResponse['error']);
    //   return false;
    // }
    // else if (jsonResponse['message'] != null){
    //   // print (jsonResponse['message']);
    //   return true;
    // }
    // return false;
  }
}
