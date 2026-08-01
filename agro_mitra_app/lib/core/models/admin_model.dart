class AdminDashboardSummary {
  final int totalUsers;
  final int activeNow;
  final int flaggedContent;
  final double systemUptime;
  final List<SystemLog> systemLogs;

  AdminDashboardSummary({
    required this.totalUsers,
    required this.activeNow,
    required this.flaggedContent,
    required this.systemUptime,
    required this.systemLogs,
  });

  factory AdminDashboardSummary.fromJson(Map<String, dynamic> json) {
    return AdminDashboardSummary(
      totalUsers: json['total_users'] ?? 0,
      activeNow: json['active_now'] ?? 0,
      flaggedContent: json['flagged_content'] ?? 0,
      systemUptime: (json['system_uptime'] ?? 0.0).toDouble(),
      systemLogs: (json['system_logs'] as List? ?? []).map((e) => SystemLog.fromJson(e)).toList(),
    );
  }
}

class SystemLog {
  final String level; // INFO, WARN, ERROR
  final String message;
  final DateTime timestamp;

  SystemLog({required this.level, required this.message, required this.timestamp});

  factory SystemLog.fromJson(Map<String, dynamic> json) {
    return SystemLog(
      level: json['level'] ?? 'INFO',
      message: json['message'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
