import 'package:flutter/material.dart';

class ChainProvider with ChangeNotifier {
  String _chain = 'All Chains';
  double _totalUsdc = 0;
  double _currentUsdc = 0;
  String _nftChain = 'Ethereum';
  bool _reset = false;
  String _address = "0xbdfa4f4492dd7b7cf211209c4791af8d52bf5c50";

  String get chain => _chain;
  double get totalUsdc => _totalUsdc;
  double get currentUsdc => _currentUsdc;
  String get address => _address;
  String get nftChain => _nftChain;
  bool get reset => _reset;

  void setChain(String chain) {
    _chain = chain;
    notifyListeners();
  }

  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  void setNftChain(String chain) {
    _nftChain = chain;
    _reset = true;
    notifyListeners();
  }

  void setReset(bool reset) {
    _reset = reset;
    notifyListeners();
  }

  void setTotalUsdc(double totalUsdc) {
    _totalUsdc = totalUsdc;
    notifyListeners();
  }

  void setCurrentUsdc(double currentUsdc) {
    _currentUsdc = currentUsdc;
    notifyListeners();
  }
}
