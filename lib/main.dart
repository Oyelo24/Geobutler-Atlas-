import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'shared/models/models.dart';
import 'shared/providers/app_state_provider.dart';
import 'shared/widgets/bottom_nav_bar.dart';
import 'features/auth/splash_screen.dart';
import 'features/auth/onboarding_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/projects/projects_screen.dart';
import 'features/collect/collect_screen.dart';
import 'features/map/map_screen.dart';
import 'features/atlas/atlas_screen.dart';
import 'features/settings/settings_screen.dart';

void main() {
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
    final appState = ref.watch(appStateProvider);

    if (_showSplash) {
      return SplashScreen(
        onComplete: () {
          setState(() {
            _showSplash = false;
          });
        },
      );
    }

    if (!appState.isOnboarded) {
      return OnboardingScreen(
        onComplete: () {
          ref.read(appStateProvider.notifier).setIsOnboarded(true);
        },
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          _buildCurrentScreen(appState.currentTab),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(),
          ),
        ],
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