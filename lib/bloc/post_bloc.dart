import 'dart:async';
import 'dart:convert';

import 'package:cryptomarket/Model/models.dart';
import 'package:cryptomarket/Util/SharedPreferencesHelper.dart';
import 'package:cryptomarket/bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class PostBloc extends Bloc<PostEvent, PostState> {
  final http.Client httpClient;
  final StreamController<GetCoinsAdd> streamc;

  PostBloc({
    @required this.httpClient, this.streamc
  });

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
          final posts = await fetchCurrencies(0, 20);
          yield PostLoaded(posts: posts, hasReachedMax: false);

          return;
        }
      } catch (_) {
        yield PostError();
      }
    }
  }

  bool _hasReachedMax(PostState state) =>
      state is PostLoaded && state.hasReachedMax;

  Future<List<GetCoinsAdd>> fetchCurrencies(int startIndex, int limit) async {
    String currency = await SharedPreferencesHelper.getCurrency();
    List coins = await SharedPreferencesHelper.getCoinList();
    String exchange = await SharedPreferencesHelper.getExchange();
    var subscription = [
    ]; //= [ '5~CCCAGG~ETH~USD', '5~CCCAGG~XRP~USD', '5~CCCAGG~IOT~USD', '5~CCCAGG~XLM~USD', '5~CCCAGG~XMR~USD'];


    for (int i = 0; i < coins.length; i++) {
      subscription.add('5~CCCAGG~' + coins[i] + '~' + currency);
    }
    IO.Socket socket = IO.io(
        'https://streamer.cryptocompare.com/', <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'foo': 'bar'}
    });
    socket.on('connect', (_) {
      print('connect');


      socket.emit('SubAdd', { 'subs': subscription});
      socket.on("m", (data) {
        // print(data)

        var x = data.split("~");
        //print(x[1]);
        if (x[0] == 3 || x[0] == 401) {
          print(x);
        }
        else {
          for (var i = 0; i < x.length; i++) {
            if (x.length > 5) {
              if (i == 2) {
                String a = x[4];
                if (a == '1') {
                  var messageType = data.substring(0, data.indexOf("~"));
                  print(x[2] + ' = ' + x[3] + ' = ' + x[4] + ' = ' + x[5] +
                      ' = ' + messageType + ' = ' + ' + ');

                  var setDAta = [
                    x[2] + ' = ' + x[3] + ' = ' + x[4] + ' = ' + x[5] + ' = ' +
                        messageType + ' = ' + ' + '
                  ];
                  //print(a);
                  var dataSet = {x[3]: {}};
                //  return setDAta.map((c) => new GetCoinsAdd.fromMap(c)).toList();
                }
                else if (a == '2') {
                  var messageType = data.substring(0, data.indexOf("~"));
                  print(x[2] + ' = ' + x[3] + ' = ' + x[4] + ' = ' + x[5] +
                      ' = ' + messageType + ' = ' + ' - ');

                  //print(a);
                  var setDAta = [
                    x[2] + ' = ' + x[3] + ' = ' + x[4] + ' = ' + x[5] + ' = ' +
                        messageType + ' = ' + ' - '
                  ];
                  //print(a);
                 // return setDAta.map((c) => new GetCoinsAdd.fromMap(c)).toList();
                }
              }
            }
          }
        }
      });
    });
    socket.on('event', (data) => print(data));
    socket.on('disconnect', (_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));


    // TODO: implement fetchCurrencies

    String coinsdata = coins.toString().replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll(" ", "");
    String Baseurl = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=" +
        coinsdata + "&tsyms=" + currency + "&e=" + exchange;

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

    print(statusCode);
    //  print(data.map((c) => new GetCoinsAdd.fromMap(c)).toList());
  //  streamc.add(data.map((c) => new GetCoinsAdd.fromMap(c)).toList());
    //streamc =data.map((c) => new GetCoinsAdd.fromMap(c)),toList() as StreamController<GetCoinsAdd>;
    return data.map((c) => new GetCoinsAdd.fromMap(c)).toList();
  }
}