import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/app_state_provider.dart';
import '../../shared/widgets/app_header.dart';
import '../../core/theme/app_theme.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    final notifier = ref.read(appStateProvider.notifier);
    
    final todayPoints = state.points.where((point) {
      final today = DateTime.now();
      final pointDate = point.timestamp;
      return pointDate.year == today.year &&
             pointDate.month == today.month &&
             pointDate.day == today.day;
    }).toList();

    final accuracy = _getAccuracyStatus(todayPoints);

    return Scaffold(
      appBar: AppHeader(
        title: 'Welcome back',
        subtitle: 'Your fieldwork, handled',
      ),
      body: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      constraints.maxWidth > 600 ? (constraints.maxWidth - 600) / 2 : 20,
                      0,
                      constraints.maxWidth > 600 ? (constraints.maxWidth - 600) / 2 : 20,
                      96,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  // Active Project Card
                  if (state.activeProject != null) ...[
                    GestureDetector(
                      onTap: () => notifier.setCurrentTab(TabType.projects),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: AppTheme.primaryGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ACTIVE PROJECT',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          state.activeProject!.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          state.activeProject!.location,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.white.withOpacity(0.6),
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                color: AppTheme.cardColor,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                    color: AppTheme.mutedColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${state.activeProject!.pointsCount} points',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.mutedColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: state.activeProject!.status == ProjectStatus.active
                                          ? AppTheme.successColor.withOpacity(0.1)
                                          : AppTheme.mutedColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      state.activeProject!.status == ProjectStatus.active
                                          ? 'Active'
                                          : 'Completed',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: state.activeProject!.status == ProjectStatus.active
                                            ? AppTheme.successColor
                                            : AppTheme.mutedColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Stats Grid
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 400;
                      return isNarrow
                          ? Column(
                              children: [
                                _StatCard(
                                  icon: Icons.location_on_outlined,
                                  value: todayPoints.length.toString(),
                                  label: 'Points today',
                                  color: AppTheme.primaryColor,
                                ),
                                const SizedBox(height: 16),
                                _StatCard(
                                  icon: Icons.check_circle_outline,
                                  value: accuracy.label,
                                  label: 'Accuracy',
                                  color: accuracy.color,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    icon: Icons.location_on_outlined,
                                    value: todayPoints.length.toString(),
                                    label: 'Points today',
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _StatCard(
                                    icon: Icons.check_circle_outline,
                                    value: accuracy.label,
                                    label: 'Accuracy',
                                    color: accuracy.color,
                                  ),
                                ),
                              ],
                            );
                    },
                  ),
                  
                  const SizedBox(height: 16),

                  // Ask Atlas Button
                  GestureDetector(
                    onTap: () => notifier.setCurrentTab(TabType.atlas),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.smart_toy_outlined,
                              color: AppTheme.accentColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ask Atlas',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Get AI-powered insights',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.mutedColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppTheme.mutedColor,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Warnings Section
                  if (state.warnings.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'ALERTS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.mutedColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...state.warnings.take(2).map((warning) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _WarningCard(warning: warning),
                    )),
                  ],

                  // Quick Actions
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => notifier.setCurrentTab(TabType.collect),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Start Collecting',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
  }

  _AccuracyStatus _getAccuracyStatus(List<SurveyPoint> points) {
    if (points.isEmpty) {
      return const _AccuracyStatus(label: 'No data', color: AppTheme.mutedColor);
    }
    
    final avgAccuracy = points.fold<double>(0, (sum, p) => sum + p.accuracy) / points.length;
    
    if (avgAccuracy <= 0.03) {
      return const _AccuracyStatus(label: 'Excellent', color: AppTheme.successColor);
    } else if (avgAccuracy <= 0.08) {
      return const _AccuracyStatus(label: 'Good', color: AppTheme.successColor);
    } else {
      return const _AccuracyStatus(label: 'Fair', color: AppTheme.warningColor);
    }
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.mutedColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  final DataWarning warning;

  const _WarningCard({required this.warning});

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      switch (warning.severity) {
        case WarningSeverity.critical:
          return AppTheme.destructiveColor;
        case WarningSeverity.warning:
          return AppTheme.warningColor;
        case WarningSeverity.info:
          return AppTheme.primaryColor;
      }
    }

    final color = getColor();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.warning_outlined,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  warning.message,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(warning.timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.mutedColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class _AccuracyStatus {
  final String label;
  final Color color;

  const _AccuracyStatus({required this.label, required this.color});
}