class MarketplaceProduct {
  final String id;
  final String name;
  final String price;
  final String category;
  final double rating;
  final String? imageUrl;
  final bool isTrending;

  MarketplaceProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.rating,
    this.imageUrl,
    this.isTrending = false,
  });

  factory MarketplaceProduct.fromJson(Map<String, dynamic> json) {
    return MarketplaceProduct(
      id: json['id'],
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      category: json['category'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      imageUrl: json['image_url'],
      isTrending: json['is_trending'] ?? false,
    );
  }
}

class MarketplaceCategory {
  final String label;
  final String icon;

  MarketplaceCategory({required this.label, required this.icon});

  factory MarketplaceCategory.fromJson(Map<String, dynamic> json) {
    return MarketplaceCategory(
      label: json['label'] ?? '',
      icon: json['icon'] ?? 'eco',
    );
  }
}
