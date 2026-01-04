import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

class AppState {
  final TabType currentTab;
  final List<Project> projects;
  final Project? activeProject;
  final List<SurveyPoint> points;
  final List<ChatMessage> messages;
  final List<DataWarning> warnings;
  final bool isOnboarded;

  const AppState({
    this.currentTab = TabType.dashboard,
    this.projects = const [],
    this.activeProject,
    this.points = const [],
    this.messages = const [],
    this.warnings = const [],
    this.isOnboarded = false,
  });

  AppState copyWith({
    TabType? currentTab,
    List<Project>? projects,
    Project? activeProject,
    List<SurveyPoint>? points,
    List<ChatMessage>? messages,
    List<DataWarning>? warnings,
    bool? isOnboarded,
  }) {
    return AppState(
      currentTab: currentTab ?? this.currentTab,
      projects: projects ?? this.projects,
      activeProject: activeProject ?? this.activeProject,
      points: points ?? this.points,
      messages: messages ?? this.messages,
      warnings: warnings ?? this.warnings,
      isOnboarded: isOnboarded ?? this.isOnboarded,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(_initialState);

  static final AppState _initialState = AppState(
    projects: _sampleProjects,
    activeProject: _sampleProjects.first,
    points: _samplePoints,
    messages: [
      ChatMessage(
        id: '1',
        role: MessageRole.assistant,
        content: "Hello! I'm Atlas, your AI surveying assistant. I'm monitoring your field data and ready to help with analysis, error detection, and report generation. How can I assist you today?",
        timestamp: DateTime.now(),
      ),
    ],
    warnings: _sampleWarnings,
  );

  void setCurrentTab(TabType tab) {
    state = state.copyWith(currentTab: tab);
  }

  void setActiveProject(Project? project) {
    state = state.copyWith(activeProject: project);
  }

  void addProject(Project project) {
    final newProject = project.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      pointsCount: 0,
      status: ProjectStatus.active,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    state = state.copyWith(
      projects: [newProject, ...state.projects],
      activeProject: newProject,
    );
  }

  void addPoint(SurveyPoint point) {
    final newPoint = point.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
    );
    
    state = state.copyWith(points: [...state.points, newPoint]);
    
    // Update project points count
    if (state.activeProject != null) {
      final updatedProject = state.activeProject!.copyWith(
        pointsCount: state.activeProject!.pointsCount + 1,
        updatedAt: DateTime.now(),
      );
      
      final updatedProjects = state.projects.map((p) => 
        p.id == updatedProject.id ? updatedProject : p
      ).toList();
      
      state = state.copyWith(
        projects: updatedProjects,
        activeProject: updatedProject,
      );
    }
  }

  void addMessage(ChatMessage message) {
    final newMessage = message.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
    );
    
    state = state.copyWith(messages: [...state.messages, newMessage]);
  }

  void setIsOnboarded(bool value) {
    state = state.copyWith(isOnboarded: value);
  }
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

// Sample data
final List<Project> _sampleProjects = [
  Project(
    id: '1',
    name: 'Downtown Boundary Survey',
    location: 'Portland, OR',
    surveyType: SurveyType.boundary,
    coordinateSystem: 'NAD83',
    notes: 'Commercial lot survey',
    pointsCount: 24,
    status: ProjectStatus.active,
    createdAt: DateTime(2024, 1, 15),
    updatedAt: DateTime.now(),
  ),
  Project(
    id: '2',
    name: 'Hillside Topographic',
    location: 'Lake Oswego, OR',
    surveyType: SurveyType.topographic,
    coordinateSystem: 'NAD83',
    notes: 'Elevation mapping for development',
    pointsCount: 156,
    status: ProjectStatus.completed,
    createdAt: DateTime(2024, 1, 10),
    updatedAt: DateTime(2024, 1, 20),
  ),
  Project(
    id: '3',
    name: 'Control Network Setup',
    location: 'Beaverton, OR',
    surveyType: SurveyType.control,
    coordinateSystem: 'NAD83',
    notes: 'Establishing control points',
    pointsCount: 8,
    status: ProjectStatus.active,
    createdAt: DateTime(2024, 1, 18),
    updatedAt: DateTime.now(),
  ),
];

final List<SurveyPoint> _samplePoints = [
  SurveyPoint(
    id: '1',
    projectId: '1',
    pointId: 'P001',
    latitude: 45.5152,
    longitude: -122.6784,
    elevation: 15.24,
    accuracy: 0.02,
    fixType: FixType.good,
    description: 'NE Corner marker',
    timestamp: DateTime.now(),
  ),
  SurveyPoint(
    id: '2',
    projectId: '1',
    pointId: 'P002',
    latitude: 45.5148,
    longitude: -122.6780,
    elevation: 15.18,
    accuracy: 0.05,
    fixType: FixType.fair,
    description: 'SE Corner marker',
    timestamp: DateTime.now(),
  ),
];

final List<DataWarning> _sampleWarnings = [
  DataWarning(
    id: '1',
    type: WarningType.poorAccuracy,
    severity: WarningSeverity.warning,
    message: 'Point P012 has accuracy below threshold (0.15m)',
    pointId: 'P012',
    timestamp: DateTime.now(),
  ),
  DataWarning(
    id: '2',
    type: WarningType.anomaly,
    severity: WarningSeverity.info,
    message: 'Elevation jump detected between P008 and P009',
    timestamp: DateTime.now(),
  ),
];