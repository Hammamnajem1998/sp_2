import 'package:flutter/material.dart';
import '../../customer.dart';
import '../main_page_app_theme.dart';

class QueueItemView extends StatelessWidget {

  final String photoURL ;
  final String title;
  final String subTitle;
  QueueItemView(
      {Key key,
        this.photoURL : '',
        this.title : '',
        this.subTitle : '',
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              left: 24, right: 24, top: 0, bottom: 0),
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: MainPageAppTheme.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                        topRight: Radius.circular(8.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: MainPageAppTheme.grey.withOpacity(0.4),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius:
                        BorderRadius.all(Radius.circular(8.0)),
                        child: SizedBox(
                          height: 74,
                          child: AspectRatio(
                            aspectRatio: 1.714,
                            child: Image.asset("assets/fitness_app/back.png"),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 100,
                                  right: 16,
                                  top: 16,
                                ),
                                child: Text(
                                  this.title == '' ? 'Customer' : this.title,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily:
                                    MainPageAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    letterSpacing: 0.0,
                                    color:
                                    MainPageAppTheme.nearlyDarkBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 100,
                              bottom: 12,
                              top: 4,
                              right: 16,
                            ),
                            child: Text(
                              this.subTitle == '' ? 'Waiting' : this.subTitle,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: MainPageAppTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
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
              ),
              Positioned(
                top: 0,
                left: 0,
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: this.photoURL ==''? Image.asset("assets/fitness_app/runner.png") : Image.network(this.photoURL),
                ),
              ),
              Positioned(
                top: 25,
                left: 280,
                child: IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 30.0,
                    color: Colors.brown[900],
                  ),
                  onPressed: () {
                    print('deleted');
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


