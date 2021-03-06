import 'package:cryptomarket/Page/CurrencyList_Screen.dart';
import 'package:cryptomarket/Page/ExchangeList_Screen.dart';
import 'package:cryptomarket/Page/Home.dart';
import 'package:cryptomarket/Page/NewsList_Screen.dart';
import 'package:cryptomarket/Page/Notification_Screen.dart';
import 'package:cryptomarket/Page/Theme_Screen.dart';
import 'package:cryptomarket/Theme/MyThemes.dart';
import 'package:cryptomarket/Theme/_CustomTheme.dart';
import 'package:cryptomarket/Util/SharedPreferencesHelper.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return settings();
  }
}

class settings extends State<Settings> {
  String theme = "Light";
  String currency = "USD";
  String exchange = "Coinbase";
  String news = 'All';

  bool isSwitched = false;

  List newsList = new List();

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  getData() async {
    isSwitched = await SharedPreferencesHelper.getNotificationFlag();
    exchange = await SharedPreferencesHelper.getExchange();
    currency = await SharedPreferencesHelper.getCurrency();
    news = await SharedPreferencesHelper.getNews();
    setState(() {
      exchange = this.exchange;
      currency = this.currency;
      news = this.news;
      isSwitched = this.isSwitched;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: Text(
            'Settings',
            style: TextStyle(fontSize: 20.0),
          ),
          elevation: 0.0,
        ),
        body: ListView(
          children: <Widget>[
            new ListTile(
              title: const Text('Theme'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Theme_Screen()));
              },
            ),
            new Divider(
              height: 10.0,
            ),
            new ListTile(
              title: const Text('Currency'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CurrencyList_Screen()));
              },
            ),
            new Divider(
              height: 10.0,
            ),
            new ListTile(
              title: const Text('Exchange'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExchangeList_Screen()));
              },
            ),
            /*    new ListTile(
              title: const Text('Exchange'),
              subtitle: Text(exchange),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                SimpleDialog dialog = new SimpleDialog(
                  children: <Widget>[
                    new SimpleDialogOption(
                      onPressed: () async {
                        //await SharedPreferencesHelper.s('Binance');
                        setState(() {
                          Navigator.of(context).pop();
                          exchange = "Binance";
                        });
                      },
                      child: Text('Binance'),
                    ),
                    new Divider(
                      color: Colors.black,
                    ),
                    new SimpleDialogOption(
                      onPressed: () async {
                     //   await SharedPreferencesHelper.seCurrency('Bittrex');
                        setState(() {
                          Navigator.of(context).pop();
                          exchange = "Bittrex";
                        });
                      },
                      child: Text('Bittrex'),
                    ),
                    new Divider(
                      color: Colors.black,
                    ),
                    new SimpleDialogOption(
                      onPressed: () async {
                     //   await SharedPreferencesHelper.seCurrency('Coinbase');
                        setState(() {
                          Navigator.of(context).pop();
                          exchange = "Coinbase";
                        });
                      },
                      child: Text('Coinbase'),
                    ),
                    new Divider(
                      color: Colors.black,
                    ),
                    new SimpleDialogOption(
                      onPressed: () async {
                  //      await SharedPreferencesHelper.seCurrency('Kraken');
                        setState(() {
                          Navigator.of(context).pop();
                          exchange = "Kraken";
                        });
                      },
                      child: Text('Kraken'),
                    ),
                    new Divider(
                      color: Colors.black,
                    ),
                    new SimpleDialogOption(
                      onPressed: () async {
                   //     await SharedPreferencesHelper.seCurrency('OKEx');
                        setState(() {
                          Navigator.of(context).pop();
                          exchange = "OKEx";
                        });
                      },
                      child: Text('OKEx'),
                    )
                  ],
                );

// Show dialog
                showDialog(context: context, child: dialog);
              },
            ),*/
            new Divider(
              height: 10.0,
            ),
            new ListTile(
              title: const Text('News'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewsList_Screen()));
              },
            ),
            /* new ListTile(
              title: const Text('News'),
              subtitle: Text(news),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                SimpleDialog dialog = new SimpleDialog(
                  children: <Widget>[
                    new SimpleDialogOption(
                      onPressed: () async {
                        await SharedPreferencesHelper.seNews('coindesk');
                        setState(() {
                          Navigator.of(context).pop();
                          news = "coindesk";
                        });
                      },
                      child: const Text('Coindesk'),
                    ),
                    new Divider(
                      color: Colors.black,
                    ),
                    new SimpleDialogOption(
                      onPressed: () async {
                        await SharedPreferencesHelper.seNews('cryptoslate');
                        setState(() {
                          Navigator.of(context).pop();
                          news = "cryptoslate";
                        });
                      },
                      child: const Text('Cryptoslate'),
                    ),
                    new Divider(
                      color: Colors.black,
                    ),
                    new SimpleDialogOption(
                      onPressed: () async {
                        await SharedPreferencesHelper.seNews('ccn');
                        setState(() {
                          Navigator.of(context).pop();
                          news = "ccn";
                        });
                      },
                      child: const Text('Ccn'),
                    ),
                    new Divider(
                      color: Colors.black,
                    ),
                    new SimpleDialogOption(
                      onPressed: () async {
                        await SharedPreferencesHelper.seNews('cryptobriefing');
                        setState(() {
                          Navigator.of(context).pop();
                          news = "cryptobriefing";
                        });
                      },
                      child: const Text('Cryptobriefing'),
                    ),
                    new Divider(
                      color: Colors.black,
                    ),
                    new SimpleDialogOption(
                      onPressed: () async {
                        await SharedPreferencesHelper.seNews('cointelegraph');
                        setState(() {
                          Navigator.of(context).pop();
                          news = "cointelegraph";
                        });
                      },
                      child: const Text('Cointelegraph'),
                    ),
                  ],
                );
// Show dialog
                showDialog(context: context, child: dialog);
              },
            ),*/
            new Divider(
              height: 10.0,
            ),
            new ListTile(
              title: const Text('Push Notifications'),
              trailing: Switch(
                value: isSwitched,
                onChanged: (value) async {
                  if (value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Notification_Screen()));
                  } else {
                    await flutterLocalNotificationsPlugin.cancelAll();
                  }
                  await SharedPreferencesHelper.setNotificationFlag(value);

                  setState(() {
                    isSwitched = value;
                  });
                },
                activeTrackColor: Colors.green,
                activeColor: Colors.green,
              ),
            ),
            new Divider(
              height: 10.0,
            ),
            new ListTile(
              title: const Text('Send Feedback'),
            ),
            new Divider(
              height: 10.0,
            ),
            new ListTile(
              title: const Text('Visit Website'),
            ),
            new Divider(
              height: 10.0,
            ),
            new ListTile(
              title: const Text('About Us'),
            ),
            new Divider(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
