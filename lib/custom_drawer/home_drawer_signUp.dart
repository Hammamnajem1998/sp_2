import 'package:temp1/app_theme.dart';
import 'package:flutter/material.dart';

class HomeDrawerSignUp extends StatefulWidget {
  const HomeDrawerSignUp({Key key, this.screenIndex, this.iconAnimationController, this.callBackIndex}) : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndexSignUp screenIndex;
  final Function(DrawerIndexSignUp) callBackIndex;

  @override
  _HomeDrawerSignUpState createState() => _HomeDrawerSignUpState();
}

class _HomeDrawerSignUpState extends State<HomeDrawerSignUp> {
  List<DrawerList> drawerList;
  @override
  void initState() {
    setDrawerListArray();
    super.initState();
  }

  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndexSignUp.SignIn,
        labelName: 'SignIn',
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndexSignUp.SignUp,
        labelName: 'SignUp',
        isAssetsImage: true,
        imageName: 'assets/images/supportIcon.png',
      ),
      DrawerList(
        index: DrawerIndexSignUp.About,
        labelName: 'About Us',
        icon: Icon(Icons.info),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 80,
          ),

          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName, color: widget.screenIndex == listData.index ? Colors.blue : AppTheme.nearlyBlack),
                        )
                      : Icon(listData.icon.icon, color: widget.screenIndex == listData.index ? Colors.blue : AppTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index ? Colors.blue : AppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) * (1.0 - widget.iconAnimationController.value - 1.0), 0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndexSignUp indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
}

enum DrawerIndexSignUp {
  SignIn,
  SignUp,
  About,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndexSignUp index;
}
