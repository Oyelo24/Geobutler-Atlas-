import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final VoidCallback onVerified;
  final VoidCallback onBackToLogin;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.onVerified,
    required this.onBackToLogin,
  });

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isResending = false;
  bool _canResend = true;
  int _countdown = 0;

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
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isResending = false);
    
    _startCountdown();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email sent!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppTheme.backgroundColor,
        ),
        child: SafeArea(
          child: Padding(
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
                
                Expanded(
                  child: Column(
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
                          Icons.mark_email_unread,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      const Text(
                        'Check Your Email',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      const Text(
                        'We sent a verification link to',
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
                        child: const Column(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppTheme.primaryColor,
                              size: 24,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Click the link in your email to verify your account. Check your spam folder if you don't see it.",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.mutedColor,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: widget.onVerified,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ), child: const Text('I\'ve Verified My Email',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),)
                          
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextButton(
                        onPressed: _canResend && !_isResending ? _handleResendEmail : null,
                        child: _isResending
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                                ),
                              )
                            : Text(
                                _canResend 
                                    ? 'Resend Email' 
                                    : 'Resend in ${_countdown}s',
                                style: TextStyle(
                                  color: _canResend ? AppTheme.primaryColor : AppTheme.mutedColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}