import 'package:flutter/material.dart';
import '../services/marketplace_service.dart';
import '../models/marketplace_model.dart';

enum MarketplaceStatus { loading, loaded, error }

class MarketplaceProvider extends ChangeNotifier {
  final MarketplaceService _service = MarketplaceService();

  MarketplaceStatus _status = MarketplaceStatus.loading;
  List<MarketplaceProduct> _products = [];
  List<MarketplaceCategory> _categories = [];
  String? _selectedCategory;
  String? _errorMessage;

  MarketplaceStatus get status => _status;
  List<MarketplaceProduct> get products => _products;
  List<MarketplaceCategory> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  String? get errorMessage => _errorMessage;

  Future<void> init() async {
    await fetchCategories();
    await fetchProducts();
  }

  Future<void> fetchCategories() async {
    try {
      _categories = await _service.getCategories();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> fetchProducts({String? category}) async {
    _status = MarketplaceStatus.loading;
    _selectedCategory = category;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _service.getProducts(category: category);
      _status = MarketplaceStatus.loaded;
    } catch (e) {
      _status = MarketplaceStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
