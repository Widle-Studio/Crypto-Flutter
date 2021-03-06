import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _currency = "currency";

  static final String _exchange = 'exchange';

  static final String _news = 'news';
  static final String _market = 'market';

  static final String _theme = 'theme';
  static final String _notification = 'notification';
  static final String _notificationFlag = 'flag';

  static final String _coinsList = "coins";
  static final String _newsList = "news12";
  static final List<String> data =[];
  static final List<String> News = ['coindesk','ccn','cryptoslate','cryptobriefing','cointelegraph'];

  /// ------------------------------------------------------------
  /// Method that returns the user currency code, 'USD' if not set
  /// ------------------------------------------------------------
  static Future<String> getCurrency() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_currency) ?? 'USD';
  }

  /// ----------------------------------------------------------
  /// Method that saves the user currency code
  /// ----------------------------------------------------------
  static Future<bool> seCurrency(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_currency, value);
  }



  /// ------------------------------------------------------------
  /// Method that returns the user currency code, 'Coinbase' if not set
  /// ------------------------------------------------------------
  static Future<String> getExchange() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_exchange) ?? 'Coinbase';
  }

  /// ----------------------------------------------------------
  /// Method that saves the user currency code
  /// ----------------------------------------------------------
  static Future<bool> seExchange(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_exchange, value);
  }





  /// ------------------------------------------------------------
  /// Method that returns the user currency code, 'Coinbase' if not set
  /// ------------------------------------------------------------
  static Future<String> getNews() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_news) ?? '';
  }

  /// ----------------------------------------------------------
  /// Method that saves the user currency code
  /// ----------------------------------------------------------
  static Future<bool> seNews(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_news, value);
  }



  /// ----------------------------------------------------------
  /// Method that saves the coin list
  /// ----------------------------------------------------------

  static Future<bool> setCoinsList(List<String> coins) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setStringList(_coinsList, coins);
  }


  /// ------------------------------------------------------------
  /// Method that returns the CoinList
  /// ------------------------------------------------------------
  static Future<List<String>> getCoinList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_coinsList) ?? data;
  }





  /// ----------------------------------------------------------
  /// Method that saves the coin list
  /// ----------------------------------------------------------

  static Future<bool> setNewsList(List<String> news) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setStringList(_newsList, news);
  }


  /// ------------------------------------------------------------
  /// Method that returns the CoinList
  /// ------------------------------------------------------------
  static Future<List<String>> getNewsList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_newsList) ?? News;
  }



  /// ------------------------------------------------------------
  /// Method that returns the user market code, 'Coinbase' if not set
  /// ------------------------------------------------------------
  static Future<String> getMarket() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_market) ?? '';
  }

  /// ----------------------------------------------------------
  /// Method that saves the user market code
  /// ----------------------------------------------------------
  static Future<bool> seMarket(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_market, value);
  }






  /// ------------------------------------------------------------
  /// Method that returns the user theme if not set
  /// ------------------------------------------------------------
  static Future<String> getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_theme) ?? 'Light';
  }

  /// ----------------------------------------------------------
  /// Method that saves the user theme code
  /// ----------------------------------------------------------
  static Future<bool> seTheme(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_theme, value);
  }



  // ------------------------------------------------------------
  /// Method that returns the user Notification if not set
  /// ------------------------------------------------------------
  static Future<String> getNotification() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_notification) ?? 'Hourly';
  }

  /// ----------------------------------------------------------
  /// Method that saves the user Notification
  /// ----------------------------------------------------------
  static Future<bool> setNotification(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_notification, value);
  }

  // ------------------------------------------------------------
  /// Method that returns the user Notification if not set
  /// ------------------------------------------------------------
  static Future<bool> getNotificationFlag() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_notificationFlag) ?? false;
  }

  /// ----------------------------------------------------------
  /// Method that saves the user Notification
  /// ----------------------------------------------------------
  static Future<bool> setNotificationFlag(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_notificationFlag, value);
  }
}