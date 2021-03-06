import 'dart:convert';

import 'package:cryptomarket/Model/models.dart';
import 'package:cryptomarket/Page/CoinDescription.dart';
import 'package:cryptomarket/Page/Dashboard.dart';
import 'package:cryptomarket/Page/MarketCoins.dart';
import 'package:cryptomarket/Util/SharedPreferencesHelper.dart';
import 'package:flutter/material.dart';
import 'package:cryptomarket/Model/GetCoinsAdd.dart';

import 'package:cryptomarket/bloc/bloc.dart';
import 'package:cryptomarket/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class Markets_Screen extends StatefulWidget {
  const Markets_Screen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return markets();
  }
}

class markets extends State<Markets_Screen> {
  final _scrollController = ScrollController();

  //final PostBloc _postBloc = PostBloc(httpClient: http.Client());
  final _scrollThreshold = 200.0;
  TextEditingController controller = new TextEditingController();
  List<GetCoinsAdd> search_coin_list = new List();

  List<GetCoinsAdd> coinList = new List();
  var isLoading = false;
  bool _value = false;

  List _selecteCategorys = List();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCoin();
  }

  getCoin() async {
    _selecteCategorys = await SharedPreferencesHelper.getCoinList();
    fetchCurrencies();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Markets'),
        centerTitle: true,
      ),
      body: new Column(
        children: <Widget>[
          new Container(
            color: Theme.of(context).primaryColor,
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                child: new ListTile(
                  leading: new Icon(Icons.search),
                  title: new TextField(
                    controller: controller,
                    decoration: new InputDecoration(
                        hintText: 'Search Coins', border: InputBorder.none),
                    onChanged: onSearchTextChanged,
                  ),
                ),
              ),
            ),
          ),
          new Expanded(
            child: search_coin_list.length != 0 || controller.text.isNotEmpty
                ? new ListView.separated(
              separatorBuilder: (context, index) => Divider(

              ),
              itemCount: search_coin_list.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => CoinDescription(search_coin_list[index])));
                    },
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                top: 5.0,
                                right: 10.0,
                                bottom: 5.0),
                            child: new Image.network(
                              "https://www.cryptocompare.com" +
                                  search_coin_list[index].CoinInfo.ImageUrl,
                              height: 50.0,
                              width: 50.0,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                top: 5.0,
                                right: 10.0,
                                bottom: 5.0),
                            child: new Text(
                                search_coin_list[index].CoinInfo.FullName,
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0)),
                          ),
                        ),

                      ],
                    ));
              },
            )
                : isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : ListView.separated(
              separatorBuilder: (context, index) => Divider(

              ),
              itemCount: coinList.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => CoinDescription(coinList[index])));
                    },
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                top: 5.0,
                                right: 10.0,
                                bottom: 5.0),
                            child: new Image.network(
                              "https://www.cryptocompare.com" +
                                  coinList[index].CoinInfo.ImageUrl,
                              height: 50.0,
                              width: 50.0,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                top: 5.0,
                                right: 10.0,
                                bottom: 5.0),
                            child: new Text(
                                coinList[index].CoinInfo.FullName,
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0)),
                          ),
                        ),

                      ],
                    ));
              },
            ),
          )
        ],
      ),

      /* Column(
        children: <Widget>[
          new Container(
            color: Theme.of(context).primaryColor,
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Card(
                child: new ListTile(
                  leading: new Icon(Icons.search),
                  title: new TextField(
                    controller: controller,
                    decoration: new InputDecoration(
                        hintText: 'Search product', border: InputBorder.none),
                    onChanged: onSearchTextChanged,
                  ),
                */ /*  trailing: new IconButton(
                    icon: new Icon(Icons.cancel),
                    onPressed: () {
                      controller.clear();
                      onSearchTextChanged('');
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Brand_SearchList()));
                    },
                  ),*/ /*
                ),
              ),
            ),
          ),

          Container(
              margin: EdgeInsets.only(top: 5.0),
              child: BlocBuilder(
                bloc: _postBloc,
                builder: (BuildContext context, PostState state) {
                  if (state is PostUninitialized) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is PostError) {
                    return Center(
                      child: Text('failed to fetch posts'),
                    );
                  }
                  if(state is PostLoaded){
                    return onSearchTextChanged(controller.text);
                  }
                  if (state is PostLoaded) {
                    if (state.posts.isEmpty) {
                      return Center(
                        child: Text('no posts'),
                      );
                    }
                    return ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.black,
                      ),
                      itemCount: state.posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return   Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: new Image.network(
                                "https://www.cryptocompare.com" + state.posts[index].CoinInfo.ImageUrl,
                                height: 50.0,
                                width: 50.0,
                              ),
                            ),
                            Expanded(
                                flex: 8,
                                child: CheckboxListTile(
                                  value: _selecteCategorys.contains(state.posts[index].CoinInfo.Name),
                                  onChanged: (bool selected) {
                                    _onCategorySelected(selected,
                                        state.posts[index].CoinInfo.Name);
                                  },
                                  title: Text(state.posts[index].CoinInfo.FullName),
                                )
                            ),
                          ],
                        );
                      },

                    );
                  }
                },
              )),
        ],
      )*/
    );
  }

  Widget _serarch() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Card(
              child: new ListTile(
                leading: new Icon(Icons.search),
                title: new TextField(
                  controller: controller,
                  decoration: new InputDecoration(
                      hintText: 'Search product', border: InputBorder.none),
                  onChanged: onSearchTextChanged,
                ),
              ))),
    );
  }

  Future<List<GetCoinsAdd>> fetchCurrencies() async {
    setState(() {
      isLoading = true;
    });
    // TODO: implement fetchCurrencies
    String currency = await SharedPreferencesHelper.getCurrency();
    List coins = await SharedPreferencesHelper.getCoinList();
    /*  String coinsdata = coins.toString().replaceAll('[', '').replaceAll(']', '');
    String Baseurl = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=" + coinsdata + "&tsyms=" + currency + "&extraParams=your_app_name";
*/
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

    coinList = (data).map((data) => new GetCoinsAdd.fromMap(data)).toList();
    setState(() {
      isLoading = false;
    });
    return data.map((c) => new GetCoinsAdd.fromMap(c)).toList();
  }

  onSearchTextChanged(String text) async {
    search_coin_list.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    coinList.forEach((userDetail) {
      if (userDetail.CoinInfo.FullName
          .toLowerCase()
          .contains(text.toLowerCase()) ||
          userDetail.CoinInfo.FullName
              .toLowerCase()
              .contains(text.toLowerCase())) search_coin_list.add(userDetail);
    });

    setState(() {});
  }
}
