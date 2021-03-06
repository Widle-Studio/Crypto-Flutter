import 'dart:async';
import 'dart:convert';

import 'package:cryptomarket/Page/CoinDescription.dart';
import 'package:cryptomarket/Page/Dashboard.dart';
import 'package:cryptomarket/Util/SharedPreferencesHelper.dart';
import 'package:cryptomarket/Util/swipe_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cryptomarket/Model/GetCoinsAdd.dart';

import 'package:cryptomarket/bloc/bloc.dart';
import 'package:cryptomarket/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;


import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:charts_flutter/flutter.dart' as charts;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//import 'package:socket_io/socket_io.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return home();
  }
}

class home extends State<Home> {

  List coins;



  final _scrollController = ScrollController();
  PostBloc _postBloc = PostBloc(httpClient: http.Client());

  Stream<List<GetCoinsAdd>> stream;
  List<GetCoinsAdd> _listData;
  List<USD1> _datalits;
  Timer _everySecond;
  String lbl_notification;

  var platform = MethodChannel('crossingthestreams.io/resourceResolver');

  final _scrollThreshold = 200.0;

  List _selecteCategorys = List();

  home() {
    _scrollController.addListener(_onScroll);
    _postBloc.dispatch(Fetch());
  }


  @override
  void dispose() {
    _postBloc.dispose();
    super.dispose();
  }


  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _postBloc.dispatch(Fetch());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    getCoinsList();


