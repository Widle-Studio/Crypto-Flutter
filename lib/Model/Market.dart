class Market{

  String Name;
  String LogoUrl;

  Market(this.Name, this.LogoUrl);

  Market.fromMap(Map map) {
    this.Name = map['Name'];
    this.LogoUrl = map['LogoUrl'];

  }


}