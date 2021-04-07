import 'package:temp1/main_page_app/models/tabIcon_data.dart';
import 'package:temp1/main_page_app/traning/training_screen.dart';
import 'package:flutter/material.dart';
import '../customer.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'main_page_app_theme.dart';
import 'my_profile/my_profile_screen.dart';

class MainPageAppHomeScreen extends StatefulWidget {
  final Customer customer;
  MainPageAppHomeScreen({Key key, @required this.customer}) : super(key: key);

  @override
  _MainPageAppHomeScreenState createState() => _MainPageAppHomeScreenState();
}

class _MainPageAppHomeScreenState extends State<MainPageAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: MainPageAppTheme.background,
  );

  @override
  void initState() {

    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
   tabBody = MyProfileScreen(customer:widget.customer , animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MainPageAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          customer: widget.customer,
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0 || index == 2) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                     MyProfileScreen(customer:widget.customer, animationController: animationController);
                });
              });
            } else if (index == 1 || index == 3) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      TrainingScreen(customer: widget.customer, animationController: animationController);
                 });
              });
            }
          },
        ),
      ],
    );
  }
}
