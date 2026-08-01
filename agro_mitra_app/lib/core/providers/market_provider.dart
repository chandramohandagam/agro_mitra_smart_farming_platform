import 'package:flutter/material.dart';
import '../services/market_service.dart';
import '../models/market_price_model.dart';

enum MarketStatus { loading, loaded, error }

class MarketProvider extends ChangeNotifier {
  final MarketService _marketService = MarketService();

  MarketStatus _status = MarketStatus.loading;
  List<MarketPrice> _prices = [];
  String? _errorMessage;

  MarketStatus get status => _status;
  List<MarketPrice> get prices => _prices;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPrices() async {
    _status = MarketStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _prices = await _marketService.getMarketPrices();
      _status = MarketStatus.loaded;
    } catch (e) {
      _status = MarketStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
