import 'package:flutter/material.dart';
import 'package:serverpod_client/serverpod_client.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/auth_service.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final UuidValue requestId;
  final String password;
  final VoidCallback onVerified;
  final VoidCallback onBackToLogin;
  final VoidCallback onRegistrationComplete;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.requestId,
    required this.password,
    required this.onVerified,
    required this.onBackToLogin,
    required this.onRegistrationComplete,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isResending = false;
  bool _canResend = true;
  bool _isVerifying = false;
  int _countdown = 0;
  final _codeController = TextEditingController();
  String? _displayedOtp;

  Future<void> _generateOtp() async {
    try {
      final result = await AuthService.sendOtp(widget.email);
      if (result['success'] == true && result['otp'] != null) {
        setState(() {
          _displayedOtp = result['otp'];
        });
      }
    } catch (e) {
      // Handle silently, will show generate button
    }
  }

  Future<void> _handleEmailVerified() async {
    if (_codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the verification code'),
          backgroundColor: AppTheme.destructiveColor,
        ),
      );
      return;
    }

    setState(() => _isVerifying = true);

    try {
      // Use custom OTP verification
      final result = await AuthService.verifyOtp(
        widget.email,
        _codeController.text,
      );

      if (result['success'] == true) {
        widget.onRegistrationComplete();
      } else {
        throw Exception(result['error'] ?? 'Verification failed');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: ${e.toString()}'),
            backgroundColor: AppTheme.destructiveColor,
          ),
        );
      }
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  void _startCountdown() {
    setState(() {
      _canResend = false;
      _countdown = 60;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _countdown--;
        });
        return _countdown > 0;
      }
      return false;
    }).then((_) {
      if (mounted) {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  Future<void> _handleResendEmail() async {
    setState(() => _isResending = true);

    try {
      final result = await AuthService.sendOtp(widget.email);

      if (result['success'] == true && result['otp'] != null) {
        setState(() {
          _displayedOtp = result['otp'];
        });
        _startCountdown();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('New verification code generated'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
      } else {
        throw Exception(result['error'] ?? 'Failed to generate code');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate new code: ${e.toString()}'),
            backgroundColor: AppTheme.destructiveColor,
          ),
        );
      }
    } finally {
      setState(() => _isResending = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _generateOtp();
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: AppTheme.backgroundColor),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: widget.onBackToLogin,
                    icon: const Icon(Icons.arrow_back),
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: AppTheme.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.security,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      'Verify Your Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Enter the verification code to complete registration',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.mutedColor,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      widget.email,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.security,
                            color: AppTheme.primaryColor,
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Your verification code:",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.mutedColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (_displayedOtp != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _displayedOtp!,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 4,
                                ),
                              ),
                            ),
                          const SizedBox(height: 8),
                          const Text(
                            "Enter this code below to verify your account",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.mutedColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                     // Verification code input
                     TextFormField(
                       controller: _codeController,
                       keyboardType: TextInputType.number,
                       textAlign: TextAlign.center,
                       style: const TextStyle(
                         fontSize: 24,
                         fontWeight: FontWeight.bold,
                         letterSpacing: 8,
                       ),
                       decoration: InputDecoration(
                         labelText: 'Verification Code',
                         hintText: 'Enter 6-digit code',
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(12),
                           borderSide: const BorderSide(
                             color: AppTheme.borderColor,
                           ),
                         ),
                         focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(12),
                           borderSide: const BorderSide(
                             color: AppTheme.primaryColor,
                             width: 2,
                           ),
                         ),
                         filled: true,
                         fillColor: Colors.white,
                       ),
                       maxLength: 6,
                     ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isVerifying ? null : _handleEmailVerified,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isVerifying
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Verify Code',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: _canResend && !_isResending
                          ? _handleResendEmail
                          : null,
                      child: _isResending
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryColor,
                                ),
                              ),
                            )
                          : Text(
                              _canResend
                                  ? 'Generate New Code'
                                  : 'Generate in ${_countdown}s',
                              style: TextStyle(
                                color: _canResend
                                    ? AppTheme.primaryColor
                                    : AppTheme.mutedColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
