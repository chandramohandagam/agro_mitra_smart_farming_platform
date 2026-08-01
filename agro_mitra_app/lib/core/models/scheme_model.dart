class GovScheme {
  final String id;
  final String title;
  final String description;
  final String icon;
  final List<String> tags;
  final String status; // Active, Recommended, etc.

  GovScheme({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.tags,
    required this.status,
  });

  factory GovScheme.fromJson(Map<String, dynamic> json) {
    return GovScheme(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? 'payments',
      tags: List<String>.from(json['tags'] ?? []),
      status: json['status'] ?? 'Active',
    );
  }
}

class SchemeApplication {
  final String schemeId;
  final String schemeTitle;
  final String status; // Approved, Pending, Eligible
  final DateTime updatedAt;

  SchemeApplication({
    required this.schemeId,
    required this.schemeTitle,
    required this.status,
    required this.updatedAt,
  });

  factory SchemeApplication.fromJson(Map<String, dynamic> json) {
    return SchemeApplication(
      schemeId: json['scheme_id'],
      schemeTitle: json['scheme_title'] ?? '',
      status: json['status'] ?? 'Pending',
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
