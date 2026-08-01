import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Splash Screen with animated logo, shimmer loading bar, and "Get Started" button
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late AnimationController _shimmerController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Atmospheric dot pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: CustomPaint(
                painter: _DotPatternPainter(),
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  // Center content
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo with pulse animation
                        ScaleTransition(
                          scale: _pulseAnimation,
                          child: Container(
                            width: 128,
                            height: 128,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(24),
                            child: Icon(
                              Icons.eco_rounded,
                              size: 64,
                              color: AppColors.primaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Identity
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              Text(
                                'Agro Mitra',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: AppColors.primary,
                                      letterSpacing: -0.5,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Your AI Companion for Smart Farming',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: AppColors.onSurfaceVariant
                                          .withValues(alpha: 0.8),
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bottom section
                  Column(
                    children: [
                      // Shimmer bar
                      SizedBox(
                        width: 240,
                        child: Column(
                          children: [
                            AnimatedBuilder(
                              animation: _shimmerAnimation,
                              builder: (context, child) {
                                return Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: FractionallySizedBox(
                                      alignment: Alignment(
                                          _shimmerAnimation.value, 0),
                                      widthFactor: 0.5,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              AppColors.primary
                                                  .withValues(alpha: 0.3),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'OPTIMIZING FIELD DATA',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: AppColors.onSurfaceVariant
                                        .withValues(alpha: 0.6),
                                    letterSpacing: 2,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Get Started button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/language');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            elevation: 8,
                            shadowColor:
                                AppColors.primary.withValues(alpha: 0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            minimumSize: const Size(double.infinity, 56),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Get Started',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(color: AppColors.onPrimary),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Version footer
                  Text(
                    'v2.4.0 • Future of Agriculture',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color:
                              AppColors.outline.withValues(alpha: 0.4),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.surfaceTint
      ..style = PaintingStyle.fill;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
