import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/auth_provider.dart';
import '../core/providers/dashboard_provider.dart';
import '../core/providers/market_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchDashboard();
      context.read<MarketProvider>().fetchPrices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final dashboardProvider = context.watch<DashboardProvider>();
    final marketProvider = context.watch<MarketProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<DashboardProvider>().fetchDashboard();
          await context.read<MarketProvider>().fetchPrices();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: AppColors.surfaceBright.withValues(alpha: 0.9),
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  const CircleAvatar(radius: 20, backgroundColor: AppColors.primaryContainer, child: Icon(Icons.person, color: AppColors.primary)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Agro Mitra', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      Text(authProvider.userProfile?.fullName ?? 'Farmer', style: Theme.of(context).textTheme.labelSmall),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(onPressed: () => Navigator.pushNamed(context, '/notifications'), icon: const Icon(Icons.notifications_outlined, color: AppColors.onSurfaceVariant)),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildWeatherQuickView(context),
                  const SizedBox(height: 24),
                  _buildMandiPrices(context, marketProvider),
                  const SizedBox(height: 24),
                  _buildQuickActions(context),
                  const SizedBox(height: 24),
                  _buildFarmHealth(context, dashboardProvider),
                  const SizedBox(height: 120),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherQuickView(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/weather'),
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('TODAY\'S WEATHER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 8),
                Text('28°C', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                const Text('Partly Cloudy', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
            const Icon(Icons.wb_cloudy, size: 48, color: AppColors.gold),
          ],
        ),
      ),
    );
  }

  Widget _buildMandiPrices(BuildContext context, MarketProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Live Mandi Prices', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text('View All')),
          ],
        ),
        const SizedBox(height: 12),
        if (provider.status == MarketStatus.loading)
          const Center(child: CircularProgressIndicator())
        else if (provider.status == MarketStatus.error)
          Center(child: Text(provider.errorMessage ?? 'Error'))
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: provider.prices.map((p) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildPriceCard(p.commodity, '₹${p.price.toInt()}', '+${p.change}%'),
              )).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildPriceCard(String crop, String price, String change) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(crop, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(price, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 4),
          Text(change, style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'icon': Icons.camera_alt_outlined, 'label': 'Health Check', 'route': '/disease_detection'},
      {'icon': Icons.grass_outlined, 'label': 'Crop Advice', 'route': '/crop_recommendation'},
      {'icon': Icons.local_shipping_outlined, 'label': 'Transport', 'route': '/transport'},
      {'icon': Icons.account_balance_outlined, 'label': 'Schemes', 'route': '/government_schemes'},
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: actions.map((a) => _buildActionButton(context, a['icon'] as IconData, a['label'] as String, a['route'] as String)).toList(),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primaryContainer.withValues(alpha: 0.1), shape: BoxShape.circle), child: Icon(icon, color: AppColors.primary)),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 1),
        ],
      ),
    );
  }

  Widget _buildFarmHealth(BuildContext context, DashboardProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(32)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Farm Health', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => Navigator.pushNamed(context, '/my_farms'), icon: const Icon(Icons.arrow_forward, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 16),
          if (provider.status == DashboardStatus.loading)
            const Center(child: CircularProgressIndicator(color: Colors.white))
          else if (provider.status == DashboardStatus.error)
            Text(provider.errorMessage ?? 'Error', style: const TextStyle(color: Colors.white70))
          else ...[
            Text('${(provider.summary!.farmHealth * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: provider.summary!.farmHealth, backgroundColor: Colors.white24, color: AppColors.gold, minHeight: 8)),
            const SizedBox(height: 16),
            const Text('Everything looks great! Soil moisture is optimal across all sectors.', style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
          ],
        ],
      ),
    );
  }
}
