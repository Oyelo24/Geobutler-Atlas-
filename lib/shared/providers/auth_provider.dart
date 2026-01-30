import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geobutler_backend_client/geobutler_backend_client.dart' as backend;
import '../../core/services/auth_service.dart';

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  factory User.fromBackend(backend.SurveyorProfile profile) => User(
    id: profile.id?.toString() ?? '0',
    name: '${profile.firstName ?? ''} ${profile.lastName ?? ''}'.trim(),
    email: profile.email ?? '',
    role: UserRole.fieldSurveyor,
    createdAt: profile.createdAt ?? DateTime.now(),
  );
}

enum UserRole { fieldSurveyor, officeStaff, admin }

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) => AuthState(
    user: user ?? this.user,
    isLoading: isLoading ?? this.isLoading,
    error: error ?? this.error,
  );

  bool get isAuthenticated => user != null;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await AuthService.signin(email: email, password: password);
      
      final profile = backend.SurveyorProfile(
        userId: 1,
        firstName: 'Demo',
        lastName: 'User',
        email: email,
        phone: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final user = User.fromBackend(profile);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final authResult = await AuthService.signup(email: email, password: password, userName: name);
      
      if (authResult['success'] == true) {
        final nameParts = name.split(' ');
        final firstName = nameParts.isNotEmpty ? nameParts.first : 'User';
        final lastName = nameParts.length > 1 ? nameParts.last : '';
        
        final newProfile = backend.SurveyorProfile(
          userId: DateTime.now().millisecondsSinceEpoch,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        final user = User.fromBackend(newProfile);
        state = state.copyWith(user: user, isLoading: false);
      } else {
        state = state.copyWith(error: authResult['error'] ?? 'Signup failed', isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  void signOut() {
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});