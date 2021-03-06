

class GetCoinsAdd {
  CoinInfo1 CoinInfo;
  Display1 Display;


  GetCoinsAdd(this.CoinInfo, this.Display);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['CoinInfo'] = CoinInfo;
    map['DISPLAY'] = Display;

    return map;
  }

  GetCoinsAdd.fromMap(Map<String, dynamic> map) {
    this.CoinInfo = new CoinInfo1.fromMap(map['CoinInfo']);
    this.Display = new Display1.fromMap(map['DISPLAY']);//.map((i) => Pickup_order.fromMap(i));
  }
}

class CoinInfo1 {
  String FullName;
  String Name;
  String ImageUrl;

  CoinInfo1(this.FullName,this.Name, this.ImageUrl);

  CoinInfo1.fromMap(Map map) {
    this.FullName = map['FullName'];
    this.Name = map['Name'];
    this.ImageUrl = map['ImageUrl'];
  }
}



class Display1 {
  USD1 USD;

  Display1(this.USD,  );

  Display1.fromMap(Map map)  {
   // var _list = map.values.toList();

    String mapdata = map.keys.toString();

    if(mapdata == "(USD)"){
      this.USD = new USD1.fromMap(map['USD']);
    }
    else if(mapdata == "(EUR)"){

      this.USD = new USD1.fromMap(map['EUR']);
    }
    else if(mapdata == "(AED)"){

      this.USD = new USD1.fromMap(map['AED']);
    }
    else if(mapdata == "(CAD)"){

      this.USD = new USD1.fromMap(map['CAD']);
    }
    else if(mapdata == "(GBP)"){

      this.USD = new USD1.fromMap(map['GBP']);
    }


  }
}

class USD1 {
  String PRICE;
  String CHANGEPCT24HOUR;
  String MARKET;
  String CHANGE24HOUR;
  String HIGH24HOUR;
  String LOW24HOUR;
  String MKTCAP;
  String VOLUME24HOUR;
  String VOLUME24HOURTO;
  String TOSYMBOL;
  String SUPPLY;


  USD1(this.PRICE, this.CHANGEPCT24HOUR, this.MARKET, this.CHANGE24HOUR,
      this.HIGH24HOUR, this.LOW24HOUR, this.MKTCAP, this.VOLUME24HOUR,
      this.VOLUME24HOURTO, this.TOSYMBOL,this.SUPPLY);

  USD1.fromMap(Map map) {
    this.PRICE = map['PRICE'];
    this.CHANGEPCT24HOUR = map['CHANGEPCT24HOUR'];
    this.MARKET = map['MARKET'];
    this.CHANGE24HOUR = map['CHANGE24HOUR'];
    this.HIGH24HOUR = map['HIGH24HOUR'];
    this.LOW24HOUR = map['LOW24HOUR'];
    this.MKTCAP = map['MKTCAP'];
    this.VOLUME24HOUR = map['VOLUME24HOUR'];
    this.VOLUME24HOURTO = map['VOLUME24HOURTO'];
    this.TOSYMBOL = map['TOSYMBOL'];
    this.SUPPLY = map['SUPPLY'];

  }
}



abstract class CryptoRepository {
  Future<List<GetCoinsAdd>> fetchCurrencies();
}