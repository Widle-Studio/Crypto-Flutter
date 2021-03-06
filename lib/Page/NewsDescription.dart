import 'package:cryptomarket/Model/models.dart';
import 'package:flutter/material.dart';

class NewsDescription extends StatelessWidget{
  final News name;


  const NewsDescription(this.name);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          'NewsDescription',
          style: TextStyle(fontSize: 20.0),
        ),
        elevation: 0.0,
      ),
      body:SingleChildScrollView(
        child:
       new Column(
        children: <Widget>[

          new Container(
            margin: EdgeInsets.only(top: 5.0),
            height: 250.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage('${name.imageurl}'),
              ),
            ),

          ),
          new Padding(padding: EdgeInsets.only(top: 20.0,bottom: 10.0,left: 5.0,right: 5.0),
              child:Container(
                  alignment: Alignment.centerLeft,
                  child:new Text(name.source.toUpperCase(),style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600,
                  color: Colors.blueAccent),)),),


          new Padding(padding: EdgeInsets.all(10.0),
          child:new Text(name.title,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500),)),



          new Padding(padding: EdgeInsets.all(10.0),
              child:new Text(name.body,textAlign:TextAlign.justify,style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w400,),)),


        ],
      ),
      )
    );
  }
}