import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/app_state_provider.dart';
import '../../core/theme/app_theme.dart';

class CreateProjectSheet extends ConsumerStatefulWidget {
  const CreateProjectSheet({super.key});

  @override
  ConsumerState<CreateProjectSheet> createState() => _CreateProjectSheetState();
}

class _CreateProjectSheetState extends ConsumerState<CreateProjectSheet> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  SurveyType? _surveyType;
  String _coordinateSystem = 'NAD83';

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleCreate() {
    if (_nameController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty ||
        _surveyType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: AppTheme.destructiveColor,
        ),
      );
      return;
    }

    final project = Project(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      location: _locationController.text.trim(),
      surveyType: _surveyType!,
      coordinateSystem: _coordinateSystem,
      notes: _notesController.text.trim(),
      pointsCount: 0,
      status: ProjectStatus.active,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    ref.read(appStateProvider.notifier).addProject(project);
    ref.read(appStateProvider.notifier).setCurrentTab(TabType.collect);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${project.name} is now your active project'),
        backgroundColor: AppTheme.successColor,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 48,
            height: 6,
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              color: AppTheme.mutedColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          
          // Header
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'New Project',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project Name
                  const Text(
                    'Project Name *',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Downtown Boundary Survey',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.primaryColor),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Location
                  const Text(
                    'Location *',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: 'Portland, OR',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.primaryColor),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Survey Type
                  const Text(
                    'Survey Type *',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<SurveyType>(
                    value: _surveyType,
                    decoration: InputDecoration(
                      hintText: 'Select type...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.primaryColor),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: SurveyType.boundary,
                        child: Text('Boundary Survey'),
                      ),
                      DropdownMenuItem(
                        value: SurveyType.topographic,
                        child: Text('Topographic Survey'),
                      ),
                      DropdownMenuItem(
                        value: SurveyType.control,
                        child: Text('Control Survey'),
                      ),
                      DropdownMenuItem(
                        value: SurveyType.recon,
                        child: Text('Reconnaissance'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _surveyType = value;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Coordinate System
                  const Text(
                    'Coordinate System',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _coordinateSystem,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.primaryColor),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'NAD83', child: Text('NAD83')),
                      DropdownMenuItem(value: 'WGS84', child: Text('WGS84')),
                      DropdownMenuItem(value: 'NAD27', child: Text('NAD27')),
                      DropdownMenuItem(value: 'Local', child: Text('Local Grid')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _coordinateSystem = value!;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Notes
                  const Text(
                    'Notes',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Additional project details...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.primaryColor),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Create Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleCreate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Create Project',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}