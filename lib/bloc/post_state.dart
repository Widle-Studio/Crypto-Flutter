
import 'package:cryptomarket/Model/models.dart';
import 'package:equatable/equatable.dart';



abstract class PostState extends Equatable {
  PostState([List props = const []]) : super(props);
}

class PostUninitialized extends PostState {
  @override
  String toString() => 'PostUninitialized';
}

class PostError extends PostState {
  @override
  String toString() => 'PostError';
}

class PostLoaded extends PostState {
  final List<GetCoinsAdd> posts;
  final bool hasReachedMax;

  PostLoaded({
    this.posts,
    this.hasReachedMax,
  }) : super([posts, hasReachedMax]);

  PostLoaded copyWith({
    List<GetCoinsAdd> posts,
    bool hasReachedMax,
  }) {
    return PostLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() =>
      'PostLoaded { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}


class NewsLoaded extends PostState {
  final List<News> posts1;
  final bool hasReachedMax;

  NewsLoaded({
    this.posts1,
    this.hasReachedMax,
  }) : super([posts1, hasReachedMax]);

  NewsLoaded copyWith({
    List<News> posts,
    bool hasReachedMax,
  }) {
    return NewsLoaded(
      posts1: posts ?? this.posts1,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() =>
      'PostLoaded { posts: ${posts1.length}, hasReachedMax: $hasReachedMax }';
}





class MarketLoaded extends PostState {
  final List<Market> market;
  final bool hasReachedMax;

  MarketLoaded({
    this.market,
    this.hasReachedMax,
  }) : super([market, hasReachedMax]);

  MarketLoaded copyWith({
    List<Market> market1,
    bool hasReachedMax,
  }) {
    return MarketLoaded(
      market: market1 ?? this.market,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() =>
      'PostLoaded { posts: ${market.length}, hasReachedMax: $hasReachedMax }';
}






class MarketCoinsLoaded extends PostState {
  final List<CoinsMarketData> marketcoins;
  final bool hasReachedMax;

  MarketCoinsLoaded({
    this.marketcoins,
    this.hasReachedMax,
  }) : super([marketcoins, hasReachedMax]);

  MarketCoinsLoaded copyWith({
    List<CoinsMarketData> marketcoins1,
    bool hasReachedMax,
  }) {
    return MarketCoinsLoaded(
      marketcoins: marketcoins1 ?? this.marketcoins,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() =>
      'PostLoaded { posts: ${marketcoins.length}, hasReachedMax: $hasReachedMax }';
}