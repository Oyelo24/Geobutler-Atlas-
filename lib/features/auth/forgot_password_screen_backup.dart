// import 'package:flutter/material.dart';
// import '../../core/theme/app_theme.dart';
// import '../../core/services/auth_service.dart';

// class ForgotPasswordScreen extends StatefulWidget {
//   final VoidCallback onBackToLogin;
//   final VoidCallback onEmailSent;

//   const ForgotPasswordScreen({
//     super.key,
//     required this.onBackToLogin,
//     required this.onEmailSent,
//   });

//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   bool _isLoading = false;
//   String? _errorMessage;

//   Future<void> _handleSendEmail() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       await AuthService.startPasswordReset(_emailController.text.trim());
//       widget.onEmailSent();
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to send reset email. Please try again.';
//       });
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           color: AppTheme.backgroundColor,
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 IconButton(
//                   onPressed: widget.onBackToLogin,
//                   icon: const Icon(Icons.arrow_back),
//                   padding: EdgeInsets.zero,
//                   alignment: Alignment.centerLeft,
//                 ),
                
//                 const SizedBox(height: 40),
                
//                 Center(
//                   child: Column(
//                     children: [
//                       Container(
//                         width: 80,
//                         height: 80,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           gradient: AppTheme.primaryGradient,
//                           boxShadow: [
//                             BoxShadow(
//                               color: AppTheme.primaryColor.withOpacity(0.3),
//                               blurRadius: 20,
//                               offset: const Offset(0, 8),
//                             ),
//                           ],
//                         ),
//                         child: const Icon(
//                           Icons.lock_reset,
//                           size: 40,
//                           color: Colors.white,
//                         ),
//                       ),
                      
//                       const SizedBox(height: 24),
                      
//                       const Text(
//                         'Forgot Password?',
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
                      
//                       const SizedBox(height: 8),
                      
//                       const Text(
//                         'Enter your email to receive reset instructions',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: AppTheme.mutedColor,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
                
//                 const SizedBox(height: 48),
                
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       if (_errorMessage != null) ...[
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.red.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(color: Colors.red.withOpacity(0.3)),
//                           ),
//                           child: Row(
//                             children: [
//                               const Icon(Icons.error_outline, color: Colors.red, size: 20),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   _errorMessage!,
//                                   style: const TextStyle(color: Colors.red, fontSize: 14),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                       ],
//                       TextFormField(
//                         controller: _emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: InputDecoration(
//                           labelText: 'Email',
//                           hintText: 'Enter your email',
//                           prefixIcon: const Icon(Icons.email_outlined),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: const BorderSide(color: AppTheme.borderColor),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: const BorderSide(color: AppTheme.borderColor),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
//                           ),
//                           filled: true,
//                           fillColor: Colors.white,
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your email';
//                           }
//                           if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                             return 'Please enter a valid email';
//                           }
//                           return null;
//                         },
//                       ),
                      
//                       const SizedBox(height: 32),
                      
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: _isLoading ? null : _handleSendEmail,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppTheme.primaryColor,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             elevation: 0,
//                           ),
//                           child: _isLoading
//                               ? const SizedBox(
//                                   height: 20,
//                                   width: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                   ),
//                                 )
//                               : const Text(
//                                   'Send Reset Email',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     super.dispose();
//   }
// }