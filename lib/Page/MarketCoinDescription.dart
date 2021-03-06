import 'dart:convert';
import 'dart:math';
import 'dart:math' as math;

import 'package:cryptomarket/Model/models.dart';
import 'package:cryptomarket/Util/SharedPreferencesHelper.dart';
import 'package:http/http.dart' as http;
import 'package:cryptomarket/Theme/MyThemes.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

var isLoading = false;
List<LinearSales> chartList = new List();

class MarketCoinDescription extends StatefulWidget {
  CoinsMarketData coinsMarketData;
  final random = new Random();

  MarketCoinDescription(this.coinsMarketData);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return marketcoindes(coinsMarketData);
  }
}

class marketcoindes extends State<MarketCoinDescription> {
  CoinsMarketData coinsMarketData;
  String map = "1D";
  String chartReport = "histoday";

  // var data = _generateRandomData(50);
  marketcoindes(this.coinsMarketData);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCurrencies();
  }

  Future fetchCurrencies() async {
    setState(() {
      isLoading = true;
    });
    String curenncy = await SharedPreferencesHelper.getCurrency();
    // TODO: implement fetchCurrencies

    String apiUrl = "https://min-api.cryptocompare.com/data/" +
        chartReport +
        "?fsym=" +
        coinsMarketData.FROMSYMBOL +
        "&tsym=" +
        curenncy;

    // Make a HTTP GET request to the CoinMarketCap API.
    // Await basically pauses execution until the get() function returns a Response
    http.Response response = await http.get(apiUrl);
    var responseBody = json.decode(response.body);
    List data = responseBody['Data'];

    final statusCode = response.statusCode;
    if (statusCode != 200 || responseBody == null) {
      throw new Exception("An error ocurred : [Status Code : $statusCode]");
    }

    chartList = (data).map((data) => new LinearSales.fromMap(data)).toList();
    setState(() {
      isLoading = false;
      chartList = chartList;
    });
    return data.map((c) => new LinearSales.fromMap(c)).toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          coinsMarketData.FROMSYMBOL,
          style: TextStyle(fontSize: 20.0),
        ),
        elevation: 0.0,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Image.network(
              "https://www.cryptocompare.com" + coinsMarketData.ImageUrl,
              height: 40,
              width: 40,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Padding(
                    padding: EdgeInsets.only(top: 10.0, left: 15.0),
                    child: new Text(
                      coinsMarketData.PRICE,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 30.0),
                    )),
                new Padding(
                  padding: EdgeInsets.only(top: 10.0, right: 15.0),
                  child: new Text(
                    (double.parse(coinsMarketData.CHANGEPCT24HOUR) ?? 0) >= 0
                        ? "+" +
                            (double.parse(coinsMarketData.CHANGEPCT24HOUR) ?? 0)
                                .toStringAsFixed(2) +
                            "%"
                        : (double.parse(coinsMarketData.CHANGEPCT24HOUR) ?? 0)
                                .toStringAsFixed(2) +
                            "%",
                    style: Theme.of(context).primaryTextTheme.body1.apply(
                        color: (double.parse(coinsMarketData.CHANGEPCT24HOUR) ??
                                    0) >=
                                0
                            ? Colors.green
                            : Colors.red),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(20)),
                    child: new Text(coinsMarketData.MARKET),
                  ),
                  new Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(20)),
                    child: new Text(coinsMarketData.MARKET),
                  ),
                ],
              ),
            ),
            new Divider(),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.all(15.0),
                  child: new Text("LOW :" + coinsMarketData.LOW24HOUR,
                      style: TextStyle(fontWeight: FontWeight.w500)),
                ),
                new Container(
                  margin: const EdgeInsets.all(15.0),
                  child: new Text(
                    "HIGH :" + coinsMarketData.HIGH24HOUR,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                new Container(
                  padding: const EdgeInsets.only(
                      top: 10.0, left: 20, right: 20, bottom: 10),
                  decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(10)),
                  child: new Text(map),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            new Container(
                width: MediaQuery.of(context).size.width,
                height: 250.0,
                child: AreaAndLineChart.withRandomData()),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(10)),
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            map = "1M";
                            chartReport = "histominute";
                            fetchCurrencies();
                          });
                        },
                        child: new Text(
                          "1M",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      )),
                  new Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(10)),
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            map = "1H";
                            chartReport = "histohour";
                            fetchCurrencies();
                          });
                        },
                        child: new Text(
                          "1H",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      )),
                  new Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(10)),
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            map = "1D";
                            chartReport = "histoday";
                            fetchCurrencies();
                          });
                        },
                        child: new Text(
                          "1D",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      )),
                ],
              ),
            ),
            new Divider(),
            Row(
              children: <Widget>[
                new Expanded(
                  flex: 5,
                  child: Container(
                      margin: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          new Text("VOLUME(1D)",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          SizedBox(
                            height: 10.0,
                          ),
                          new Text(coinsMarketData.VOLUME24HOURTO,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20.0)),
                        ],
                      )),
                ),
                VerticalDivider(),
                new Expanded(
                    flex: 5,
                    child: Container(
                        margin: const EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            new Text("MARKET CAP",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                )),
                            SizedBox(
                              height: 10.0,
                            ),
                            new Text(coinsMarketData.MKTCAP,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.0)),
                          ],
                        ))),
              ],
            ),
            new Divider(),
            Row(
              children: <Widget>[
                new Expanded(
                  flex: 5,
                  child: Container(
                      margin: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          new Text("RANK",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          SizedBox(
                            height: 10.0,
                          ),
                          new Text("1",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20.0)),
                        ],
                      )),
                ),
                VerticalDivider(),
                new Expanded(
                    flex: 5,
                    child: Container(
                        margin: const EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            new Text("CIRCULATING SUPPLY",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                )),
                            SizedBox(
                              height: 10.0,
                            ),
                            new Text(coinsMarketData.SUPPLY,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.0)),
                          ],
                        ))),
              ],
            ),
            new Divider(
              color: Colors.black,
            ),
          ],
        ),
      ),
    ));
  }
}

class VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 70.0,
      width: 1.0,
      color: Colors.black,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );
  }
}

class AreaAndLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  AreaAndLineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.

  // EXCLUDE_FROM_GALLERY_DOCS_START
  // This section is excluded from being copied to the gallery.
  // It is used for creating random series data to demonstrate animation in
  // the example app only.
  factory AreaAndLineChart.withRandomData() {
    return new AreaAndLineChart(_createRandomData());
  }

  /// Create random data.
  static List<charts.Series<LinearSales, num>> _createRandomData() {
    return [
      new charts.Series<LinearSales, int>(
        id: 'Desktop',
        domainFn: (LinearSales sales, _) => sales.time,
        measureFn: (LinearSales sales, _) => sales.close,
        data: chartList,
      ),
    ];
  }

  // EXCLUDE_FROM_GALLERY_DOCS_END

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : charts.LineChart(seriesList, animate: animate, behaviors: [
            new charts.PanAndZoomBehavior(),
          ]);
  }
}

/// Sample linear data type.
class LinearSales {
  int time;
  double close;

  LinearSales(this.time, this.close);

  LinearSales.fromMap(Map map) {
    this.time = map['time'];
    this.close = double.parse(map['close'].toString());
  }
}
