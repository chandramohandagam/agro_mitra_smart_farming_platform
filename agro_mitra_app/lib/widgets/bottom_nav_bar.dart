import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Floating glassmorphic bottom navigation bar
/// Matches the "suspended" pill-shape design from the mockups
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 32,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9999),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isActive: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                _NavItem(
                  icon: Icons.eco_rounded,
                  label: 'Farm',
                  isActive: currentIndex == 1,
                  onTap: () => onTap(1),
                ),
                _NavItem(
                  icon: Icons.psychology_rounded,
                  label: 'AI',
                  isActive: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
                _NavItem(
                  icon: Icons.groups_rounded,
                  label: 'Feed',
                  isActive: currentIndex == 3,
                  onTap: () => onTap(3),
                ),
                _NavItem(
                  icon: Icons.storefront_rounded,
                  label: 'Market',
                  isActive: currentIndex == 4,
                  onTap: () => onTap(4),
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  isActive: currentIndex == 5,
                  onTap: () => onTap(5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive
                  ? AppColors.onPrimaryContainer
                  : AppColors.onSurfaceVariant,
            ),
            if (isActive)
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isActive
                      ? AppColors.onPrimaryContainer
                      : AppColors.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
