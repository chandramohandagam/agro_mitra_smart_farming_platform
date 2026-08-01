import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/marketplace_provider.dart';
import '../core/models/marketplace_model.dart';
import '../theme/app_colors.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketplaceProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MarketplaceProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () => provider.fetchProducts(category: provider.selectedCategory),
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
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryFixed, width: 2),
                      color: AppColors.primaryContainer,
                    ),
                    child: const Icon(Icons.person, color: AppColors.onPrimaryContainer, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Agro Mitra',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined, color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 140),
              sliver: _buildBody(context, provider),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton.large(
          onPressed: () {},
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.shopping_cart, size: 32),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MarketplaceProvider provider) {
    if (provider.status == MarketplaceStatus.loading && provider.products.isEmpty) {
      return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
    }

    if (provider.status == MarketplaceStatus.error) {
      return SliverFillRemaining(child: Center(child: Text(provider.errorMessage ?? 'Error loading products')));
    }

    final trending = provider.products.where((p) => p.isTrending).toList();
    final regular = provider.products.where((p) => !p.isTrending).toList();

    return SliverList(
      delegate: SliverChildListDelegate([
        const SizedBox(height: 16),
        Text('Marketplace', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text('Find premium supplies for your modern farm.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 24),
        _buildSearchBar(context),
        const SizedBox(height: 24),
        _buildCategories(context, provider),
        const SizedBox(height: 32),
        if (trending.isNotEmpty) ...[
          _buildTrendingSection(context, trending.first),
          const SizedBox(height: 32),
        ],
        _buildFeaturedProducts(context, regular),
        const SizedBox(height: 32),
        _buildLocalLogistics(context),
      ]),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for seeds, fertilizers, or tools...',
          prefixIcon: const Icon(Icons.search, color: AppColors.outline),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.onPrimary, minimumSize: const Size(80, 40), padding: const EdgeInsets.symmetric(horizontal: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Filter'),
            ),
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context, MarketplaceProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: provider.categories.map((cat) {
          final isActive = provider.selectedCategory == cat.label;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              selected: isActive,
              onSelected: (val) => provider.fetchProducts(category: val ? cat.label : null),
              label: Text(cat.label),
              avatar: Icon(_getIconData(cat.icon), size: 20, color: isActive ? AppColors.onPrimary : AppColors.onSurfaceVariant),
              backgroundColor: Colors.white,
              selectedColor: AppColors.primary,
              checkmarkColor: AppColors.onPrimary,
              labelStyle: TextStyle(color: isActive ? AppColors.onPrimary : AppColors.onSurfaceVariant, fontWeight: FontWeight.w500),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999), side: BorderSide(color: isActive ? Colors.transparent : AppColors.outlineVariant.withValues(alpha: 0.3))),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'science': return Icons.science;
      case 'construction': return Icons.construction;
      case 'agriculture': return Icons.agriculture;
      default: return Icons.eco;
    }
  }

  Widget _buildTrendingSection(BuildContext context, MarketplaceProduct product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Trending in your region', style: Theme.of(context).textTheme.titleLarge),
            TextButton.icon(onPressed: () {}, icon: const Icon(Icons.arrow_forward, size: 16), label: const Text('See All'), style: TextButton.styleFrom(foregroundColor: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            image: DecorationImage(image: NetworkImage(product.imageUrl ?? 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=1000&auto=format&fit=crop'), fit: BoxFit.cover),
          ),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)])),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: AppColors.tertiaryContainer, borderRadius: BorderRadius.circular(9999)), child: const Text('TOP PICK', style: TextStyle(color: AppColors.onTertiaryContainer, fontSize: 10, fontWeight: FontWeight.bold))),
                const SizedBox(height: 8),
                Text(product.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.price, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle), child: const Icon(Icons.add_shopping_cart, color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedProducts(BuildContext context, List<MarketplaceProduct> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Featured Products', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        if (products.isEmpty)
          const Center(child: Text('No featured products available.'))
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 16, mainAxisSpacing: 16),
            itemCount: products.length,
            itemBuilder: (context, index) => _buildProductCard(context, products[index]),
          ),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, MarketplaceProduct product) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10)]),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Container(decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(16)), child: Stack(children: [Center(child: product.imageUrl != null ? Image.network(product.imageUrl!) : const Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.outlineVariant)), Positioned(top: 8, right: 8, child: Icon(Icons.favorite_border, size: 20, color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)))]))),
          const SizedBox(height: 12),
          Text(product.category.toUpperCase(), style: const TextStyle(fontSize: 10, color: AppColors.outline, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(product.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(children: [const Icon(Icons.star, size: 14, color: AppColors.gold), const SizedBox(width: 4), Text(product.rating.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(product.price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)), Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.surfaceContainerHighest, shape: BoxShape.circle), child: const Icon(Icons.add, size: 20, color: AppColors.primary))]),
        ],
      ),
    );
  }

  Widget _buildLocalLogistics(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Local Logistics', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text('Connect with verified agricultural suppliers in your area.', style: TextStyle(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 24),
          _buildLogisticsItem(Icons.local_shipping, 'AgriExpress Fleet', 'Active now • 2km away'),
          const SizedBox(height: 16),
          _buildLogisticsItem(Icons.verified, 'Community Seed Bank', 'Verified Partner'),
        ],
      ),
    );
  }

  Widget _buildLogisticsItem(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.1))),
      child: Row(children: [Icon(icon, color: AppColors.primary), const SizedBox(width: 16), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.outline))])]),
    );
  }
}
