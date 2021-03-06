import 'package:equatable/equatable.dart';

class News  {
   String id;
   String guid;
   String imageurl;
   String title;
   String url;
   String source;
   String body;


  News(this.id, this.guid, this.imageurl, this.title, this.url, this.source,
      this.body);



  News.fromMap(Map map) {
    this.id = map['id'];
    this.guid = map['guid'];
    this.imageurl = map['imageurl'];
    this.title = map['title'];
    this.url = map['url'];
    this.source = map['source'];
    this.body = map['body'];
  }
}
