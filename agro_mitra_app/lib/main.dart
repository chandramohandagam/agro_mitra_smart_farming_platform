import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/config/env_config.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/dashboard_provider.dart';
import 'core/providers/farm_provider.dart';
import 'core/providers/weather_provider.dart';
import 'core/providers/market_provider.dart';
import 'core/providers/recommendation_provider.dart';
import 'core/providers/disease_provider.dart';
import 'core/providers/ai_provider.dart';
import 'core/providers/marketplace_provider.dart';
import 'core/providers/transport_provider.dart';
import 'core/providers/scheme_provider.dart';
import 'core/providers/notification_provider.dart';
import 'core/providers/dealer_provider.dart';
import 'core/providers/company_provider.dart';
import 'core/providers/admin_provider.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/weather_screen.dart';
import 'screens/my_farm_screen.dart';
import 'screens/crop_recommendation_screen.dart';
import 'screens/disease_detection_screen.dart';
import 'screens/ai_assistant_screen.dart';
import 'screens/marketplace_screen.dart';
import 'screens/fertilizer_recommendation_screen.dart';
import 'screens/transport_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/dealer_dashboard_screen.dart';
import 'screens/company_dashboard_screen.dart';
import 'screens/admin_dashboard_screen.dart';

import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabaseAnonKey,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => FarmProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => MarketProvider()),
        ChangeNotifierProvider(create: (_) => RecommendationProvider()),
        ChangeNotifierProvider(create: (_) => DiseaseProvider()),
        ChangeNotifierProvider(create: (_) => AIProvider()),
        ChangeNotifierProvider(create: (_) => MarketplaceProvider()),
        ChangeNotifierProvider(create: (_) => TransportProvider()),
        ChangeNotifierProvider(create: (_) => SchemeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => DealerProvider()),
        ChangeNotifierProvider(create: (_) => CompanyProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: const AgroMitraApp(),
    ),
  );
}

class AgroMitraApp extends StatelessWidget {
  const AgroMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agro Mitra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainScreen(),
        '/weather': (context) => const WeatherScreen(),
        '/my_farms': (context) => const MyFarmScreen(),
        '/crop_recommendation': (context) => const CropRecommendationScreen(),
        '/disease_detection': (context) => const DiseaseDetectionScreen(),
        '/ai_assistant': (context) => const AIAssistantScreen(),
        '/marketplace': (context) => const MarketplaceScreen(),
        '/fertilizer_recommendation': (context) => const FertilizerRecommendationScreen(),
        '/transport': (context) => const TransportScreen(),
        '/notifications': (context) => const NotificationScreen(),
        '/dealer_dashboard': (context) => const DealerDashboardScreen(),
        '/company_dashboard': (context) => const CompanyDashboardScreen(),
        '/admin_dashboard': (context) => const AdminDashboardScreen(),
      },
    );
  }
}