    _everySecond = Timer.periodic(Duration(seconds: 5), (Timer t) {
      setState(() {
        _postBloc = PostBloc(httpClient: http.Client());

        setState(() {
          _postBloc.dispatch(Fetch());
        });
      });
    });
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    /*await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
    );*/
  }


  Future<void> onDidReceiveLocalNotification(int id, String title, String body,
      String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    await showDialog(
      context: context,
      builder: (BuildContext context) =>
          CupertinoAlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Ok'),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              )
            ],
          ),
    );
  }

  getCoinsList() async {
    coins = await SharedPreferencesHelper.getCoinList();
    _selecteCategorys = await SharedPreferencesHelper.getCoinList();
    //stream = new Stream.fromFuture(fetchCurrencies());
    // startTimer();
    //fetchCurrencies();
    lbl_notification = await SharedPreferencesHelper.getNotification();

    bool startNotification = await SharedPreferencesHelper
        .getNotificationFlag();
    if (startNotification == true) {
      if (lbl_notification == "EveryMinute") {
        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
            'repeating channel id',
            'repeating channel name',
            'repeating description');
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.periodicallyShow(
            0, 'Price updated',
            'Check it out your favorite coins price', RepeatInterval.EveryMinute,
            platformChannelSpecifics);
      }

      else if (lbl_notification == "Hourly") {
        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
            'repeating channel id',
            'repeating channel name',
            'repeating description');
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.periodicallyShow(
            0, 'Price updated',
            'Check it out your favorite coins price', RepeatInterval.EveryMinute,
            platformChannelSpecifics);
      }
      else if (lbl_notification == "Daily") {
        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
            'repeating channel id',
            'repeating channel name',
            'repeating description');
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.periodicallyShow(
            0, 'Price updated',
            'Check it out your favorite coins price', RepeatInterval.EveryMinute,
            platformChannelSpecifics);
      }
      else if (lbl_notification == "Weekly") {
        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
            'repeating channel id',
            'repeating channel name',
            'repeating description');
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.periodicallyShow(
            0, 'Price updated',
            'Check it out your favorite coins price', RepeatInterval.EveryMinute,
            platformChannelSpecifics);
      }
    }
  }

  Future<List<GetCoinsAdd>> fetchCurrencies() async {
    String currency = await SharedPreferencesHelper.getCurrency();
    List coins = await SharedPreferencesHelper.getCoinList();
    String exchange = await SharedPreferencesHelper.getExchange();
    var subscription = [
    ]; //= [ '5~CCCAGG~ETH~USD', '5~CCCAGG~XRP~USD', '5~CCCAGG~IOT~USD', '5~CCCAGG~XLM~USD', '5~CCCAGG~XMR~USD'];


    for (int i = 0; i < coins.length; i++) {
      subscription.add('5~CCCAGG~' + coins[i] + '~' + currency);
    }
    IO.Socket socket = IO.io(
        'https://streamer.cryptocompare.com/', <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'foo': 'bar'}
    });
    socket.on('connect', (_) {
      print('connect');


      socket.emit('SubAdd', { 'subs': subscription});
      socket.on("m", (data) {
        // print(data)

        var x = data.split("~");
        //print(x[1]);
        if (x[0] == 3 || x[0] == 401) {
          print(x);
        }
        else {
          for (var i = 0; i < x.length; i++) {
            if (x.length > 5) {
              if (i == 2) {
                String a = x[4];
                if (a == '1') {
                  var messageType = data.substring(0, data.indexOf("~"));
                  print(x[2] + ' = ' + x[3] + ' = ' + x[4] + ' = ' + x[5] +
                      ' = ' + messageType + ' = ' + ' + ');

                  var setDAta = [
                    x[2] + ' = ' + x[3] + ' = ' + x[4] + ' = ' + x[5] + ' = ' +
                        messageType + ' = ' + ' + '
                  ];
                  //print(a);
                  var dataSet = {x[3]: {}};
                  //  return setDAta.map((c) => new GetCoinsAdd.fromMap(c)).toList();
                }
                else if (a == '2') {
                  var messageType = data.substring(0, data.indexOf("~"));
                  print(x[2] + ' = ' + x[3] + ' = ' + x[4] + ' = ' + x[5] +
                      ' = ' + messageType + ' = ' + ' - ');

                  for (int i = 0; i < _listData.length; i++) {
                    if (_listData[i].CoinInfo.Name == x[2]) {
                      //  _datalits.add(USD1(x[5], "", "", "", "", "", "", "", "", "", ""));

                    }
                  }

                  //print(a);
                  var setDAta = [
                    x[2] + ' = ' + x[3] + ' = ' + x[4] + ' = ' + x[5] + ' = ' +
                        messageType + ' = ' + ' - '
                  ];
                  //print(a);
                  // return setDAta.map((c) => new GetCoinsAdd.fromMap(c)).toList();
                }
              }
            }
          }
        }
      });
    });
    socket.on('event', (data) => print(data));
    socket.on('disconnect', (_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));


    // TODO: implement fetchCurrencies

    String coinsdata = coins.toString().replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll(" ", "");
    String Baseurl = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=" +
        coinsdata + "&tsyms=" + currency + "&e=" + exchange;

    String apiUrl =
        'https://min-api.cryptocompare.com/data/top/mktcapfull?limit=100&tsym=' +
            currency;

    // Make a HTTP GET request to the CoinMarketCap API.
    // Await basically pauses execution until the get() function returns a Response
    http.Response response = await http.get(apiUrl);
    var responseBody = json.decode(response.body);
    List data = responseBody['Data'];

    final statusCode = response.statusCode;
    if (statusCode != 200 || responseBody == null) {
      throw new Exception("An error ocurred : [Status Code : $statusCode]");
    }

    print(statusCode);
    //  print(data.map((c) => new GetCoinsAdd.fromMap(c)).toList());
    _listData = data.map((c) => new GetCoinsAdd.fromMap(c)).toList();
    return data.map((c) => new GetCoinsAdd.fromMap(c)).toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'App Logo',
          style: TextStyle(fontSize: 20.0),
        ),
        elevation: 0.0,
      ),
      body: RefreshIndicator(child:
      StreamBuilder<List<GetCoinsAdd>>(
          stream: fetchCurrencies().asStream(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error);
            }

            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return getViewCoins(snapshot
                      .data[index]); //PostWidget(post: state.posts[index]);

                },
              );
            }

            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return Text('No Posts');
            }
          }),
        onRefresh: _handleRefresh,
      ),


    );
  }

  /*
  Container(
          margin: EdgeInsets.only(top: 5.0),
          child: ViewData()
      ),*/

  Widget ViewData() {
    return BlocBuilder(
      bloc: _postBloc,
      builder: (BuildContext context, PostState state) {
        if (state is PostUninitialized) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is PostError) {
          return Center(
            child: Text('Failed to fetch Coins data'),
          );
        }
        if (state is PostLoaded) {
          return ListView.builder(
            itemCount: state.posts.length,
            itemBuilder: (BuildContext context, int index) {
              return getViewCoins(
                  state.posts[index]); //PostWidget(post: state.posts[index]);

            },
          );
        }
      },
    );
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 3));

    _postBloc = PostBloc(httpClient: http.Client());

    setState(() {
      _postBloc.dispatch(Fetch());
    });

    return null;
  }

  getViewCoins(GetCoinsAdd post) {
    if (coins.contains(post.CoinInfo.Name)) {
      return Dismissible(
          key: Key(post.CoinInfo.FullName),
          background: stackBehindDismiss(),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            setState(() {
              _selecteCategorys.remove(post.CoinInfo.Name);

              _postBloc = PostBloc(httpClient: http.Client());

              setState(() {
                _postBloc.dispatch(Fetch());
              });
              //items.removeAt(index);
            });
          },
          child: PostWidget(post: post));
    }
    else {
      return Container();
    }
  }

  Widget stackBehindDismiss() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: Icon(
        Icons.delete,
      ),
    );
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final GetCoinsAdd post;

  const PostWidget({
    Key key,
    @required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => CoinDescription(post)));
            },
            child: Card(
                elevation: 0.1,
                child: Padding(padding: EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: new Image.network(
                          "https://www.cryptocompare.com" +
                              post.CoinInfo.ImageUrl,
                          height: 50.0,
                          width: 50.0,
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(post.CoinInfo.Name,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.0)),
                              SizedBox(
                                height: 2,
                              ),
                              new Text(post.CoinInfo.FullName,
                                  style: new TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,)),
                            ],
                          )),
                      Expanded(
                        flex: 4,
                        child: Container(
                            padding: EdgeInsets.only(right: 10.0),
                            alignment: Alignment.centerRight,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: new Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  new Text(post.Display.USD.PRICE,
                                    style: TextStyle(fontSize: 16),),
                                  new Padding(padding: const EdgeInsets.only(
                                      bottom: 4.0)),
                                  new Text(
                                      (double.parse(
                                          post.Display.USD.CHANGEPCT24HOUR) ??
                                          0) >=
                                          0
                                          ? "+" +
                                          (double.parse(post.Display.USD
                                              .CHANGEPCT24HOUR) ??
                                              0)
                                              .toStringAsFixed(2) +
                                          "%"
                                          : (double.parse(
                                          post.Display.USD.CHANGEPCT24HOUR) ??
                                          0)
                                          .toStringAsFixed(2) +
                                          "%",
                                      style: Theme
                                          .of(context)
                                          .primaryTextTheme
                                          .body1
                                          .apply(
                                          color: (double.parse(post
                                              .Display.USD.CHANGEPCT24HOUR) ??
                                              0) >=
                                              0
                                              ? Colors.green
                                              : Colors.red)),
                                ],
                              ),
                            )),
                      ),


                    ],
                  ),)
            )
        ));
  }


}
