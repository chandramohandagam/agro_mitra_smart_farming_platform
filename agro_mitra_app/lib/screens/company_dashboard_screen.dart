import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/company_provider.dart';
import '../core/models/company_model.dart';
import '../theme/app_colors.dart';

class CompanyDashboardScreen extends StatefulWidget {
  const CompanyDashboardScreen({super.key});

  @override
  State<CompanyDashboardScreen> createState() => _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState extends State<CompanyDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyProvider>().fetchDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CompanyProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Company Dashboard'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.analytics_outlined)),
          const CircleAvatar(radius: 16, backgroundColor: AppColors.secondary),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchDashboard(),
        child: _buildBody(context, provider),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CompanyProvider provider) {
    if (provider.status == CompanyStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.status == CompanyStatus.error) {
      return Center(child: Text(provider.errorMessage ?? 'Error loading dashboard'));
    }

    final summary = provider.summary!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryGrid(summary),
          const SizedBox(height: 32),
          _buildRegionalPerformance(summary.regionalPerformance),
          const SizedBox(height: 32),
          _buildActiveCampaigns(summary.activeCampaigns),
        ],
      ),
    );
  }

  Widget _buildSummaryGrid(CompanyDashboardSummary summary) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildSmallStatCard('Dealers', summary.totalDealers.toString(), Icons.people_outline, AppColors.primary),
        _buildSmallStatCard('Products', summary.totalProducts.toString(), Icons.inventory_2_outlined, AppColors.secondary),
        _buildSmallStatCard('Market %', '${summary.activeMarketShare}%', Icons.pie_chart_outline, AppColors.tertiary),
      ],
    );
  }

  Widget _buildSmallStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 8, color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildRegionalPerformance(List<RegionPerformance> regions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Regional Performance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2))),
          child: Column(
            children: regions.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(r.region, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Growth: +${r.growth}%', style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: r.sales / 1000000, backgroundColor: AppColors.surfaceContainerHigh, color: AppColors.primary, minHeight: 6, borderRadius: BorderRadius.circular(3)),
                ],
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveCampaigns(List<CompanyCampaign> campaigns) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Active Marketing ROI', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...campaigns.map((c) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.primary.withValues(alpha: 0.1))),
          child: Row(
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle), child: const Icon(Icons.campaign_outlined, color: AppColors.primary, size: 20)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Reach: ${c.reach} farmers', style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ),
              Text('${c.roi}x', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 18)),
            ],
          ),
        )).toList(),
      ],
    );
  }
}
