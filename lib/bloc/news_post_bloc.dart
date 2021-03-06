import 'dart:async';
import 'dart:convert';


import 'package:cryptomarket/Model/models.dart';
import 'package:cryptomarket/Util/SharedPreferencesHelper.dart';
import 'package:cryptomarket/bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';


class NewsPostBloc extends Bloc<PostEvent, PostState> {

  final http.Client httpClient;

  NewsPostBloc({@required this.httpClient});


  @override
  Stream<PostState> transform(Stream<PostEvent> events,
      Stream<PostState> Function(PostEvent event) next,) {
    return super.transform(
      (events as Observable<PostEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  get initialState => PostUninitialized();

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is PostUninitialized) {
          final posts = await fetchNews(0, 20);
          yield NewsLoaded(posts1: posts, hasReachedMax: false);
          return;
        }
       /* if (currentState is NewsLoaded) {
          final posts =
          await fetchNews((currentState as NewsLoaded).posts1.length, 20);
          yield posts.isEmpty
              ? (currentState as NewsLoaded).copyWith(hasReachedMax: true)
              : NewsLoaded(
            posts1: (currentState as NewsLoaded).posts1 + posts,
            hasReachedMax: false,
          );
        }*/
      } catch (_) {
        yield PostError();
      }
    }
  }

  bool _hasReachedMax(PostState state) =>
      state is NewsLoaded && state.hasReachedMax;

}



  Future<List<News>> fetchNews(int startIndex, int limit) async {
    // TODO: implement fetchCurrencies

    List newsList = await SharedPreferencesHelper.getNewsList();
    String _news = newsList.toString().replaceAll('[', '').replaceAll(']', '');
    String news = await SharedPreferencesHelper.getNews();
    String apiUrl;
    if(news == ''){
      apiUrl = 'https://min-api.cryptocompare.com/data/v2/news/?lang=EN&feeds='+_news;
    }
    else{
      apiUrl = 'https://min-api.cryptocompare.com/data/v2/news/?lang=EN&feeds='+news.toLowerCase();

    }



    // Make a HTTP GET request to the CoinMarketCap API.
    // Await basically pauses execution until the get() function returns a Response
    http.Response response = await http.get(apiUrl);
    var responseBody = json.decode(response.body);

    List data = responseBody['Data'];

    final statusCode = response.statusCode;
    if (statusCode != 200 || responseBody == null) {
      throw new Exception(
          "An error ocurred : [Status Code : $statusCode]");
    }

    return data.map((c) => new News.fromMap(c)).toList();
  }
