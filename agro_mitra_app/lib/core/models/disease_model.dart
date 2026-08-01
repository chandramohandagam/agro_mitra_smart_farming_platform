class DiseaseDetectionResult {
  final String diseaseName;
  final String scientificName;
  final int confidence;
  final String severity;
  final List<String> treatmentSteps;
  final double humidityContext;
  final List<RecommendedProduct> recommendations;

  DiseaseDetectionResult({
    required this.diseaseName,
    required this.scientificName,
    required this.confidence,
    required this.severity,
    required this.treatmentSteps,
    required this.humidityContext,
    required this.recommendations,
  });

  factory DiseaseDetectionResult.fromJson(Map<String, dynamic> json) {
    return DiseaseDetectionResult(
      diseaseName: json['disease_name'] ?? '',
      scientificName: json['scientific_name'] ?? '',
      confidence: json['confidence'] ?? 0,
      severity: json['severity'] ?? 'Low',
      treatmentSteps: List<String>.from(json['treatment_steps'] ?? []),
      humidityContext: (json['humidity_context'] ?? 0.0).toDouble(),
      recommendations: (json['recommendations'] as List? ?? []).map((e) => RecommendedProduct.fromJson(e)).toList(),
    );
  }
}

class RecommendedProduct {
  final String name;
  final String price;
  final String? imageUrl;

  RecommendedProduct({required this.name, required this.price, this.imageUrl});

  factory RecommendedProduct.fromJson(Map<String, dynamic> json) {
    return RecommendedProduct(
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      imageUrl: json['image_url'],
    );
  }
}
