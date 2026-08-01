import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final profile = authProvider.userProfile;

    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary, Color(0xFF1B5E20)], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
                  Positioned(top: -50, right: -50, child: Container(width: 200, height: 200, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.05)))),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        const CircleAvatar(radius: 50, backgroundColor: Colors.white, child: CircleAvatar(radius: 46, backgroundImage: NetworkImage('https://i.pravatar.cc/300?img=12'))),
                        const SizedBox(height: 16),
                        Text(profile.fullName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        Text(profile.role.name.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined, color: Colors.white)),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                _buildInfoSection(context, profile),
                const SizedBox(height: 24),
                _buildTagsSection(context, profile.tags),
                const SizedBox(height: 24),
                _buildAccountActions(context, authProvider),
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, dynamic profile) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildInfoRow(Icons.email_outlined, 'Email', profile.email),
          const Divider(height: 32),
          _buildInfoRow(Icons.phone_outlined, 'Phone', profile.phoneNumber ?? 'Not set'),
          const Divider(height: 32),
          _buildInfoRow(Icons.location_on_outlined, 'Location', profile.location ?? 'Amritsar, India'),
          const Divider(height: 32),
          _buildInfoRow(Icons.calendar_today_outlined, 'Member Since', 'Oct 2023'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primaryContainer.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 20, color: AppColors.primary)),
        const SizedBox(width: 16),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.bold)), Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))]),
      ],
    );
  }

  Widget _buildTagsSection(BuildContext context, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Expertise', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3))),
            child: Text(tag, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildAccountActions(BuildContext context, AuthProvider authProvider) {
    return Column(
      children: [
        _buildActionTile(Icons.settings_outlined, 'App Settings', () {}),
        const SizedBox(height: 12),
        _buildActionTile(Icons.help_outline, 'Help & Support', () {}),
        const SizedBox(height: 12),
        _buildActionTile(Icons.logout, 'Sign Out', () {
          authProvider.logout();
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }, isDestructive: true),
      ],
    );
  }

  Widget _buildActionTile(IconData icon, String label, VoidCallback onTap, {bool isDestructive = false}) {
    final color = isDestructive ? AppColors.error : AppColors.onSurface;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: isDestructive ? AppColors.error.withValues(alpha: 0.05) : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: isDestructive ? AppColors.error.withValues(alpha: 0.1) : AppColors.outlineVariant.withValues(alpha: 0.2))),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 14, color: color.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}
