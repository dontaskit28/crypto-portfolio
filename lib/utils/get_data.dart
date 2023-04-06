import 'dart:convert';
import 'dart:math';
import 'package:crypto_portfolio/models/history_model.dart';
import 'package:crypto_portfolio/models/tokens_model.dart';
import 'package:crypto_portfolio/providers/balnace_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';

const String baseUrl = "https://portfolio.devdeg.com";

Future<HistoryModel> getHistory({
  required String cursor,
  required String chain,
  required String address,
}) async {
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request(
    'POST',
    Uri.parse('$baseUrl/native/transaction'),
  );
  request.body =
      json.encode({"address": address, "chain": chain, "cursor": cursor});
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    HistoryModel data = HistoryModel.fromJson(
      json.decode(
        await response.stream.bytesToString(),
      ),
      chain,
    );
    return data;
  } else {
    throw Exception('Failed to load history');
  }
}

// getTokenBalance({required String chain, required String address}) async {
//   var headers = {'Content-Type': 'application/json'};
//   var request = http.Request('POST', Uri.parse('$baseUrl/native/balance'));
//   request.body = json.encode({
//     "address": address,
//     "chain": chain,
//   });
//   request.headers.addAll(headers);

//   http.StreamedResponse response = await request.send();

//   if (response.statusCode == 200) {
//     return json.decode(await response.stream.bytesToString());
//   } else {
//     return getTokenBalance(chain: chain, address: address);
//   }
// }

getUsdPrice({required String chain, required String address}) async {
  var uri =
      "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=${usdcBalances[chain]}&order=market_cap_desc&per_page=100&page=1&sparkline=false";
  try {
    var response = await http.get(Uri.parse(uri));
    if (response.statusCode != 200) {
      throw "${response.statusCode}";
    }
    var result = json.decode(response.body);
    return result;
  } catch (e) {
    return null;
  }
}

updateUsdPrice({
  required BalanceProvider balanceProvider,
  required String address,
}) async {
  var uri =
      "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=ethereum%2Cmatic-network%2Cbinancecoin%2Cavalanche-2%2Cfantom%2Clotto-arbitrum&order=market_cap_desc&per_page=100&page=1&sparkline=false";
  try {
    var response = await http.get(Uri.parse(uri));
    if (response.statusCode != 200) {
      return null;
    }
    var result = json.decode(response.body);
    for (int i = 0; i < result.length; i++) {
      String chain = usdcBalances.keys.firstWhere(
        (element) => usdcBalances[element] == result[i]['id'],
      );
      balanceProvider.setUsdBalance(
        result[i]['current_price'],
        chain,
      );
      balanceProvider.setChange24(
        result[i]['price_change_percentage_24h'],
        chain,
      );
      // var token =
      //     await getTokenBalance(chain: symbols[chain], address: address);
      // balanceProvider.setBalance(
      //   (double.parse(token['balance'])) / pow(10, 18),
      //   chain,
      // );
    }
  } catch (e) {
    return null;
  }
}

getAllNFTCollections({
  required String chain,
  required String cursor,
  required String address,
}) async {
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request('POST', Uri.parse('$baseUrl/nft/collection'));
  request.body = json.encode({
    "address": address,
    "chain": chain,
    "cursor": cursor,
  });
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    dynamic data = json.decode(await response.stream.bytesToString());
    for (int i = 0; i < data['result'].length; i++) {
      data['result'][i]['chain'] = chain;
    }
    return data['result'];
  } else {
    throw Exception('Failed to load NFT collection');
  }
}

getNFTCollectionData({
  required String tokenAddress,
  required String chain,
  required String address,
  required bool needImage,
}) async {
  var headers = {'Content-Type': 'application/json'};
  var request =
      http.Request('POST', Uri.parse('$baseUrl/nft/collection/balance'));
  request.body = json.encode({
    "address": address,
    "token_address": tokenAddress,
    "chain": chain,
  });
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    var data = json.decode(await response.stream.bytesToString());
    if (!needImage) {
      return data['result'];
    }
    var image =
        await getImageUrl(data['result'][0]['token_uri'].toString()).then(
      (value) => value,
    );
    return image;
  } else {
    throw Exception('Failed to load NFT collection');
  }
}

