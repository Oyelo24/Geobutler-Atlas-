import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'onboarding_screen.dart';

enum AuthState {
  onboarding,
  login,
  signup,
  authenticated,
}

class AuthWrapper extends StatefulWidget {
  final Widget authenticatedApp;

  const AuthWrapper({
    super.key,
    required this.authenticatedApp,
  });

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  AuthState _currentState = AuthState.onboarding;

  void _handleOnboardingComplete() {
    setState(() {
      _currentState = AuthState.login;
    });
  }

  void _handleLoginSuccess() {
    setState(() {
      _currentState = AuthState.authenticated;
    });
  }

  void _handleSignupSuccess() {
    setState(() {
      _currentState = AuthState.authenticated;
    });
  }

  void _navigateToSignup() {
    setState(() {
      _currentState = AuthState.signup;
    });
  }

  void _navigateToLogin() {
    setState(() {
      _currentState = AuthState.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentState) {
      case AuthState.onboarding:
        return OnboardingScreen(
          onComplete: _handleOnboardingComplete,
        );
      case AuthState.login:
        return LoginScreen(
          onLoginSuccess: _handleLoginSuccess,
          onNavigateToSignup: _navigateToSignup,
        );
      case AuthState.signup:
        return SignupScreen(
          onSignupSuccess: _handleSignupSuccess,
          onNavigateToLogin: _navigateToLogin,
        );
      case AuthState.authenticated:
        return widget.authenticatedApp;
    }
  }
}