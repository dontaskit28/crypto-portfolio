class Tokens {
  String? tokenAddress;
  String? name;
  String? symbol;
  String? logo;
  String? thumbnail;
  int? decimals;
  String? balance;

  Tokens(
      {this.tokenAddress,
      this.name,
      this.symbol,
      this.logo,
      this.thumbnail,
      this.decimals,
      this.balance});

  Tokens.fromJson(Map<String, dynamic> json) {
    tokenAddress = json['token_address'];
    name = json['name'];
    symbol = json['symbol'];
    logo = json['logo'];
    thumbnail = json['thumbnail'];
    decimals = json['decimals'];
    balance = json['balance'];
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
    return data;
  }
}
