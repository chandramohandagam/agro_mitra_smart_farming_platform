import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class FertilizerRecommendationScreen extends StatelessWidget {
  const FertilizerRecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Top App Bar
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.surfaceBright.withValues(alpha: 0.9),
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Fertilizer Recommendation',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share, color: AppColors.onSurfaceVariant),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=5'),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                _buildHeroCard(context),
                const SizedBox(height: 24),
                _buildCostCard(context),
                const SizedBox(height: 32),
                _buildNutrientAnalysis(context),
                const SizedBox(height: 32),
                _buildChemicalSolution(context),
                const SizedBox(height: 24),
                _buildOrganicAlternatives(context),
                const SizedBox(height: 24),
                _buildLocalDealerCTA(context),
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primaryContainer.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(9999)),
                child: const Text('Plot #42: Paddy Field', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              const Text('Analyzed 2 hours ago', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Soil Nutrient Deficiency Detected', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Your soil shows a critical shortage of Nitrogen and Phosphorous. Immediate application is recommended.',
            style: TextStyle(color: AppColors.onSurfaceVariant, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildCostCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ESTIMATED TOTAL COST', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
                  SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('₹12,450', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      SizedBox(width: 4),
                      Text('/ 2 Acres', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.shopping_bag, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
            child: const Text('Purchase Recommendation'),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientAnalysis(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Nutrient Analysis (N-P-K)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildNutrientBar('Nitrogen (N)', 'Low (28%)', 0.28, AppColors.error),
        const SizedBox(height: 16),
        _buildNutrientBar('Phosphorus (P)', 'Moderate (45%)', 0.45, AppColors.tertiary),
        const SizedBox(height: 16),
        _buildNutrientBar('Potassium (K)', 'Optimum (82%)', 0.82, AppColors.primary),
      ],
    );
  }

  Widget _buildNutrientBar(String label, String status, double value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: value, color: color, backgroundColor: AppColors.surfaceContainerHigh, minHeight: 8, borderRadius: BorderRadius.circular(4)),
        ],
      ),
    );
  }

  Widget _buildChemicalSolution(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.precision_manufacturing, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Chemical Solution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              _buildProductItem('Urea (46% Nitrogen)', '₹560 / 50kg', 'Primary source of fast-acting nitrogen.'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('DOSING INSTRUCTIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const SizedBox(height: 8),
                    _buildBulletPoint('Apply 120kg per acre in three split doses.'),
                    _buildBulletPoint('Apply during morning hours with soil moisture.'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildProductItem('DAP (18:46:0)', '₹1,350 / 50kg', 'High phosphorus content for root health.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem(String title, String price, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(12))),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(price, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
              Text(desc, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildOrganicAlternatives(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.eco, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Organic Alternatives', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              _buildProductItem('Premium Vermicompost', '₹300 / 40kg', 'Improves soil structure and long-term fertility.'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.tertiary.withValues(alpha: 0.05), border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.2)), borderRadius: BorderRadius.circular(16)),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: AppColors.tertiary, size: 20),
                    SizedBox(width: 12),
                    Expanded(child: Text('AI Tip: Mixing 20% organic manure can improve N-uptake by 15%.', style: TextStyle(fontSize: 12))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocalDealerCTA(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3))),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle), child: const Icon(Icons.storefront, color: AppColors.primary)),
          const SizedBox(width: 16),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Check Local Availability', style: TextStyle(fontWeight: FontWeight.bold)), Text('Find 12 certified dealers near you.', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant))])),
          IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward, color: AppColors.primary)),
        ],
      ),
    );
  }
}
