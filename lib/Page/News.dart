import 'package:cryptomarket/Model/models.dart';
import 'package:cryptomarket/Page/NewsDescription.dart';
import 'package:cryptomarket/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:cryptomarket/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class News_screen extends StatefulWidget {
  const News_screen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return news_screen();
  }
}

class news_screen extends State<News_screen> {
  final _scrollController = ScrollController();
  final NewsPostBloc _newsPostBloc = NewsPostBloc(httpClient: http.Client());
  final _scrollThreshold = 200.0;

  news_screen() {
    _scrollController.addListener(_onScroll);
    _newsPostBloc.dispatch(Fetch());
  }

  @override
  void dispose() {
    _newsPostBloc.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _newsPostBloc.dispatch(Fetch());
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'News',
            style: TextStyle(fontSize: 20.0),
          ),
          elevation: 0.0,
        ),
        body: Container(
            margin: EdgeInsets.only(top: 5.0),
            child: BlocBuilder(
              bloc: _newsPostBloc,
              builder: (BuildContext context, PostState state) {
                if (state is PostUninitialized) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is PostError) {
                  return Center(
                    child: Text('Failed to fetch news posts'),
                  );
                }
                if (state is NewsLoaded) {
                  if (state.posts1.isEmpty) {
                    return Center(
                      child: Text('No news'),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.posts1.length,
                    itemBuilder: (BuildContext context, int index) {
                      return NewsWidget(news: state.posts1[index]);
                    },
                    controller: _scrollController,
                  );
                }
              },
            )));
  }
}

class NewsWidget extends StatelessWidget {
  final News news;

  const NewsWidget({
    Key key,
    @required this.news,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: InkWell(
            onTap:(){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewsDescription(news)));

            },
            child:Padding(
            padding: EdgeInsets.all(2.0),
            child: Container(
                height: 220.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage('${news.imageurl}'),
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    new Container(
                      color: Colors.black54,
                    ),
                    new Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Container(
                          alignment: Alignment.topRight,
                          child: Text(
                            news.source.toUpperCase(),
                            maxLines: 2,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        )),
                    Positioned(


                          child: Container(
                            alignment: Alignment.bottomCenter,
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              news.title,
                              maxLines: 2,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),


                    )
                  ],
                )))));
  }
}
