import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/providers/farm_provider.dart';
import '../core/models/farm_model.dart';
import '../theme/app_colors.dart';

class MyFarmScreen extends StatefulWidget {
  const MyFarmScreen({super.key});

  @override
  State<MyFarmScreen> createState() => _MyFarmScreenState();
}

class _MyFarmScreenState extends State<MyFarmScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FarmProvider>().fetchFarms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FarmProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () => provider.fetchFarms(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.surfaceBright.withValues(alpha: 0.9),
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'My Fields',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline, color: AppColors.primary)),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: _buildBody(context, provider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, FarmProvider provider) {
    if (provider.status == FarmStatus.loading) {
      return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
    }

    if (provider.status == FarmStatus.error) {
      return SliverFillRemaining(child: Center(child: Text(provider.errorMessage ?? 'Error')));
    }

    if (provider.status == FarmStatus.empty) {
      return const SliverFillRemaining(child: Center(child: Text('No farms registered yet.')));
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildFarmCard(context, provider.farms[index]),
        childCount: provider.farms.length,
      ),
    );
  }

  Widget _buildFarmCard(BuildContext context, Farm farm) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(16)), child: Icon(_getIconData(farm.icon), color: AppColors.primary)),
                        const SizedBox(width: 16),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(farm.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text('${farm.area} • ${farm.soil} Soil', style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12))]),
                      ],
                    ),
                    const Icon(Icons.more_vert, color: AppColors.outline),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFarmMetric('Current Crop', farm.crop, Icons.grass),
                    _buildFarmMetric('Growth Phase', farm.phase, Icons.trending_up),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Growth Progress', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('${(farm.progress * 100).toInt()}%', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: farm.progress, backgroundColor: AppColors.surfaceContainerHigh, color: AppColors.primary, minHeight: 8)),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      const Icon(Icons.event, size: 16, color: AppColors.onSurfaceVariant),
                      const SizedBox(width: 8),
                      const Text('Expected Harvest:', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                      const Spacer(),
                      Text(DateFormat('MMM dd, yyyy').format(farm.expectedHarvest), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.05), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('View Detailed Analytics', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmMetric(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10)), Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))]),
      ],
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'grass': return Icons.grass;
      case 'local_florist': return Icons.local_florist;
      default: return Icons.landscape;
    }
  }
}
