import 'package:cryptomarket/Util/SharedPreferencesHelper.dart';
import 'package:flutter/material.dart';

class CurrencyList_Screen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return currencylist();
  }

}


class currencylist extends State<CurrencyList_Screen>{
  String currency = "USD";

  List<String> currencyList =['USD','AED','CAD','EUR','GBP'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  getData() async {

    currency = await SharedPreferencesHelper.getCurrency();
    setState(() {
      currency = this.currency;
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
            'Currency',
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
                await SharedPreferencesHelper.seCurrency(currencyList[index]);
                setState(() {
                  _value = currency.contains(currencyList[index]);
                  _value = !_value;
                  currency = currencyList[index];


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
                          currencyList[index],
                          style: new TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0)),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child:currency.contains(currencyList[index])
                                ? Icon(
                              Icons.check,
                              size: 30.0,

                            )
                                : Container()),
                      )
                ],
              ))));
        }, itemCount: currencyList.length,)
      ),
    );



  }

}