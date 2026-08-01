import '../api/api_client.dart';
import '../models/market_price_model.dart';

class MarketService {
  final ApiClient _apiClient = ApiClient();

  Future<List<MarketPrice>> getMarketPrices() async {
    final response = await _apiClient.get('/api/v1/market/prices');
    return (response.data as List).map((e) => MarketPrice.fromJson(e)).toList();
  }
}
