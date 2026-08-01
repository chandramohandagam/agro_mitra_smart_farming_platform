import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/dealer_provider.dart';
import '../core/models/dealer_model.dart';
import '../theme/app_colors.dart';

class DealerDashboardScreen extends StatefulWidget {
  const DealerDashboardScreen({super.key});

  @override
  State<DealerDashboardScreen> createState() => _DealerDashboardScreenState();
}

class _DealerDashboardScreenState extends State<DealerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DealerProvider>().fetchDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DealerProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dealer Dashboard'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
          const CircleAvatar(radius: 16, backgroundColor: AppColors.primaryContainer),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchDashboard(),
        child: _buildBody(context, provider),
      ),
    );
  }

  Widget _buildBody(BuildContext context, DealerProvider provider) {
    if (provider.status == DealerStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.status == DealerStatus.error) {
      return Center(child: Text(provider.errorMessage ?? 'Error loading dashboard'));
    }

    final summary = provider.summary!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsGrid(summary),
          const SizedBox(height: 24),
          _buildInventorySection(summary.lowStockItems),
          const SizedBox(height: 24),
          _buildOrdersSection(summary.recentOrders),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(DealerDashboardSummary summary) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Total Revenue', '₹${summary.totalRevenue.toStringAsFixed(0)}', Icons.payments, AppColors.primary),
        _buildStatCard('Pending Orders', summary.pendingOrders.toString(), Icons.shopping_cart, AppColors.tertiary),
        _buildStatCard('Total Orders', summary.totalOrders.toString(), Icons.assignment, AppColors.secondary),
        _buildStatCard('Low Stock', summary.lowStockItems.length.toString(), Icons.inventory_2, AppColors.error),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
              Text(label, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventorySection(List<DealerInventoryItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Critical Inventory', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2))),
          child: Column(
            children: items.map((item) => ListTile(
              title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Stock: ${item.currentStock} ${item.unit}'),
              trailing: const Text('REORDER', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 12)),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersSection(List<DealerOrder> orders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...orders.map((order) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.1))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('₹${order.amount}', style: const TextStyle(color: AppColors.primary, fontSize: 12)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(9999)),
                child: Text(order.status.toUpperCase(), style: const TextStyle(color: AppColors.primary, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }
}
