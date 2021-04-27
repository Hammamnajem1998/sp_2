import 'dart:convert';

import 'package:http/http.dart';
import 'package:temp1/app_theme.dart';
import 'package:temp1/custom_drawer/drawer_user_controller_signUp.dart';
// import 'package:temp1/custom_drawer/home_drawer.dart';
import 'package:temp1/custom_drawer/home_drawer_signUp.dart';
import 'package:temp1/customer.dart';
import 'package:temp1/feedback_screen.dart';
import 'package:temp1/help_screen.dart';
import 'package:temp1/LoginPage_screen.dart';
import 'package:temp1/SignupPage_screen.dart';
import 'package:temp1/invite_friend_screen.dart';
import 'package:flutter/material.dart';
import 'package:temp1/shop.dart';

import 'custom_drawer/drawer_user_controller_Shops_profile.dart';

import 'custom_drawer/home_drawer_Shops_profile.dart';

import 'main_page_app/main_page_app_home_screen.dart';
import 'shops_app/shops_home_screen.dart';


class NavigationShopsProfile extends StatefulWidget {

  final Customer customer;
  final Shop shop;
  NavigationShopsProfile({Key key, @required this.customer, this.shop}) : super(key: key);

  @override
  _NavigationShopsProfileState createState() => _NavigationShopsProfileState();
}

class _NavigationShopsProfileState extends State<NavigationShopsProfile> {
  Widget screenView;
  DrawerIndexShopsProfile drawerIndex;
  @override
  void initState() {
    drawerIndex = DrawerIndexShopsProfile.userProfile;
    screenView =  MainPageAppHomeScreen(customer: widget.customer, shop: widget.shop);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserControllerShopslProfile(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            id: widget.customer.id,
            onDrawerCall: (DrawerIndexShopsProfile drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndexShopsProfile drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndexShopsProfile.userProfile) {
        setState(() {
          screenView = MainPageAppHomeScreen(customer: widget.customer, shop: widget.shop);
        });
      } else if (drawerIndex == DrawerIndexShopsProfile.shops) {
        setState(() {
          screenView = ShopsScreen(customer: widget.customer, shop: widget.shop);
        });
      } else if (drawerIndex == DrawerIndexShopsProfile.rate) {
        setState(() {
          screenView = FeedbackScreen( customer: widget.customer,);
        });
      } else {
        //do in your way......
      }
    }
  }
}
