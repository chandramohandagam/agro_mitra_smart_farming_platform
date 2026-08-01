class MarketPrice {
  final String commodity;
  final String market;
  final double price;
  final String unit;
  final double change; // Percentage change
  final DateTime updatedAt;

  MarketPrice({
    required this.commodity,
    required this.market,
    required this.price,
    required this.unit,
    required this.change,
    required this.updatedAt,
  });

  factory MarketPrice.fromJson(Map<String, dynamic> json) {
    return MarketPrice(
      commodity: json['commodity'] ?? '',
      market: json['market'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      unit: json['unit'] ?? 'Quintal',
      change: (json['change'] ?? 0.0).toDouble(),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
