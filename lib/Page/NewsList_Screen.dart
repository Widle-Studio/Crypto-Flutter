import 'package:cryptomarket/Util/SharedPreferencesHelper.dart';
import 'package:flutter/material.dart';

class NewsList_Screen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return newslist();
  }

}


class newslist extends State<NewsList_Screen>{

  String news = 'All';

  List<String> newsList =['Coindesk','Cryptoslate','Ccn','Cryptobriefing','Cointelegraph'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  getData() async {

    news = await SharedPreferencesHelper.getNews();
    setState(() {
      news = this.news;
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
              'News',
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
                      await SharedPreferencesHelper.seNews(newsList[index]);
                      setState(() {
                        _value = news.contains(newsList[index]);
                        _value = !_value;
                        news = newsList[index];


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
                                    newsList[index],
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.0)),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child:news.contains(newsList[index])
                                      ? Icon(
                                    Icons.check,
                                    size: 30.0,

                                  )
                                      : Container()),
                            )
                          ],
                        ))));
          }, itemCount: newsList.length,)
      ),
    );
  }

}