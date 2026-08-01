import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../core/services/permission_service.dart';
import '../core/providers/disease_provider.dart';
import '../core/models/disease_model.dart';
import '../theme/app_colors.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({super.key});

  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _scanController;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermission();
    });
  }

  Future<void> _checkPermission() async {
    final granted = await PermissionService.instance.requestCamera(context);
    if (mounted) {
      setState(() {
        _hasPermission = granted;
      });
    }
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DiseaseProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: !_hasPermission
        ? _buildPermissionDeniedState()
        : CustomScrollView(
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
              'AI Health Check',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: () => provider.reset(),
                icon: const Icon(Icons.refresh, color: AppColors.primary),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.history, color: AppColors.primary),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                _buildCameraViewfinder(context, provider),
                if (provider.status == DiseaseStatus.loading)
                  const Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (provider.status == DiseaseStatus.error)
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Center(child: Text(provider.errorMessage ?? 'Detection failed')),
                  ),
                if (provider.status == DiseaseStatus.detected) ...[
                  const SizedBox(height: 32),
                  _buildDetectionResults(context, provider.result!),
                  const SizedBox(height: 24),
                  _buildContextAndMarket(context, provider.result!),
                  const SizedBox(height: 24),
                  _buildExpertConsultation(context),
                ],
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraViewfinder(BuildContext context, DiseaseProvider provider) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20)],
        image: provider.selectedImage != null
          ? DecorationImage(
              image: FileImage(File(provider.selectedImage!.path)),
              fit: BoxFit.cover,
            )
          : const DecorationImage(
              image: NetworkImage('https://images.unsplash.com/photo-1592982537447-6f2a6a0c7c18?q=80&w=1000&auto=format&fit=crop'),
              fit: BoxFit.cover,
              opacity: 0.5,
            ),
      ),
      child: Stack(
        children: [
          if (provider.status == DiseaseStatus.loading)
            AnimatedBuilder(
              animation: _scanController,
              builder: (context, child) {
                return Positioned(
                  top: 300 * 0.1 + (300 * 0.8 * _scanController.value),
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, AppColors.primaryFixed.withValues(alpha: 0.8), Colors.transparent],
                      ),
                      boxShadow: [BoxShadow(color: AppColors.primaryFixed.withValues(alpha: 0.5), blurRadius: 10)],
                    ),
                  ),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(9999)),
                      child: Row(
                        children: [
                          Icon(Icons.circle, color: provider.status == DiseaseStatus.loading ? AppColors.error : Colors.white, size: 8),
                          const SizedBox(width: 8),
                          Text(provider.status == DiseaseStatus.loading ? 'LIVE AI ANALYSIS' : 'READY TO SCAN', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const Icon(Icons.flash_on, color: Colors.white),
                  ],
                ),
                if (provider.selectedImage == null)
                Center(
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryFixed.withValues(alpha: 0.8), width: 2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => provider.pickAndDetect(ImageSource.gallery),
                      child: _buildCamIcon(Icons.image, 'GALLERY'),
                    ),
                    GestureDetector(
                      onTap: () => provider.pickAndDetect(ImageSource.camera),
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                        child: Center(child: Container(width: 48, height: 48, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))),
                      ),
                    ),
                    _buildCamIcon(Icons.info_outline, 'TIPS'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectionResults(BuildContext context, DiseaseDetectionResult result) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.error.withValues(alpha: 0.1), Colors.transparent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(9999)),
                      child: Text(result.severity, style: const TextStyle(color: AppColors.error, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    Text(result.diseaseName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(result.scientificName, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${result.confidence}%', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const Text('AI Confidence', style: TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(value: result.confidence / 100, backgroundColor: AppColors.surfaceContainer, color: AppColors.primary, minHeight: 6, borderRadius: BorderRadius.circular(3)),
                const SizedBox(height: 24),
                const Text('Immediate Treatment Steps', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...result.treatmentSteps.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildStep(e.key + 1, e.value),
                )).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextAndMarket(BuildContext context, DiseaseDetectionResult result) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('RISK CONTEXT', style: TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('${(result.humidityContext * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    const Icon(Icons.water_drop, color: Colors.white, size: 16),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('High humidity forecast will accelerate growth.', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('RECOMMENDED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    Icon(Icons.storefront, size: 16, color: AppColors.primary),
                  ],
                ),
                const SizedBox(height: 12),
                ...result.recommendations.take(2).map((p) => Column(
                  children: [
                    _buildProductSmall(p.name, p.price),
                    const Divider(height: 16),
                  ],
                )).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionDeniedState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.no_photography_outlined, size: 64, color: AppColors.outline),
            const SizedBox(height: 24),
            const Text(
              "Camera Access Required",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "The AI health check needs camera access to scan your crops for diseases and pests.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _checkPermission,
              child: const Text("Allow Camera Access"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCamIcon(IconData icon, String label) => Column(
    children: [
      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: Colors.white)),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
    ],
  );

  Widget _buildStep(int num, String text) => Row(children: [
    Container(width: 24, height: 24, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: Center(child: Text('$num', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)))),
    const SizedBox(width: 12),
    Expanded(child: Text(text, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13))),
  ]);

  Widget _buildProductSmall(String name, String price) => Row(children: [
    Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(8))),
    const SizedBox(width: 8),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis), Text(price, style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold))])),
  ]);

  Widget _buildExpertConsultation(BuildContext context) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(24)), child: Row(children: [const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Talk to an Expert', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text('14 Agronomists active in your district', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12))])), ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999))), child: const Text('Consult Now'))]));
}
