import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cryptomarket/Model/models.dart';
import 'package:cryptomarket/Util/SharedPreferencesHelper.dart';
import 'package:cryptomarket/bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'package:rxdart/rxdart.dart';


class MarketCoinsBloc extends Bloc<PostEvent, PostState> {

  final http.Client httpClient;

  MarketCoinsBloc({@required this.httpClient});



  @override
  Stream<PostState> transform(Stream<PostEvent> events,
      Stream<PostState> Function(PostEvent event) next,) {
    return super.transform((events as Observable<PostEvent>).debounceTime(
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
          final posts = await fetchMarket1(0, 20);
          yield MarketCoinsLoaded(marketcoins: posts, hasReachedMax: false);
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
      state is MarketCoinsLoaded && state.hasReachedMax;


  Future<List<CoinsMarketData>> fetchMarket1(int startIndex, int limit) async {
    // TODO: implement fetchCurrencies
    //   String apiUrl = 'https://min-api.cryptocompare.com/data/exchanges/general?api_key=5fa8278700ff48c403c9356a7ce85705177ebf3f4b8b0bc5a9e9151f5143d095';

    String apiUrl = "https://min-api.cryptocompare.com/data/v2/all/exchanges";

    http.Response response = await http.get(apiUrl);
    String market = await SharedPreferencesHelper.getMarket();
    String currency = await SharedPreferencesHelper.getCurrency();

    // Iterable l = json.decode(response.body);
    List<CoinsMarketData> posts = new List();

    var responseBody = json.decode(response.body);

    var data = responseBody['Data'][market];

      if (data != null) {
        data.forEach((key, value) async {
          print('Key: $key, Value:' + '$value');

          if (key != "is_active") {
            var valuedata = value;
            valuedata.forEach((key1, value1) async {
              //  print('Key: $key1, Value:' + value1['Name']);

            //   posts.add(CoinsMarketData(key1, "".toString(),"".toString(),"".toString(),"".toString(),"".toString(),"".toString(),"".toString(),"".toString(),"".toString(),"".toString()));


              String coinData = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=" +
                  key1 + "&tsyms=" + currency;
              http.Response coinresponse = await http.get(coinData);
              var coinresponseBody = json.decode(coinresponse.body);
              var Raw = coinresponseBody['RAW'];

              if (Raw != null) {
                var MarketName = Raw[key1];
                var curenncy = MarketName['USD'];
                posts.add(CoinsMarketData(
                  curenncy['PRICE'].toString(),
                  curenncy['CHANGEPCT24HOUR'].toString(),
                  curenncy['MARKET'].toString(),
                    curenncy['CHANGE24HOUR'].toString(),
                  curenncy['HIGH24HOUR'].toString(),
                  curenncy['LOW24HOUR'].toString(),
                  curenncy['MKTCAP'].toString(),
                  curenncy['VOLUME24HOUR'].toString(),
                  curenncy['VOLUME24HOURTO'].toString(),
                  curenncy['TOSYMBOL'].toString(),
                  curenncy['SUPPLY'].toString(),
                  curenncy['FROMSYMBOL'].toString(),
                    curenncy['IMAGEURL'].toString()));


              }
            });
          }



        });




      }



      final statusCode = response.statusCode;
      if (statusCode != 200 || responseBody == null) {
        throw new Exception(
            "An error ocurred : [Status Code : $statusCode]");
      }


      return posts;

  }

}
