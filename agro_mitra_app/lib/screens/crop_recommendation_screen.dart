import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/recommendation_provider.dart';
import '../core/models/recommendation_model.dart';
import '../theme/app_colors.dart';

class CropRecommendationScreen extends StatefulWidget {
  const CropRecommendationScreen({super.key});

  @override
  State<CropRecommendationScreen> createState() => _CropRecommendationScreenState();
}

class _CropRecommendationScreenState extends State<CropRecommendationScreen> {
  final _phController = TextEditingController();
  final _moistureController = TextEditingController();
  String _selectedSoil = 'Loamy';

  @override
  void dispose() {
    _phController.dispose();
    _moistureController.dispose();
    super.dispose();
  }

  void _getRecommendations() {
    final ph = double.tryParse(_phController.text) ?? 6.5;
    final moisture = int.tryParse(_moistureController.text) ?? 40;

    context.read<RecommendationProvider>().fetchRecommendations(
      texture: _selectedSoil,
      ph: ph,
      moisture: moisture,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecommendationProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
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
              'Crop Recommendations',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                _buildInputSection(context, provider),
                if (provider.status == RecommendationStatus.loading)
                  const Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (provider.status == RecommendationStatus.error)
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Center(child: Text(provider.errorMessage ?? 'Failed to load recommendations')),
                  ),
                if (provider.status == RecommendationStatus.loaded) ...[
                  const SizedBox(height: 32),
                  _buildResultsSection(context, provider.data!),
                ],
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection(BuildContext context, RecommendationProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Soil Parameters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _buildSoilDropdown(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildInputField('pH Level', _phController, TextInputType.number)),
              const SizedBox(width: 16),
              Expanded(child: _buildInputField('Moisture %', _moistureController, TextInputType.number)),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: provider.status == RecommendationStatus.loading ? null : _getRecommendations,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Get AI Recommendations'),
          ),
        ],
      ),
    );
  }

  Widget _buildSoilDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Soil Texture', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedSoil,
              isExpanded: true,
              items: ['Loamy', 'Clayey', 'Sandy', 'Silty'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => _selectedSoil = val!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, TextInputType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
          child: TextField(controller: controller, keyboardType: type, style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildResultsSection(BuildContext context, CropRecommendationResponse data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('AI Top Picks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...data.recommendations.map((r) => _buildRecommendationCard(context, r)),
        const SizedBox(height: 32),
        _buildInsightCard('Climate Outlook', data.climateOutlook, Icons.wb_sunny_outlined, AppColors.tertiary),
        const SizedBox(height: 16),
        _buildInsightCard('Soil Health', data.soilHealthSummary.join('. '), Icons.health_and_safety_outlined, AppColors.secondary),
      ],
    );
  }

  Widget _buildRecommendationCard(BuildContext context, CropRecommendation r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2))),
      child: Column(
        children: [
          Row(
            children: [
              Container(width: 60, height: 60, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.grass, color: AppColors.primary)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('${r.matchPercentage}% Match', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
              _buildRiskBadge(r.riskLevel),
            ],
          ),
          const SizedBox(height: 16),
          Text(r.description, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSmallMetric('Expected Yield', r.expectedYield),
              _buildSmallMetric('Est. Profit', r.profitEstimate),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskBadge(String level) {
    Color color = level == 'Low' ? AppColors.primary : AppColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Text('$level Risk', style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSmallMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildInsightCard(String title, String content, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(24), border: Border.all(color: color.withValues(alpha: 0.1))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
                const SizedBox(height: 4),
                Text(content, style: const TextStyle(fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
