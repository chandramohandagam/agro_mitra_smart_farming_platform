import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CommunityHubScreen extends StatelessWidget {
  const CommunityHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Top App Bar
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
                    image: const DecorationImage(
                      image: NetworkImage('https://i.pravatar.cc/100?img=5'),
                      fit: BoxFit.cover,
                    ),
                  ),
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
          // Search & Filter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSearchBar(context),
                  const SizedBox(height: 16),
                  _buildCategories(context),
                ],
              ),
            ),
          ),
          // Feed
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 140),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildPostCard(
                  context,
                  author: 'Dr. Rajesh Kumar',
                  role: 'Soil Scientist • 2h ago',
                  tag: 'Success Story',
                  content: 'Proud to share the results from the organic turmeric pilot in Satara. By switching to regenerative irrigation techniques, farmers saw a 30% increase in yield.',
                  imageUrl: 'https://images.unsplash.com/photo-1592982537447-6f2a6a0c7c18?q=80&w=1000&auto=format&fit=crop',
                  likes: '1.2k',
                  comments: '84',
                  isVerified: true,
                ),
                const SizedBox(height: 16),
                _buildPostCard(
                  context,
                  author: 'Amit Deshmukh',
                  role: 'Wheat Farmer • 5h ago',
                  tag: 'Discussion',
                  content: 'Dealing with yellow rust in wheat? I\'ve noticed some yellow patches on my lower leaves this morning. Temperatures are dropping in the north.',
                  likes: '342',
                  comments: '156',
                ),
                const SizedBox(height: 16),
                _buildVideoCard(
                  context,
                  author: 'AgriTech Collective',
                  role: 'Educational Channel • 1d ago',
                  title: 'How to use Drones for Fertilizer Sprays',
                  subtitle: 'Complete guide on navigating drone regulations and optimizing spray patterns.',
                  thumbnailUrl: 'https://images.unsplash.com/photo-1508197149814-0cc02e8b7f74?q=80&w=1000&auto=format&fit=crop',
                  duration: '12:45',
                ),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          icon: const Icon(Icons.psychology),
          label: const Text('Ask Expert'),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search discussions, experts...',
          prefixIcon: Icon(Icons.search, color: AppColors.outline),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    final categories = ['All Feed', 'Discussion', 'Videos', 'Success Stories'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isFirst = cat == 'All Feed';
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isFirst,
              onSelected: (val) {},
              label: Text(cat),
              backgroundColor: AppColors.surfaceContainerHighest,
              selectedColor: AppColors.primary,
              checkmarkColor: AppColors.onPrimary,
              labelStyle: TextStyle(
                color: isFirst ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999), side: BorderSide.none),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPostCard(
    BuildContext context, {
    required String author,
    required String role,
    required String tag,
    required String content,
    String? imageUrl,
    required String likes,
    required String comments,
    bool isVerified = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: AppColors.primaryFixed, radius: 24, child: const Icon(Icons.person, color: AppColors.onPrimaryFixed)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          if (isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified, size: 16, color: AppColors.primary),
                          ],
                        ],
                      ),
                      Text(role, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.tertiaryContainer.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(9999)),
                  child: Text(tag, style: const TextStyle(color: AppColors.tertiary, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                Text(content, style: const TextStyle(fontSize: 14, height: 1.5)),
                const SizedBox(height: 16),
              ],
            ),
          ),
          if (imageUrl != null)
            Image.network(imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildActionItem(Icons.favorite_border, likes),
                const SizedBox(width: 24),
                _buildActionItem(Icons.chat_bubble_outline, comments),
                const Spacer(),
                const Icon(Icons.share_outlined, color: AppColors.onSurfaceVariant),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(
    BuildContext context, {
    required String author,
    required String role,
    required String title,
    required String subtitle,
    required String thumbnailUrl,
    required String duration,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: AppColors.secondaryFixed, radius: 24, child: const Icon(Icons.school, color: AppColors.onSecondaryFixed)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(role, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Image.network(thumbnailUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), shape: BoxShape.circle),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(4)),
                  child: Text(duration, style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant)),
      ],
    );
  }
}
