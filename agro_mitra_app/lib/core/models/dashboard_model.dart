class DashboardSummary {
  final String greeting;
  final double farmHealth;
  final UpcomingTask? upcomingTask;
  final List<ActiveCrop> activeCrops;

  DashboardSummary({
    required this.greeting,
    required this.farmHealth,
    this.upcomingTask,
    required this.activeCrops,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      greeting: json['greeting'] ?? 'Hello!',
      farmHealth: (json['farm_health_percentage'] ?? 0.0).toDouble(),
      upcomingTask: json['upcoming_task'] != null ? UpcomingTask.fromJson(json['upcoming_task']) : null,
      activeCrops: (json['active_crops'] as List? ?? []).map((e) => ActiveCrop.fromJson(e)).toList(),
    );
  }
}

class UpcomingTask {
  final String title;
  final DateTime startTime;

  UpcomingTask({required this.title, required this.startTime});

  factory UpcomingTask.fromJson(Map<String, dynamic> json) {
    return UpcomingTask(
      title: json['title'] ?? '',
      startTime: DateTime.parse(json['start_time']),
    );
  }
}

class ActiveCrop {
  final String id;
  final String name;
  final String phase;
  final String icon;

  ActiveCrop({required this.id, required this.name, required this.phase, required this.icon});

  factory ActiveCrop.fromJson(Map<String, dynamic> json) {
    return ActiveCrop(
      id: json['id'],
      name: json['name'] ?? '',
      phase: json['phase'] ?? '',
      icon: json['icon'] ?? 'grass',
    );
  }
}
