import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/providers/admin_provider.dart';
import '../core/models/admin_model.dart';
import '../theme/app_colors.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().fetchDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('System Admin'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.security_outlined)),
          const CircleAvatar(radius: 16, backgroundColor: AppColors.error),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchDashboard(),
        child: _buildBody(context, provider),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AdminProvider provider) {
    if (provider.status == AdminStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.status == AdminStatus.error) {
      return Center(child: Text(provider.errorMessage ?? 'Error loading admin panel'));
    }

    final summary = provider.summary!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHealthGrid(summary),
          const SizedBox(height: 32),
          _buildSystemLogs(summary.systemLogs),
          const SizedBox(height: 32),
          _buildFlaggedContentCTA(summary.flaggedContent),
        ],
      ),
    );
  }

  Widget _buildHealthGrid(AdminDashboardSummary summary) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildAdminStatCard('Total Users', summary.totalUsers.toString(), Icons.group_outlined, AppColors.primary),
        _buildAdminStatCard('Uptime', '${summary.systemUptime}%', Icons.timer_outlined, AppColors.secondary),
        _buildAdminStatCard('Active Now', summary.activeNow.toString(), Icons.bolt_outlined, AppColors.tertiary),
        _buildAdminStatCard('Flagged', summary.flaggedContent.toString(), Icons.flag_outlined, AppColors.error),
      ],
    );
  }

  Widget _buildAdminStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
              Text(label, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSystemLogs(List<SystemLog> logs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Real-time System Logs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: logs.map((log) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text('[${log.level}]', style: TextStyle(color: _getLogLevelColor(log.level), fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(log.message, style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontFamily: 'monospace'))),
                  Text(DateFormat('HH:mm').format(log.timestamp), style: const TextStyle(color: Colors.white54, fontSize: 9)),
                ],
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Color _getLogLevelColor(String level) {
    if (level == 'ERROR') return AppColors.error;
    if (level == 'WARN') return AppColors.tertiary;
    return AppColors.secondary;
  }

  Widget _buildFlaggedContentCTA(int count) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.error.withValues(alpha: 0.1))),
      child: Row(
        children: [
          const Icon(Icons.gavel_outlined, color: AppColors.error),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Content Moderation', style: TextStyle(fontWeight: FontWeight.bold)), Text('$count items awaiting review', style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12))])),
          ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Review')),
        ],
      ),
    );
  }
}
