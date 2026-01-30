import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/app_state_provider.dart';
import '../../core/theme/app_theme.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(appStateProvider.select((state) => state.currentTab));
    
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor.withOpacity(0.95),
        border: const Border(
          top: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth / _navItems.length;
            final isCompact = itemWidth < 80;
            
            return Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _navItems.map((item) {
                  final isActive = currentTab == item.tab;
                  
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ref.read(appStateProvider.notifier).setCurrentTab(item.tab);
                      },
                      child: Container(
                        height: 56,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isActive ? AppTheme.primaryColor.withOpacity(0.1) : Colors.transparent,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 28,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: isActive ? AppTheme.primaryColor.withOpacity(0.1) : Colors.transparent,
                              ),
                              child: Icon(
                                item.icon,
                                size: isCompact ? 18 : 20,
                                color: isActive ? AppTheme.primaryColor : AppTheme.mutedColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Flexible(
                              child: Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: isCompact ? 9 : 10,
                                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                                  color: isActive ? AppTheme.primaryColor : AppTheme.mutedColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NavItem {
  final TabType tab;
  final String label;
  final IconData icon;

  const _NavItem({
    required this.tab,
    required this.label,
    required this.icon,
  });
}

final List<_NavItem> _navItems = [
  const _NavItem(
    tab: TabType.dashboard,
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
  ),
  const _NavItem(
    tab: TabType.projects,
    label: 'Projects',
    icon: Icons.folder_outlined,
  ),
  const _NavItem(
    tab: TabType.collect,
    label: 'Collect',
    icon: Icons.location_on_outlined,
  ),
  const _NavItem(
    tab: TabType.map,
    label: 'Map',
    icon: Icons.map_outlined,
  ),
  const _NavItem(
    tab: TabType.atlas,
    label: 'Atlas',
    icon: Icons.smart_toy_outlined,
  ),
  const _NavItem(
    tab: TabType.settings,
    label: 'Settings',
    icon: Icons.settings_outlined,
  ),
];