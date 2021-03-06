import 'package:cryptomarket/Page/Home.dart';
import 'package:cryptomarket/Theme/MyThemes.dart';
import 'package:cryptomarket/Theme/_CustomTheme.dart';
import 'package:cryptomarket/Util/SharedPreferencesHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notification_Screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return notification();
  }
}

class notification extends State<Notification_Screen> {
  String lbl_notification;

  List<String> notificationList = ['EveryMinute', 'Hourly', 'Daily', 'Weekly'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  getData() async {
    lbl_notification = await SharedPreferencesHelper.getNotification();
    setState(() {
      lbl_notification = this.lbl_notification;
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
              'Notification',
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
                        await SharedPreferencesHelper.setNotification(
                            notificationList[index]);
                        _value =
                            lbl_notification.contains(notificationList[index]);
                        _value = !_value;

                        setState(() {
                          lbl_notification = notificationList[index];
                        });

                        if (lbl_notification == "EveryMinute") {
                          var androidPlatformChannelSpecifics =
                              AndroidNotificationDetails(
                                  'repeating channel id',
                                  'repeating channel name',
                                  'repeating description');
                          var iOSPlatformChannelSpecifics =
                              IOSNotificationDetails();
                          var platformChannelSpecifics = NotificationDetails(
                              androidPlatformChannelSpecifics,
                              iOSPlatformChannelSpecifics);
                          await flutterLocalNotificationsPlugin.periodicallyShow(
                              0, 'Price updated',
                              'Check it out your favorite coins price', RepeatInterval.EveryMinute,
                              platformChannelSpecifics);
                        } else if (lbl_notification == "Hourly") {
                          var androidPlatformChannelSpecifics =
                              AndroidNotificationDetails(
                                  'repeating channel id',
                                  'repeating channel name',
                                  'repeating description');
                          var iOSPlatformChannelSpecifics =
                              IOSNotificationDetails();
                          var platformChannelSpecifics = NotificationDetails(
                              androidPlatformChannelSpecifics,
                              iOSPlatformChannelSpecifics);
                          await flutterLocalNotificationsPlugin.periodicallyShow(
                              0, 'Price updated',
                              'Check it out your favorite coins price', RepeatInterval.EveryMinute,
                              platformChannelSpecifics);
                        } else if (lbl_notification == "Daily") {
                          var androidPlatformChannelSpecifics =
                              AndroidNotificationDetails(
                                  'repeating channel id',
                                  'repeating channel name',
                                  'repeating description');
                          var iOSPlatformChannelSpecifics =
                              IOSNotificationDetails();
                          var platformChannelSpecifics = NotificationDetails(
                              androidPlatformChannelSpecifics,
                              iOSPlatformChannelSpecifics);
                          await flutterLocalNotificationsPlugin.periodicallyShow(
                              0, 'Price updated',
                              'Check it out your favorite coins price', RepeatInterval.EveryMinute,
                              platformChannelSpecifics);
                        } else if (lbl_notification == "Weekly") {
                          var androidPlatformChannelSpecifics =
                              AndroidNotificationDetails(
                                  'repeating channel id',
                                  'repeating channel name',
                                  'repeating description');
                          var iOSPlatformChannelSpecifics =
                              IOSNotificationDetails();
                          var platformChannelSpecifics = NotificationDetails(
                              androidPlatformChannelSpecifics,
                              iOSPlatformChannelSpecifics);
                          await flutterLocalNotificationsPlugin.periodicallyShow(
                              0, 'Price updated',
                              'Check it out your favorite coins price', RepeatInterval.EveryMinute,
                              platformChannelSpecifics);
                        }
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
                                  child: new Text(notificationList[index],
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18.0)),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                    alignment: Alignment.centerRight,
                                    child: lbl_notification
                                            .contains(notificationList[index])
                                        ? Icon(
                                            Icons.check,
                                            size: 30.0,
                                          )
                                        : Container()),
                              )
                            ],
                          ))));
            },
            itemCount: notificationList.length,
          )),
    );
  }
}
