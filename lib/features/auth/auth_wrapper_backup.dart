import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'onboarding_screen.dart';
import 'forgot_password_screen.dart';
import 'password_reset_success_screen.dart';
import 'email_verification_screen.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';

enum AuthState {
  onboarding,
  login,
  signup,
  emailVerification,
  forgotPassword,
  passwordResetSuccess,
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
  UuidValue? _accountRequestId;
  String? _registrationPassword;

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
      _registrationPassword = password;
      _accountRequestId = UuidValue.fromString('00000000-0000-0000-0000-000000000000');
      _currentState = AuthState.emailVerification;
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

  void _handlePasswordResetEmailSent() {
    setState(() {
      _currentState = AuthState.passwordResetSuccess;
    });
  }

  void _navigateToEmailVerification(String email, UuidValue requestId, String password) {
    setState(() {
      _verificationEmail = email;
      _accountRequestId = requestId;
      _registrationPassword = password;
      _currentState = AuthState.emailVerification;
    });
  }

  void _handleRegistrationComplete() {
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
          onVerified: _handleRegistrationComplete,
          onBackToLogin: _navigateToLogin,
          onRegistrationComplete: _handleRegistrationComplete,
          password: _registrationPassword!,
          requestId: _accountRequestId!,
        );
      case AuthState.forgotPassword:
        return ForgotPasswordScreen(
          onBackToLogin: _navigateToLogin,
          onPasswordReset: _handlePasswordResetEmailSent,
        );
      case AuthState.passwordResetSuccess:
        return PasswordResetSuccessScreen(
          onBackToLogin: _navigateToLogin,
          email: 'your email',
        );
      case AuthState.authenticated:
        return widget.authenticatedApp;
    }
  }
}
 