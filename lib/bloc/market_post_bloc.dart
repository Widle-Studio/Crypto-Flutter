import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cryptomarket/Model/models.dart';
import 'package:cryptomarket/bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'package:rxdart/rxdart.dart';


class MarketPostBloc extends Bloc<PostEvent, PostState> {

  final http.Client httpClient;

  MarketPostBloc({@required this.httpClient});



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
          final posts = await fetchMarket(0, 20);
          yield MarketLoaded(market: posts, hasReachedMax: false);
          return;
        }
      /*  if (currentState is MarketLoaded) {
          final posts =
          await fetchMarket((currentState as MarketLoaded).market.length, 20);
          yield posts.isEmpty
              ? (currentState as MarketLoaded).copyWith(hasReachedMax: true)
              : MarketLoaded(
           market:  (currentState as MarketLoaded).market + posts,
            hasReachedMax: false,
          );
        }*/
      } catch (_) {
        yield PostError();
      }
    }
  }

  bool _hasReachedMax(PostState state) =>
      state is MarketLoaded && state.hasReachedMax;


  Future<List<Market>> fetchMarket(int startIndex, int limit) async {
    // TODO: implement fetchCurrencies
    String apiUrl = 'https://min-api.cryptocompare.com/data/exchanges/general?api_key=5fa8278700ff48c403c9356a7ce85705177ebf3f4b8b0bc5a9e9151f5143d095';

    // Make a HTTP GET request to the CoinMarketCap API.
    // Await basically pauses execution until the get() function returns a Response
    http.Response response = await http.get(apiUrl);

   // Iterable l = json.decode(response.body);
    List<Market> posts = new List();

    var responseBody = json.decode(response.body);




    var data = responseBody['Data'];


    data.forEach((key, value) async {
      print('Key: $key, Value:' + value['Name']);

      //posts = Market(value['Name'], value['LogoUrl']);
      posts.add(Market(value['Name'], value['LogoUrl']));

   //   posts = data.map((c) => new Market.fromMap(c)).toList();

    });


/*    var data = responseBody['Data'] as List;
    for(var key in responseBody){

      print("Key: " + key);
      print("Value: " + responseBody['Data'][key]['Name']);
    }*/




    final statusCode = response.statusCode;
    if (statusCode != 200 || responseBody == null) {
      throw new Exception(
          "An error ocurred : [Status Code : $statusCode]");
    }

    return posts;
  }

}
