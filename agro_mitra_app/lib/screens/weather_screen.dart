import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/permission_service.dart';
import '../core/providers/weather_provider.dart';
import '../core/models/weather_model.dart';
import '../theme/app_colors.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndFetch();
  }

  Future<void> _checkPermissionAndFetch() async {
    final granted = await PermissionService.instance.requestLocation(context);
    if (mounted) {
      setState(() {
        _hasPermission = granted;
      });
      if (granted) {
        context.read<WeatherProvider>().fetchWeather();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: !_hasPermission
        ? _buildPermissionDeniedState()
        : _buildWeatherBody(weatherProvider),
    );
  }

  Widget _buildWeatherBody(WeatherProvider provider) {
    if (provider.status == WeatherStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.status == WeatherStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.errorMessage ?? 'Failed to load weather'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.fetchWeather(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final data = provider.weatherData!;

    return RefreshIndicator(
      onRefresh: () => provider.fetchWeather(),
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
              'Weather Insights',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share_outlined, color: AppColors.primary),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                _buildWeatherHero(context, data.current),
                const SizedBox(height: 32),
                _buildRainProbability(context, data.rainProbability),
                const SizedBox(height: 32),
                _buildMetricsGrid(context, data.current),
                const SizedBox(height: 32),
                _buildSevenDayForecast(context, data.forecast),
                const SizedBox(height: 32),
                _buildAgriAdvice(context, data.agriAdvice),
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDeniedState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off_outlined, size: 64, color: AppColors.outline),
            const SizedBox(height: 24),
            const Text(
              "Location Access Required",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "We need your location to provide accurate local weather forecasts and farming advice.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _checkPermissionAndFetch,
              child: const Text("Allow Location Access"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherHero(BuildContext context, CurrentWeather current) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF1B5E20)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('Amritsar, Punjab', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),
          Icon(_getConditionIcon(current.condition), color: AppColors.gold, size: 80),
          const SizedBox(height: 16),
          Text('${current.temp}°', style: const TextStyle(color: Colors.white, fontSize: 72, fontWeight: FontWeight.bold)),
          Text(current.condition.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 12),
          Text('H:${current.high}°  L:${current.low}°', style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  IconData _getConditionIcon(String condition) {
    final c = condition.toLowerCase();
    if (c.contains('sunny') || c.contains('clear')) return Icons.wb_sunny;
    if (c.contains('cloud')) return Icons.cloud;
    if (c.contains('rain')) return Icons.beach_access;
    return Icons.wb_cloudy;
  }

  Widget _buildRainProbability(BuildContext context, List<RainProb> probs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Rain Probability', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: probs.map((p) => Padding(
              padding: const EdgeInsets.only(right: 24),
              child: _buildBar(p.time, p.prob),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBar(String time, double prob) {
    return Column(
      children: [
        Text('${(prob * 100).toInt()}%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
        const SizedBox(height: 8),
        Container(
          width: 8,
          height: 80,
          decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(4)),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 8,
                height: 80 * prob,
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(time, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildMetricsGrid(BuildContext context, CurrentWeather current) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.6,
      children: [
        _buildMetricItem(Icons.water_drop_outlined, 'Humidity', '${current.humidity}%'),
        _buildMetricItem(Icons.wb_sunny_outlined, 'UV Index', current.uvIndex),
        _buildMetricItem(Icons.air, 'Wind Speed', current.windSpeed),
        _buildMetricItem(Icons.visibility_outlined, 'Visibility', '14 km'),
      ],
    );
  }

  Widget _buildMetricItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(children: [Icon(icon, size: 16, color: AppColors.primary), const SizedBox(width: 8), Text(label, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant))]),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSevenDayForecast(BuildContext context, List<ForecastDay> forecast) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('3-Day Forecast', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...forecast.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildForecastRow(f.day, f.icon == 'sunny' ? Icons.wb_sunny : Icons.cloud, f.tempRange, f.progress),
          )),
        ],
      ),
    );
  }

  Widget _buildForecastRow(String day, IconData icon, String temp, double progress) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(day, style: const TextStyle(fontWeight: FontWeight.w500))),
        Icon(icon, size: 20, color: AppColors.gold),
        const SizedBox(width: 16),
        Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: progress, backgroundColor: AppColors.surfaceContainerHigh, color: AppColors.primary, minHeight: 6))),
        const SizedBox(width: 16),
        Text(temp, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildAgriAdvice(BuildContext context, List<AgriAdvice> advice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Agri-Weather Advice', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...advice.map((a) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildAdviceCard(a.title, a.subtitle, a.content, _getAdviceIcon(a.type), _getAdviceColor(a.type)),
        )),
      ],
    );
  }

  IconData _getAdviceIcon(String type) {
    if (type == 'fertilizer') return Icons.science;
    if (type == 'irrigation') return Icons.water_drop;
    return Icons.info_outline;
  }

  Color _getAdviceColor(String type) {
    if (type == 'fertilizer') return AppColors.primary;
    if (type == 'irrigation') return AppColors.secondary;
    return AppColors.tertiary;
  }

  Widget _buildAdviceCard(String title, String subtitle, String content, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(24), border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: color)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(content, style: const TextStyle(fontSize: 13, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
