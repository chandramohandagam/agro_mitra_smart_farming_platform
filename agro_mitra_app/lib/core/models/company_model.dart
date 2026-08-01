class CompanyDashboardSummary {
  final int totalDealers;
  final int totalProducts;
  final double activeMarketShare;
  final List<RegionPerformance> regionalPerformance;
  final List<CompanyCampaign> activeCampaigns;

  CompanyDashboardSummary({
    required this.totalDealers,
    required this.totalProducts,
    required this.activeMarketShare,
    required this.regionalPerformance,
    required this.activeCampaigns,
  });

  factory CompanyDashboardSummary.fromJson(Map<String, dynamic> json) {
    return CompanyDashboardSummary(
      totalDealers: json['total_dealers'] ?? 0,
      totalProducts: json['total_products'] ?? 0,
      activeMarketShare: (json['active_market_share'] ?? 0.0).toDouble(),
      regionalPerformance: (json['regional_performance'] as List? ?? []).map((e) => RegionPerformance.fromJson(e)).toList(),
      activeCampaigns: (json['active_campaigns'] as List? ?? []).map((e) => CompanyCampaign.fromJson(e)).toList(),
    );
  }
}

class RegionPerformance {
  final String region;
  final double sales;
  final double growth;

  RegionPerformance({required this.region, required this.sales, required this.growth});

  factory RegionPerformance.fromJson(Map<String, dynamic> json) {
    return RegionPerformance(
      region: json['region'] ?? '',
      sales: (json['sales'] ?? 0.0).toDouble(),
      growth: (json['growth'] ?? 0.0).toDouble(),
    );
  }
}

class CompanyCampaign {
  final String title;
  final int reach;
  final double roi;

  CompanyCampaign({required this.title, required this.reach, required this.roi});

  factory CompanyCampaign.fromJson(Map<String, dynamic> json) {
    return CompanyCampaign(
      title: json['title'] ?? '',
      reach: json['reach'] ?? 0,
      roi: (json['roi'] ?? 0.0).toDouble(),
    );
  }
}
