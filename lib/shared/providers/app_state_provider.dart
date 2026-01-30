import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geobutler_backend_client/geobutler_backend_client.dart' as backend;
import '../models/models.dart';
import '../../core/services/services.dart';

class AppState {
  final TabType currentTab;
  final List<Project> projects;
  final Project? activeProject;
  final List<SurveyPoint> points;
  final List<ChatSession> chatSessions;
  final ChatSession? activeChatSession;
  final List<DataWarning> warnings;
  final bool isOnboarded;

  const AppState({
    this.currentTab = TabType.dashboard,
    this.projects = const [],
    this.activeProject,
    this.points = const [],
    this.chatSessions = const [],
    this.activeChatSession,
    this.warnings = const [],
    this.isOnboarded = false,
  });

  AppState copyWith({
    TabType? currentTab,
    List<Project>? projects,
    Project? activeProject,
    List<SurveyPoint>? points,
    List<ChatSession>? chatSessions,
    ChatSession? activeChatSession,
    List<DataWarning>? warnings,
    bool? isOnboarded,
  }) {
    return AppState(
      currentTab: currentTab ?? this.currentTab,
      projects: projects ?? this.projects,
      activeProject: activeProject ?? this.activeProject,
      points: points ?? this.points,
      chatSessions: chatSessions ?? this.chatSessions,
      activeChatSession: activeChatSession ?? this.activeChatSession,
      warnings: warnings ?? this.warnings,
      isOnboarded: isOnboarded ?? this.isOnboarded,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(_initialState) {
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Load real data from backend on startup
      await loadProjects();
      
      // Initialize with welcome chat session if none exist
      if (state.chatSessions.isEmpty) {
        final welcomeSession = ChatSession(
          id: '1',
          title: 'Welcome Chat',
          messages: [
            ChatMessage(
              id: '1',
              role: MessageRole.assistant,
              content: "Hello! I'm Atlas, your AI surveying assistant. I can help with technical questions, project analysis, and surveying expertise. What would you like to know?",
              timestamp: DateTime.now(),
            ),
          ],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        state = state.copyWith(
          chatSessions: [welcomeSession],
          activeChatSession: welcomeSession,
        );
      }
    } catch (e) {
      LoggerService.error('Failed to initialize app: $e');
    }
  }

  static final AppState _initialState = AppState(
    projects: [],
    activeProject: null,
    points: [],
    chatSessions: [],
    activeChatSession: null,
    warnings: [],
  );

  void setCurrentTab(TabType tab) {
    state = state.copyWith(currentTab: tab);
  }

  void setActiveProject(Project? project) {
    state = state.copyWith(activeProject: project);
  }

  void createNewChatSession() {
    final newSession = ChatSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Chat',
      messages: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    // Don't add to sessions list until first message is sent
    state = state.copyWith(
      activeChatSession: newSession,
    );
  }

  void setActiveChatSession(ChatSession session) {
    state = state.copyWith(activeChatSession: session);
  }

  void addMessageToActiveSession(ChatMessage message) {
    if (state.activeChatSession == null) {
      createNewChatSession();
    }
    
    final activeSession = state.activeChatSession!;
    final updatedMessages = [...activeSession.messages, message];
    
    // Generate title from first user message
    String title = activeSession.title;
    if (title == 'New Chat' && message.role == MessageRole.user) {
      title = message.content.length > 30 
          ? '${message.content.substring(0, 30)}...'
          : message.content;
    }
    
    final updatedSession = activeSession.copyWith(
      messages: updatedMessages,
      title: title,
      updatedAt: DateTime.now(),
    );
    
    // Add session to list if it's the first message and not already in list
    List<ChatSession> updatedSessions;
    if (activeSession.messages.isEmpty && !state.chatSessions.any((s) => s.id == activeSession.id)) {
      updatedSessions = [updatedSession, ...state.chatSessions];
    } else {
      updatedSessions = state.chatSessions.map((s) => 
        s.id == updatedSession.id ? updatedSession : s
      ).toList();
    }
    
    state = state.copyWith(
      chatSessions: updatedSessions,
      activeChatSession: updatedSession,
    );
  }

  void deleteChatSession(String sessionId) {
    final updatedSessions = state.chatSessions.where((s) => s.id != sessionId).toList();
    
    ChatSession? newActiveSession;
    if (state.activeChatSession?.id == sessionId) {
      newActiveSession = updatedSessions.isNotEmpty ? updatedSessions.first : null;
    } else {
      newActiveSession = state.activeChatSession;
    }
    
    state = state.copyWith(
      chatSessions: updatedSessions,
      activeChatSession: newActiveSession,
    );
  }

  Future<void> addProject(Project project) async {
    try {
      final backendProject = backend.Project(
        name: project.name,
        description: project.notes,
        location: project.location,
        surveyorId: 1,
        status: 'active',
        startDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final result = await ProjectService.createProject(backendProject);
      
      final newProject = project.copyWith(
        id: result.id.toString(),
        pointsCount: 0,
        status: ProjectStatus.active,
        createdAt: result.createdAt,
        updatedAt: result.updatedAt,
      );
      
      state = state.copyWith(
        projects: [newProject, ...state.projects],
        activeProject: newProject,
      );
    } catch (e) {
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
  }

  Future<void> addPoint(SurveyPoint point) async {
    try {
      if (state.activeProject != null) {
        final backendPoint = backend.GeoPoint(
          pointId: point.pointId,
          latitude: point.latitude,
          longitude: point.longitude,
          elevation: point.elevation,
          accuracy: point.accuracy,
          projectId: int.parse(state.activeProject!.id),
          pointType: 'survey',
          createdAt: DateTime.now(),
        );
        
        final result = await GeoDataService.addPoint(backendPoint);
        
        final newPoint = point.copyWith(
          id: result.id.toString(),
          timestamp: result.createdAt,
        );
        
        state = state.copyWith(points: [...state.points, newPoint]);
        
        // Auto-generate warnings
        try {
          final allPoints = [...state.points];
          final newWarnings = SurveyComputations.detectAnomalies(allPoints);
          state = state.copyWith(warnings: [...state.warnings, ...newWarnings]);
        } catch (e) {
          // Skip warnings if method not available
        }
        
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
    } catch (e) {
      final newPoint = point.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
      );
      
      state = state.copyWith(points: [...state.points, newPoint]);
      
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
  }

  void setIsOnboarded(bool value) {
    state = state.copyWith(isOnboarded: value);
  }

  Future<void> loadProjects() async {
    try {
      final projects = await ProjectService.getMyProjects(1);
      final appProjects = projects.map((p) => Project(
        id: p.id.toString(),
        name: p.name,
        location: p.location,
        surveyType: SurveyType.boundary,
        coordinateSystem: 'WGS84',
        notes: p.description ?? '',
        pointsCount: 0,
        status: ProjectStatus.active,
        createdAt: p.createdAt,
        updatedAt: p.updatedAt,
      )).toList();
      
      state = state.copyWith(projects: appProjects);
    } catch (e) {
      LoggerService.error('Failed to load projects: $e');
    }
  }

  Future<void> loadProjectPoints(String projectId) async {
    try {
      final points = await GeoDataService.getPointsByProject(int.parse(projectId));
      final appPoints = points.map((p) => SurveyPoint(
        id: p.id.toString(),
        pointId: p.pointId,
        projectId: p.projectId.toString(),
        latitude: p.latitude,
        longitude: p.longitude,
        elevation: p.elevation ?? 0.0,
        accuracy: p.accuracy ?? 0.0,
        fixType: FixType.good,
        description: p.description ?? '',
        timestamp: p.createdAt,
      )).toList();
      
      state = state.copyWith(points: appPoints);
    } catch (e) {
      LoggerService.error('Failed to load points: $e');
    }
  }
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});