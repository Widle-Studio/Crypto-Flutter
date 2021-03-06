import 'dart:convert';

import 'package:cryptomarket/Model/GetCoinsAdd.dart';
import 'package:cryptomarket/Model/models.dart';
import 'package:cryptomarket/Page/CoinDescription.dart';
import 'package:cryptomarket/Page/MarketCoinDescription.dart';
import 'package:cryptomarket/Util/SharedPreferencesHelper.dart';
import 'package:cryptomarket/bloc/bloc.dart';
import 'package:cryptomarket/bloc/market_coins_bloc.dart';
import 'package:cryptomarket/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MarketCoins extends StatefulWidget {
  String Marketname;
  String marketUrl;


  MarketCoins(this.Marketname,this.marketUrl);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return marketcoins(Marketname,marketUrl);
  }
}

class marketcoins extends State<MarketCoins> {
  bool _isInAsyncCall = true;
  var isLoading = false;
  List<CoinsMarketData> posts = new List();

  String Marketname;
  String marketUrl;

  marketcoins(this.Marketname,this.marketUrl);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchMarket1();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          centerTitle: true,
          title: Text(
            Marketname,
            style: TextStyle(fontSize: 20.0),
          ),
          elevation: 0.0,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Image.network(
                "https://www.cryptocompare.com" + marketUrl,
                height: 40,
                width: 40,
              ),
            )
          ],
        ),
        body:isLoading ?Center(
          child: CircularProgressIndicator(),
        ) : ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            return PostWidget(
                post: posts[index]); //PostWidget(post: state.posts[index]);
          },
        )
    );
  }


  bool _hasReachedMax(PostState state) =>
      state is MarketCoinsLoaded && state.hasReachedMax;


  Future<List<CoinsMarketData>> fetchMarket1() async {

    setState(() {
      isLoading = true;
    });
    // TODO: implement fetchCurrencies
    //   String apiUrl = 'https://min-api.cryptocompare.com/data/exchanges/general?api_key=5fa8278700ff48c403c9356a7ce85705177ebf3f4b8b0bc5a9e9151f5143d095';

    String apiUrl = "https://min-api.cryptocompare.com/data/v2/all/exchanges";

    http.Response response = await http.get(apiUrl);
    String market = await SharedPreferencesHelper.getMarket();
    String currency = await SharedPreferencesHelper.getCurrency();

    // Iterable l = json.decode(response.body);


    var responseBody = json.decode(response.body);

    var data = responseBody['Data'][market];

    if (data != null) {

      data.forEach((key, value) async {
        print('Key: $key, Value:' + '$value');

        if (key != "is_active") {
          var valuedata = value;
          valuedata.forEach((key1, value1) async {
            //  print('Key: $key1, Value:' + value1['Name']);



            String coinData = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=" +
                key1 + "&tsyms=" + currency +"&e="+market;
            http.Response coinresponse = await http.get(coinData);
            var coinresponseBody = json.decode(coinresponse.body);
            var Raw = coinresponseBody['DISPLAY'];

            if (Raw != null) {
              var MarketName = Raw[key1];
              var curenncy = MarketName['USD'];
              posts.add(CoinsMarketData(
                  curenncy['PRICE'].toString(),
                  curenncy['CHANGEPCT24HOUR'].toString(),
                curenncy['MARKET'].toString(),

                  curenncy['CHANGE24HOUR'].toString(),
                  curenncy['HIGH24HOUR'].toString(),
                  curenncy['LOW24HOUR'].toString(),
                  curenncy['MKTCAP'].toString(),
                  curenncy['VOLUME24HOUR'].toString(),
                  curenncy['VOLUME24HOURTO'].toString(),
                  curenncy['TOSYMBOL'].toString(),
                  curenncy['SUPPLY'].toString(),
                  curenncy['FROMSYMBOL'].toString(),
                  curenncy['IMAGEURL'].toString()));
            }
            setState(() {
              isLoading = false;
              posts = posts;
            });
          });
        }
      });


    }


    final statusCode = response.statusCode;
    if (statusCode != 200 || responseBody == null) {
      throw new Exception(
          "An error ocurred : [Status Code : $statusCode]");
    }


    return posts;
  }
}

class PostWidget extends StatelessWidget {
  final CoinsMarketData post;

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
                  builder: (context) => MarketCoinDescription(post)));
            },
            child: Card(
                elevation: 0.1,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
                  child: Row(
                    children: <Widget>[
                           Expanded(
                        flex: 2,
                        child: new Image.network(
                          "https://www.cryptocompare.com" +
                              post.ImageUrl,
                          height: 50.0,
                          width: 50.0,
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(post.FROMSYMBOL,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.0)),
                              SizedBox(
                                height: 2,
                              ),
                              /* new Text(post.CoinInfo.FullName,
                                  style: new TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,)),*/
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
                                  new Text(post.PRICE),
                                  new Padding(padding: const EdgeInsets.only(
                                      bottom: 4.0)),
                                  new Text(
                                      (double.parse(
                                          post.CHANGEPCT24HOUR) ??
                                          0) >=
                                          0
                                          ? "+" +
                                          (double.parse(post
                                              .CHANGEPCT24HOUR) ??
                                              0)
                                              .toStringAsFixed(2) +
                                          "%"
                                          : (double.parse(
                                          post.CHANGEPCT24HOUR) ??
                                          0)
                                          .toStringAsFixed(2) +
                                          "%",
                                      style: Theme
                                          .of(context)
                                          .primaryTextTheme
                                          .body1
                                          .apply(
                                          color: (double.parse(post
                                              .CHANGEPCT24HOUR) ??
                                              0) >=
                                              0
                                              ? Colors.green
                                              : Colors.red)),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ))));
  }
}
