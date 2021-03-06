import 'package:cryptomarket/Theme/MyThemes.dart';
import 'package:cryptomarket/Theme/_CustomTheme.dart';
import 'package:cryptomarket/Util/SharedPreferencesHelper.dart';
import 'package:flutter/material.dart';

class Theme_Screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return theme();
  }
}

class theme extends State<Theme_Screen> {
  String lbl_theme;

  List<String> themeList = ['Light', 'Dark'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  getData() async {
    lbl_theme = await SharedPreferencesHelper.getTheme();
    setState(() {
      lbl_theme = this.lbl_theme;
    });
  }

  bool _value = false;

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
            title: Text(
              'Theme',
              style: TextStyle(fontSize: 20.0),
            ),
            elevation: 0.0,
          ),
          body: ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (BuildContext context, int index) {
              return Material(
                  child: InkWell(
                      onTap: () async {
                        await SharedPreferencesHelper.seTheme(themeList[index]);
                        setState(() async {
                          _value = lbl_theme.contains(themeList[index]);
                          _value = !_value;
                          lbl_theme = themeList[index];

                          if (lbl_theme == "Light") {
                            _changeTheme(context, MyThemeKeys.LIGHT);
                          } else {
                            _changeTheme(context, MyThemeKeys.DARK);
                          }
                        });
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 10.0, right: 20.0, bottom: 10.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 8,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0,
                                      top: 5.0,
                                      right: 10.0,
                                      bottom: 5.0),
                                  child: new Text(themeList[index],
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18.0)),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                    alignment: Alignment.centerRight,
                                    child: lbl_theme.contains(themeList[index])
                                        ? Icon(
                                            Icons.check,
                                            size: 30.0,
                                          )
                                        : Container()),
                              )
                            ],
                          ))));
            },
            itemCount: themeList.length,
          )),
    );
  }
}
