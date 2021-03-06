import 'package:cryptomarket/Util/SharedPreferencesHelper.dart';
import 'package:flutter/material.dart';

class ExchangeList_Screen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return exchangelist();
  }

}


class exchangelist extends State<ExchangeList_Screen>{


  String exchange = "Coinbase";

  List<String> exchangeList =['Binance','Bittrex','Coinbase','Kraken','OKEx'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  getData() async {

    exchange = await SharedPreferencesHelper.getExchange();
    setState(() {
      exchange = this.exchange;
    });
  }
  bool _value = false;




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
            title: Text(
              'Exchange',
              style: TextStyle(fontSize: 20.0),
            ),
            elevation: 0.0,
          ),
          body: ListView.separated(
            separatorBuilder: (context, index) => Divider(

            ), itemBuilder: (BuildContext context, int index) {

            return Material(
                child:InkWell(
                    onTap: () async{
                      await SharedPreferencesHelper.seExchange(exchangeList[index]);
                      setState(() {
                        _value = exchange.contains(exchangeList[index]);
                        _value = !_value;
                        exchange = exchangeList[index];


                      });
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0,
                            top: 10.0,
                            right: 20.0,
                            bottom: 10.0),
                        child:Row(
                          children: <Widget>[

                            Expanded(
                              flex: 8,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0,
                                    top: 5.0,
                                    right: 10.0,
                                    bottom: 5.0),
                                child: new Text(
                                    exchangeList[index],
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.0)),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child:exchange.contains(exchangeList[index])
                                      ? Icon(
                                    Icons.check,
                                    size: 30.0,

                                  )
                                      : Container()),
                            )
                          ],
                        ))));
          }, itemCount: exchangeList.length,)
      ),
    );
  }

}