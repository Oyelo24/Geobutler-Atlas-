import 'package:flutter/material.dart';
import 'package:serverpod_client/serverpod_client.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'onboarding_screen.dart';
import 'forgot_password_screen.dart';
import 'email_verification_screen.dart';

enum AuthState {
  onboarding,
  login,
  signup,
  emailVerification,
  forgotPassword,
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
  String? _verificationEmail;
  String? _verificationPassword;
  UuidValue? _verificationRequestId;

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

  void _handleSignupSuccess(String email, String password) {
    setState(() {
      _verificationEmail = email;
      _verificationPassword = password;
      _verificationRequestId = UuidValue.fromString('00000000-0000-0000-0000-000000000000');
      _currentState = AuthState.emailVerification;
    });
  }

  void _handleVerificationComplete() {
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

  void _navigateToForgotPassword() {
    setState(() {
      _currentState = AuthState.forgotPassword;
    });
  }

  void _handlePasswordReset() {
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
          onNavigateToForgotPassword: _navigateToForgotPassword,
        );
      case AuthState.signup:
        return SignupScreen(
          onSignupSuccess: _handleSignupSuccess,
          onNavigateToLogin: _navigateToLogin,
        );
      case AuthState.emailVerification:
        return EmailVerificationScreen(
          email: _verificationEmail!,
          requestId: _verificationRequestId!,
          password: _verificationPassword!,
          onVerified: () {},
          onBackToLogin: _navigateToLogin,
          onRegistrationComplete: _handleVerificationComplete,
        );
      case AuthState.forgotPassword:
        return ForgotPasswordScreen(
          onBackToLogin: _navigateToLogin,
          onPasswordReset: _handlePasswordReset,
        );
      case AuthState.authenticated:
        return widget.authenticatedApp;
    }
  }
}