
import 'package:cryptomarket/Page/Dashboard.dart';
import 'package:cryptomarket/Page/Home.dart';
import 'package:cryptomarket/Theme/MyThemes.dart';
import 'package:flutter/material.dart';

class Splash_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return splash_screen();
  }
}

class splash_screen extends State<Splash_screen> {
  MediaQueryData querydata;



  @override
  Widget build(BuildContext context) {
    querydata = MediaQuery.of(context);
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: <Widget>[
            Center(
              child:
                  Text('WELCOME',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 30.0),
                )
          ),

          Positioned(
            bottom: 60.0,
            child: Center(
              child: new Container(
                width: querydata.size.width,
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 40.0,
                ),
                child: new OutlineButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(2.0)),
                  onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Dashboard()));
                    //  MyNavigator.goToMain(context);
                  },
                  child: new Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 15.0,
                    ),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(
                          child: Text(
                            "START",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,

                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
