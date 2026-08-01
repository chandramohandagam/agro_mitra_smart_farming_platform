class Farm {
  final String id;
  final String name;
  final String crop;
  final String phase;
  final String area;
  final String soil;
  final DateTime expectedHarvest;
  final double progress;
  final String icon;

  Farm({
    required this.id,
    required this.name,
    required this.crop,
    required this.phase,
    required this.area,
    required this.soil,
    required this.expectedHarvest,
    required this.progress,
    required this.icon,
  });

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      id: json['id'],
      name: json['name'] ?? '',
      crop: json['crop'] ?? '',
      phase: json['phase'] ?? '',
      area: json['area'] ?? '',
      soil: json['soil'] ?? '',
      expectedHarvest: DateTime.parse(json['expected_harvest']),
      progress: (json['progress'] ?? 0.0).toDouble(),
      icon: json['icon'] ?? 'grass',
    );
  }
}
