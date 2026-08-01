class CropRecommendationResponse {
  final List<CropRecommendation> recommendations;
  final List<String> soilHealthSummary;
  final String climateOutlook;

  CropRecommendationResponse({
    required this.recommendations,
    required this.soilHealthSummary,
    required this.climateOutlook,
  });

  factory CropRecommendationResponse.fromJson(Map<String, dynamic> json) {
    return CropRecommendationResponse(
      recommendations: (json['recommendations'] as List).map((e) => CropRecommendation.fromJson(e)).toList(),
      soilHealthSummary: List<String>.from(json['soil_health_summary'] ?? []),
      climateOutlook: json['climate_outlook'] ?? '',
    );
  }
}

class CropRecommendation {
  final String name;
  final int matchPercentage;
  final String description;
  final String expectedYield;
  final String profitEstimate;
  final String riskLevel;
  final String? imageUrl;

  CropRecommendation({
    required this.name,
    required this.matchPercentage,
    required this.description,
    required this.expectedYield,
    required this.profitEstimate,
    required this.riskLevel,
    this.imageUrl,
  });

  factory CropRecommendation.fromJson(Map<String, dynamic> json) {
    return CropRecommendation(
      name: json['name'] ?? '',
      matchPercentage: json['match_percentage'] ?? 0,
      description: json['description'] ?? '',
      expectedYield: json['expected_yield'] ?? '',
      profitEstimate: json['profit_estimate'] ?? '',
      riskLevel: json['risk_level'] ?? 'Low',
      imageUrl: json['image_url'],
    );
  }
}
