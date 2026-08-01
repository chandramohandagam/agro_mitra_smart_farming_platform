import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/scheme_provider.dart';
import '../core/models/scheme_model.dart';
import '../theme/app_colors.dart';

class GovernmentSchemesScreen extends StatefulWidget {
  const GovernmentSchemesScreen({super.key});

  @override
  State<GovernmentSchemesScreen> createState() => _GovernmentSchemesScreenState();
}

class _GovernmentSchemesScreenState extends State<GovernmentSchemesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SchemeProvider>().fetchSchemesAndApplications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SchemeProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () => provider.fetchSchemesAndApplications(),
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
                'Government Schemes',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined, color: AppColors.primary),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: _buildBody(context, provider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SchemeProvider provider) {
    if (provider.status == SchemeStatus.loading) {
      return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
    }

    if (provider.status == SchemeStatus.error) {
      return SliverFillRemaining(child: Center(child: Text(provider.errorMessage ?? 'Error loading schemes')));
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        const SizedBox(height: 16),
        _buildHeroBanner(context),
        const SizedBox(height: 24),
        _buildApplicationStatus(context, provider.applications),
        const SizedBox(height: 32),
        _buildAvailableSchemes(context, provider.schemes),
        const SizedBox(height: 24),
        _buildAIHelpBanner(context),
        const SizedBox(height: 120),
      ]),
    );
  }

  Widget _buildApplicationStatus(BuildContext context, List<SchemeApplication> applications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('My Applications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text('History')),
          ],
        ),
        const SizedBox(height: 12),
        if (applications.isEmpty)
          const Text('No active applications found.', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12))
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: applications.map((app) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildStatusCard(app.status, app.schemeTitle, _getStatusColor(app.status), _getStatusIcon(app.status)),
              )).toList(),
            ),
          ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'Approved') return AppColors.primary;
    if (status == 'Pending') return AppColors.tertiary;
    return AppColors.secondary;
  }

  IconData _getStatusIcon(String status) {
    if (status == 'Approved') return Icons.check_circle;
    if (status == 'Pending') return Icons.pending;
    return Icons.verified;
  }

  Widget _buildAvailableSchemes(BuildContext context, List<GovScheme> schemes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Available Schemes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        if (schemes.isEmpty)
          const Center(child: Text('No available schemes at the moment.'))
        else
          ...schemes.map((scheme) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildSchemeCard(
              context,
              scheme.title,
              scheme.description,
              _getSchemeIcon(scheme.icon),
              AppColors.primary,
              scheme.tags,
              scheme.status,
            ),
          )),
      ],
    );
  }

  IconData _getSchemeIcon(String name) {
    if (name == 'payments') return Icons.payments;
    if (name == 'science') return Icons.science;
    if (name == 'wb_sunny') return Icons.wb_sunny;
    return Icons.account_balance;
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=1000&auto=format&fit=crop'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            colors: [AppColors.primary.withValues(alpha: 0.8), Colors.transparent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Government Schemes', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Access exclusive financial aids and technical support for your farm.', style: TextStyle(color: Colors.white70, fontSize: 14), maxLines: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String status, String title, Color color, IconData icon) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(status, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchemeCard(BuildContext context, String title, String desc, IconData icon, Color color, List<String> tags, String status) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                child: Icon(icon, color: color, size: 28),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(9999)),
                child: Text(status.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onSecondaryContainer)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13, height: 1.5)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(8)),
              child: Text(t, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            )).toList(),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Apply Now'),
                SizedBox(width: 8),
                Icon(Icons.open_in_new, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIHelpBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.primaryContainer.withValues(alpha: 0.2), style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          const Text('Not sure where to start?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(height: 8),
          const Text(
            'Our AI assistant can analyze your farm profile and suggest the most beneficial schemes for you.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.psychology),
            label: const Text('Start AI Eligibility Check'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
