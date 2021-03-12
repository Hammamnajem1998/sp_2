import 'package:temp1/app_theme.dart';
import 'package:temp1/custom_drawer/drawer_user_controller_signUp.dart';
// import 'package:temp1/custom_drawer/home_drawer.dart';
import 'package:temp1/custom_drawer/home_drawer_signUp.dart';
import 'package:temp1/feedback_screen.dart';
import 'package:temp1/help_screen.dart';
import 'package:temp1/LoginPage_screen.dart';
import 'package:temp1/SignupPage_screen.dart';
import 'package:temp1/invite_friend_screen.dart';
import 'package:flutter/material.dart';

import 'custom_drawer/drawer_user_controller_hotel_profile.dart';

import 'custom_drawer/home_drawer_hotel_profile.dart';

import 'fitness_app/fitness_app_home_screen.dart';
import 'hotel_booking/hotel_home_screen.dart';
import 'hotel_booking/hotel_home_screen.dart';
import 'hotel_booking/hotel_home_screen.dart';

class NavigationHotelProfile extends StatefulWidget {
  @override
  _NavigationHotelProfileState createState() => _NavigationHotelProfileState();
}

class _NavigationHotelProfileState extends State<NavigationHotelProfile> {
  Widget screenView;
  DrawerIndexHotelProfile drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndexHotelProfile.userProfile;
    screenView =  FitnessAppHomeScreen();
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
          body: DrawerUserControllerHotelProfile(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndexHotelProfile drawerIndexdata) {
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

  void changeIndex(DrawerIndexHotelProfile drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndexHotelProfile.userProfile) {
        setState(() {
          screenView = FitnessAppHomeScreen();
        });
      } else if (drawerIndex == DrawerIndexHotelProfile.shops) {
        setState(() {
          screenView = HotelHomeScreen();
        });
      } else if (drawerIndex == DrawerIndexHotelProfile.rate) {
        setState(() {
          screenView = InviteFriend();
        });
      } else {
        //do in your way......
      }
    }
  }
}
