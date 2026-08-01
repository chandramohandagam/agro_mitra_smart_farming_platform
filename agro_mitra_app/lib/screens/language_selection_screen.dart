import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  int? _selectedIndex;
  String _searchQuery = '';

  final List<_LanguageItem> _languages = [
    _LanguageItem('English', 'Default Language', 'A', AppColors.primary),
    _LanguageItem('हिन्दी', 'Hindi', 'हिं', AppColors.secondary),
    _LanguageItem('ਪੰਜਾਬੀ', 'Punjabi', 'ਪੰ', AppColors.tertiary),
    _LanguageItem('मराठी', 'Marathi', 'म', AppColors.primaryFixedDim),
    _LanguageItem('తెలుగు', 'Telugu', 'తె', AppColors.secondaryFixedDim),
    _LanguageItem('தமிழ்', 'Tamil', 'த', AppColors.primary),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _languages.where((lang) {
      final query = _searchQuery.toLowerCase();
      return lang.name.toLowerCase().contains(query) ||
          lang.subtitle.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background blurs
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 384,
              height: 384,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.1),
              ),
            ),
          ),
          Column(
            children: [
              // App Bar
              SafeArea(
                bottom: false,
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceBright.withValues(alpha: 0.7),
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back,
                            color: AppColors.primary),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Language',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Choose your language',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select the language you are most comfortable with to continue using Agro Mitra.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 24),
                      // Search
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.outlineVariant,
                              width: 2,
                            ),
                          ),
                        ),
                        child: TextField(
                          onChanged: (v) => setState(() => _searchQuery = v),
                          decoration: InputDecoration(
                            hintText: 'Search languages...',
                            prefixIcon: const Icon(Icons.search,
                                color: AppColors.onSurfaceVariant),
                            border: InputBorder.none,
                            filled: false,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Language list
                      ...List.generate(filtered.length, (index) {
                        final lang = filtered[index];
                        final originalIndex = _languages.indexOf(lang);
                        final isSelected = _selectedIndex == originalIndex;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildLanguageCard(
                              lang, isSelected, originalIndex),
                        );
                      }),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Bottom button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withValues(alpha: 0),
                    AppColors.background,
                    AppColors.background,
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
                child: ElevatedButton(
                  onPressed: _selectedIndex != null
                      ? () {
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 64),
                    disabledBackgroundColor:
                        AppColors.primary.withValues(alpha: 0.3),
                    disabledForegroundColor:
                        AppColors.onPrimary.withValues(alpha: 0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Save & Continue',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: _selectedIndex != null
                                  ? AppColors.onPrimary
                                  : AppColors.onPrimary.withValues(alpha: 0.5),
                            ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(
      _LanguageItem lang, bool isSelected, int index) {
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer
              : Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : lang.color.withValues(alpha: 0.1),
              ),
              alignment: Alignment.center,
              child: Text(
                lang.symbol,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isSelected ? AppColors.onPrimaryContainer : lang.color,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: isSelected
                              ? AppColors.onPrimaryContainer
                              : AppColors.onSurface,
                        ),
                  ),
                  Text(
                    lang.subtitle,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isSelected
                              ? AppColors.onPrimaryContainer
                                  .withValues(alpha: 0.8)
                              : AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            // Radio indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.onPrimaryContainer
                      : AppColors.outline,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageItem {
  final String name;
  final String subtitle;
  final String symbol;
  final Color color;
  _LanguageItem(this.name, this.subtitle, this.symbol, this.color);
}
