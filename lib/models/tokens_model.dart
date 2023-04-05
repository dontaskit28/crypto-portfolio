class Tokens {
  String? tokenAddress;
  String? name;
  String? symbol;
  String? logo;
  String? thumbnail;
  int? decimals;
  String? balance;
  double? usdPrice;

  Tokens({
    this.tokenAddress,
    this.name,
    this.symbol,
    this.logo,
    this.thumbnail,
    this.decimals,
    this.balance,
    this.usdPrice,
  });

  Tokens.fromJson(Map<String, dynamic> json) {
    tokenAddress = json['token_address'];
    name = json['name'];
    symbol = json['symbol'];
    logo = json['logo'];
    thumbnail = json['thumbnail'];
    decimals = json['decimals'];
    balance = json['balance'];
    usdPrice = 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token_address'] = tokenAddress;
    data['name'] = name;
    data['symbol'] = symbol;
    data['logo'] = logo;
    data['thumbnail'] = thumbnail;
    data['decimals'] = decimals;
    data['balance'] = balance;
    data['usdPrice'] = usdPrice;
    return data;
  }
}
