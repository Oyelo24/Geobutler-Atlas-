import 'package:atlas_field_companion/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'core/theme/app_theme.dart';
import 'core/services/api_client.dart';
import 'shared/models/models.dart';
import 'shared/providers/app_state_provider.dart';
import 'shared/widgets/bottom_nav_bar.dart';
import 'features/auth/splash_screen.dart';
import 'features/auth/auth_wrapper.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/projects/projects_screen.dart';
import 'features/collect/collect_screen.dart';
import 'features/map/map_screen.dart';
import 'features/atlas/atlas_screen.dart';
import 'features/settings/about_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'dart:io';
import 'core/services/logger_service.dart';

Future<String> _loadServerUrl() async {
  try {
    final String configString =
        await rootBundle.loadString('assets/config.json');
    final Map<String, dynamic> config = json.decode(configString);
    return config['serverUrl'] as String;
  } catch (e) {
    LoggerService.error('Failed to load config, using default', e);
    return 'http://localhost:9080';
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LoggerService.info('Starting Atlas Field Companion App');

  String serverUrl = await _loadServerUrl();

  LoggerService.info('Initializing with server URL: $serverUrl');

  ApiClient.initialize(serverUrl: serverUrl);

  runApp(
    const ProviderScope(
      child: AtlasFieldCompanionApp(),
    ),
  );
}

class AtlasFieldCompanionApp extends StatelessWidget {
  const AtlasFieldCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoButler - Atlas Field Companion',
      theme: AppTheme.lightTheme,
      home: const AppContent(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/about-geobutler': (context) => const AboutScreen(),
      },
    );
  }
}

class AppContent extends ConsumerStatefulWidget {
  const AppContent({super.key});

  @override
  ConsumerState<AppContent> createState() => _AppContentState();
}

class _AppContentState extends ConsumerState<AppContent> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashScreen(
        onComplete: () {
          setState(() {
            _showSplash = false;
          });
        },
      );
    }

    return AuthWrapper(
      authenticatedApp: const MainApp(),
    );
  }
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 80, // Reserve space for bottom nav
                  child: _buildCurrentScreen(appState.currentTab),
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: BottomNavBar(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrentScreen(TabType currentTab) {
    switch (currentTab) {
      case TabType.dashboard:
        return const DashboardScreen();
      case TabType.projects:
        return const ProjectsScreen();
      case TabType.collect:
        return const CollectScreen();
      case TabType.map:
        return const MapScreen();
      case TabType.atlas:
        return const AtlasScreen();
      case TabType.settings:
        return const SettingsScreen();
    }
  }
}