Future<String> getImageUrl(String uri) async {
  try {
    var response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['image'];
    } else {
      throw Exception('Failed to load image');
    }
  } catch (e) {
    return '';
  }
}

Future<List<Tokens>> getAssetsByChain({
  required String chain,
  required String address,
}) async {
  List<Tokens> tokens = [];
  List<String> tokenAddress = [];
  List<Tokens> validTokens = [];
  if (chain == "All Chains") {
    List<Tokens> all = [];
    all.addAll(await getAssetsByChain(chain: "Ethereum", address: address));
    all.addAll(await getAssetsByChain(chain: "Polygon", address: address));
    all.addAll(await getAssetsByChain(chain: "Binance", address: address));
    all.addAll(await getAssetsByChain(chain: "Avalanche", address: address));
    all.addAll(await getAssetsByChain(chain: "Fantom", address: address));
    all.addAll(await getAssetsByChain(chain: "Arbitrum", address: address));
    return all;
  }
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request('POST', Uri.parse('$baseUrl/token/balance'));
  request.body = json.encode({
    "address": address,
    "chain": symbols[chain],
  });

  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    dynamic data = json.decode(await response.stream.bytesToString());
    for (int i = 0; i < data.length; i++) {
      tokens.add(Tokens.fromJson(data[i]));
    }

    for (var element in tokens) {
      tokenAddress.add(element.tokenAddress!);
    }
    List<double> usdPrices = await getTokenData(tokenAddress, chainIds[chain]!);
    for (int i = 0; i < usdPrices.length; i++) {
      if ((BigInt.parse(tokens[i].balance ?? '0') /
              BigInt.from(pow(10, tokens[i].decimals ?? 0))) <=
          0.001) {
        continue;
      }
      if (usdPrices[i] < 0.001) {
        continue;
      }
      tokens[i].usdPrice = usdPrices[i];
      validTokens.add(tokens[i]);
    }
    return validTokens;
  } else {
    throw ErrorDescription('Failed to load assets');
  }
}

Future<List<double>> getTokenData(
    List<String> tokenAddress, int chainId) async {
  List<Map> queries = [];
  for (var element in tokenAddress) {
    queries.add({
      "indexUid": "tokens",
      "filter": "chainId=$chainId AND address=$element",
      "limit": 5
    });
  }
  var headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer 774e711f621aa96c54d312260b5c153966218136755fcd2b2fd90118fcc85bb4'
  };
  var request = http.Request('POST',
      Uri.parse('http://search.devdeg.com/multi-search?matchingStrategy=all'));
  request.body = json.encode({"queries": queries});
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  List<double> usdPrices = [];
  if (response.statusCode == 200) {
    var data = json.decode(await response.stream.bytesToString());
    for (int i = 0; i < data['results'].length; i++) {
      if (data['results'][i]['estimatedTotalHits'] == 0) {
        usdPrices.add(0);
      } else {
        usdPrices.add(double.parse(data['results'][i]['hits'][0]["priceUSD"]));
      }
    }
    return usdPrices;
  } else {
    debugPrint(response.reasonPhrase);
    return [];
  }
}

Future<double> getPriceByChain({
  required String chain,
  required String address,
  required BalanceProvider balanceProvider,
}) async {
  if (chain == "All Chains") {
    await getPriceByChain(
        chain: "Ethereum", address: address, balanceProvider: balanceProvider);
    await getPriceByChain(
        chain: "Polygon", address: address, balanceProvider: balanceProvider);
    await getPriceByChain(
        chain: "Binance", address: address, balanceProvider: balanceProvider);
    await getPriceByChain(
        chain: "Avalanche", address: address, balanceProvider: balanceProvider);
    await getPriceByChain(
        chain: "Fantom", address: address, balanceProvider: balanceProvider);
    await getPriceByChain(
        chain: "Arbitrum", address: address, balanceProvider: balanceProvider);
    return 0;
  }
  List<Tokens> tokens = await getAssetsByChain(chain: chain, address: address);
  double total = 0;
  for (var token in tokens) {
    total += token.usdPrice! *
        (BigInt.parse(token.balance!) /
            BigInt.parse(pow(10, token.decimals!).toString()));
  }
  balanceProvider.setAsset(total, chain);
  return total;
}
