import 'dart:convert';
import 'dart:math';
import 'package:crypto_portfolio/models/history_model.dart';
import 'package:crypto_portfolio/models/tokens_model.dart';
import 'package:crypto_portfolio/providers/balnace_provider.dart';
import 'package:crypto_portfolio/providers/chain_provider.dart';
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

getTokenBalance({required String chain, required String address}) async {
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request('POST', Uri.parse('$baseUrl/native/balance'));
  request.body = json.encode({
    "address": address,
    "chain": chain,
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    return json.decode(await response.stream.bytesToString());
  } else {
    return getTokenBalance(chain: chain, address: address);
  }
}

getUsdPrice({required String chain, required String address}) async {
  var uri =
      "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=${usdcBalances[chain]}&order=market_cap_desc&per_page=100&page=1&sparkline=false";
  try {
    var response = await http.get(Uri.parse(uri));
    print("hello");
    if (response.statusCode != 200) {
      return getUsdPrice(chain: chain, address: address);
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
      var token =
          await getTokenBalance(chain: symbols[chain], address: address);
      balanceProvider.setBalance(
        (double.parse(token['balance'])) / pow(10, 18),
        chain,
      );
    }
  } catch (e) {
    return null;
  }
}

// getTotalUSD({
//   ChainProvider? chainProvider,
//   BalanceProvider? balanceProvider,
//   required String address,
// }) async {
//   List chains = [
//     'Ethereum',
//     'Polygon',
//     'Binance',
//     'Avalanche',
//     'Fantom',
//     'Arbitrum',
//   ];
//   double totalUsd = 0;
//   for (var chain in chains) {
//     var price = await getUsdPrice(chain: chain, address: address);
//     if (price == null) {
//       continue;
//     }
//     if (balanceProvider != null) {
//       balanceProvider.setBalance(price[0]['balance'], chain);
//       balanceProvider.setUsdBalance(price[0]['current_price'], chain);
//     }

//     totalUsd += price[0]['current_price'] * price[0]['balance'];
//   }
//   if (chainProvider == null) {
//     return totalUsd;
//   }
//   chainProvider.setTotalUsdc(totalUsd);
//   chainProvider.setCurrentUsdc(totalUsd);
// }

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
  if (chain == "All Chains") {
    throw ErrorDescription('All Chains');
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
    return tokens;
  } else {
    throw ErrorDescription('Failed to load assets');
  }
}
