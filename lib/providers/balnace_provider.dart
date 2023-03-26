import 'package:flutter/material.dart';

class BalanceProvider extends ChangeNotifier {
  Map balances = {
    'Ethereum': 0.0,
    'Binance': 0.0,
    'Polygon': 0.0,
    'Fantom': 0.0,
    'Avalanche': 0.0,
    'Arbitrum': 0.0,
  };
  Map usdBalances = {
    'Ethereum': 0.0,
    'Binance': 0.0,
    'Polygon': 0.0,
    'Fantom': 0.0,
    'Avalanche': 0.0,
    'Arbitrum': 0.0,
  };
  Map change24 = {
    'Ethereum': 0.0,
    'Binance': 0.0,
    'Polygon': 0.0,
    'Fantom': 0.0,
    'Avalanche': 0.0,
    'Arbitrum': 0.0,
  };

  double total = 0.0;

  void setBalance(double amount, String chain) {
    if (balances.keys.contains(chain)) {
      balances[chain] = amount;
      notifyListeners();
    }
  }

  void setChange24(double amount, String chain) {
    if (change24.keys.contains(chain)) {
      change24[chain] = amount;
      notifyListeners();
    }
  }

  double getChange24(String chain) {
    return change24[chain];
  }

  double getBalance(String chain) {
    return balances[chain];
  }

  void setUsdBalance(double amount, String chain) {
    if (usdBalances.keys.contains(chain)) {
      usdBalances[chain] = amount;
      notifyListeners();
    }
  }

  double getUsdBalance(String chain) {
    return usdBalances[chain];
  }

  double getTotalUsdc() {
    total = 0;
    for (var chain in balances.keys) {
      total += balances[chain] * usdBalances[chain];
    }
    return total;
  }

  double currentUsdc(String chain) {
    if (chain == 'All Chains') {
      return getTotalUsdc();
    }
    return balances[chain] * usdBalances[chain];
  }
}
