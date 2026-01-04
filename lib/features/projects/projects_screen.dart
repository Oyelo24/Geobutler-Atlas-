import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/app_state_provider.dart';
import '../../shared/widgets/app_header.dart';
import '../../core/theme/app_theme.dart';
import 'create_project_sheet.dart';
import 'package:intl/intl.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    final notifier = ref.read(appStateProvider.notifier);
    
    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            title: 'Projects',
            subtitle: '${state.projects.length} projects',
            action: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const CreateProjectSheet(),
                );
              },
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(8),
              ),
            ),
          ),
          Expanded(
            child: state.projects.isEmpty
                ? _buildEmptyState(context)
                : _buildProjectsList(context, state, notifier),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.mutedColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.folder_outlined,
                size: 32,
                color: AppTheme.mutedColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No projects yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create your first project to start collecting field data',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.mutedColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const CreateProjectSheet(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 16),
                  SizedBox(width: 8),
                  Text('New Project'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsList(BuildContext context, AppState state, AppStateNotifier notifier) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
      itemCount: state.projects.length,
      itemBuilder: (context, index) {
        final project = state.projects[index];
        final isActive = state.activeProject?.id == project.id;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => notifier.setActiveProject(project),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive ? AppTheme.primaryColor : AppTheme.borderColor,
                  width: isActive ? 2 : 1,
                ),
                boxShadow: isActive ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ] : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  project.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (isActive)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Active',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            project.location,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.mutedColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: AppTheme.mutedColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${project.pointsCount} points',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.mutedColor,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                                color: AppTheme.mutedColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                DateFormat('MMM d').format(project.createdAt),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.mutedColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            // TODO: Show report generator
                          },
                          icon: const Icon(
                            Icons.description_outlined,
                            size: 16,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: AppTheme.mutedColor,
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: project.status == ProjectStatus.active
                                ? AppTheme.successColor.withOpacity(0.1)
                                : AppTheme.mutedColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getSurveyTypeLabel(project.surveyType),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: project.status == ProjectStatus.active
                                  ? AppTheme.successColor
                                  : AppTheme.mutedColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Icon(
                          Icons.chevron_right,
                          color: AppTheme.mutedColor,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getSurveyTypeLabel(SurveyType type) {
    switch (type) {
      case SurveyType.boundary:
        return 'Boundary';
      case SurveyType.topographic:
        return 'Topographic';
      case SurveyType.control:
        return 'Control';
      case SurveyType.recon:
        return 'Reconnaissance';
    }
  }
}