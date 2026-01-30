import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/app_state_provider.dart';
import '../../shared/widgets/app_header.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/survey_computations.dart';
import '../../core/services/sync_service.dart';
import '../../core/services/report_service_fixed.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  final _commentController = TextEditingController();
  ProjectStatus _selectedStatus = ProjectStatus.underReview;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    
    if (state.activeProject == null) {
      return const Scaffold(
        appBar: AppHeader(
          title: 'Review & Approval',
          subtitle: 'Quality control workflow',
        ),
        body: Center(
          child: Text('No project selected for review'),
        ),
      );
    }

    final project = state.activeProject!;
    final points = state.points.where((p) => p.projectId == project.id).toList();
    final closure = SurveyComputations.calculateClosure(points);
    
    List<DataWarning> warnings = [];
    try {
      warnings = SurveyComputations.detectAnomalies(points);
    } catch (e) {
      // Skip warnings if method not available
    }

    return Scaffold(
      appBar: AppHeader(
        title: 'Review: ${project.name}',
        subtitle: 'Quality control & approval',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quality Assessment
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: closure.isAcceptable 
                    ? AppTheme.successColor.withOpacity(0.1)
                    : AppTheme.destructiveColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: closure.isAcceptable 
                      ? AppTheme.successColor
                      : AppTheme.destructiveColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        closure.isAcceptable ? Icons.check_circle : Icons.error,
                        color: closure.isAcceptable 
                            ? AppTheme.successColor
                            : AppTheme.destructiveColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Quality Assessment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: closure.isAcceptable 
                              ? AppTheme.successColor
                              : AppTheme.destructiveColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Points: ${points.length}'),
                  Text('Closure Error: ${closure.linearError.toStringAsFixed(3)}m'),
                  Text('Precision: 1:${(1 / closure.precision).toStringAsFixed(0)}'),
                  Text('Status: ${closure.message}'),
                  
                  if (warnings.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text('Warnings:', style: TextStyle(fontWeight: FontWeight.w600)),
                    ...warnings.take(3).map((w) => Text('• ${w.message}')),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Review Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Project Status', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  
                  DropdownButtonFormField<ProjectStatus>(
                    value: _selectedStatus,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    items: ProjectStatus.values.map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.name.toUpperCase()),
                    )).toList(),
                    onChanged: (value) => setState(() => _selectedStatus = value!),
                  ),

                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: _commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Review Comments',
                      hintText: 'Add review comments...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _generateReport(project, points),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.secondaryColor,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Generate Report'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _submitReview(project),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedStatus == ProjectStatus.approved 
                                ? AppTheme.successColor 
                                : AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(_selectedStatus == ProjectStatus.approved 
                              ? 'Approve' 
                              : 'Submit Review'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generateReport(Project project, List<SurveyPoint> points) async {
    try {
      final report = await ReportService.generateReport(project, points);
      final content = ReportService.generatePDFContent(report);
      
      // Try backend PDF generation first
      try {
        final pdfUrl = await SyncService.generatePDFReport({
          'projectId': project.id,
          'content': content,
          'format': 'pdf'
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF generated: $pdfUrl')),
        );
      } catch (e) {
        // Fallback to local content display
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Survey Report'),
            content: SingleChildScrollView(child: Text(content)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
            ],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report generation failed: $e')),
      );
    }
  }

  void _submitReview(Project project) async {
    try {
      await SyncService.updateProjectStatus(
        int.parse(project.id), 
        _selectedStatus.name, 
        _commentController.text
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully')),
      );
      _commentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review submission failed: $e')),
      );
    }
  }
}