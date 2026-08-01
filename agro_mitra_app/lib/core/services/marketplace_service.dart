import '../api/api_client.dart';
import '../models/marketplace_model.dart';

class MarketplaceService {
  final ApiClient _apiClient = ApiClient();

  Future<List<MarketplaceProduct>> getProducts({String? category}) async {
    final response = await _apiClient.get('/api/v1/marketplace/products', queryParameters: {
      if (category != null) 'category': category,
    });
    return (response.data as List).map((e) => MarketplaceProduct.fromJson(e)).toList();
  }

  Future<List<MarketplaceCategory>> getCategories() async {
    final response = await _apiClient.get('/api/v1/marketplace/categories');
    return (response.data as List).map((e) => MarketplaceCategory.fromJson(e)).toList();
  }
}
