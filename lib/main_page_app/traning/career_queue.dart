import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temp1/main_page_app/ui_view/queue_item_view.dart';
import 'package:temp1/shops_app/shops_app_theme.dart';

class CareerQueue extends StatefulWidget {
  CareerQueue({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _CareerQueueState createState() => _CareerQueueState();
}

class _CareerQueueState extends State<CareerQueue> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: getAppBarUI(),
      body: Container(
        margin: const EdgeInsets.only(top: 0),
        color: ShopAppTheme.buildLightTheme().backgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              getQueueItems(),
            ]
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Add your onPressed code here!
            },
            child: const Icon(Icons.add, size: 30),
            backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          ),
        ),
      )

    );
  }

  Widget getQueueItems(){
    return Container (
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return QueueItem();
        },
      ),
    );
  }


  Widget getAppBarUI() {
    return PreferredSize(
        preferredSize: const Size(double.infinity, kToolbarHeight),
        child:Container(
          decoration: BoxDecoration(
            color: ShopAppTheme.buildLightTheme().backgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  offset: const Offset(0, 2),
                  blurRadius: 4.0),
            ],
          ),
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, left: 8, right: 8),
          child: Row(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                width: AppBar().preferredSize.height + 40,
                height: AppBar().preferredSize.height,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 21,
                    ),
                  ),
                ),
              ),
              Container(
                width: AppBar().preferredSize.height + 40,
                height: AppBar().preferredSize.height,
              )
            ],
          ),
        ),
      ),
    );
  }
}