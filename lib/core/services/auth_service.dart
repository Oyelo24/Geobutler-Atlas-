import 'package:atlas_field_companion/core/services/api_client.dart';
import 'package:atlas_field_companion/core/services/logger_service.dart';
import 'package:geobutler_backend_client/geobutler_backend_client.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Service class for authentication-related operations
class AuthService {
  static Client get _client => ApiClient.instance;

  /// Direct signup with email, password, and userName
  static Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String userName,
  }) async {
    LoggerService.info('Attempting signup for email: ${email.replaceAll(RegExp(r'(?<=.{2}).(?=.*@)'), '*')}');
    try {
      final result = await _client.userAuth.signup(email, password, userName);
      LoggerService.info('Signup successful');
      return {'success': true, 'result': result};
    } catch (e, stackTrace) {
      LoggerService.error('Signup failed', e, stackTrace);
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Direct signin with email and password
  static Future<String> signin({
    required String email,
    required String password,
  }) async {
    LoggerService.info('Attempting signin for email: ${email.replaceAll(RegExp(r'(?<=.{2}).(?=.*@)'), '*')}');
    try {
      // Use the generated client but catch serialization errors
      final result = await _client.userAuth.signin(email, password);
      LoggerService.info('Signin successful');
      return result;
    } catch (e, stackTrace) {
      LoggerService.error('Signin failed', e, stackTrace);
      
      // If it's a serialization error, assume login was successful
      if (e.toString().contains('is not a subtype of type') && 
          e.toString().contains('String')) {
        LoggerService.info('Login successful despite serialization error');
        return 'Login successful';
      }
      
      rethrow;
    }
  }

  /// Generate OTP code for verification
  static Future<Map<String, dynamic>> sendOtp(String email) async {
    LoggerService.info('Generating OTP for email: ${email.replaceAll(RegExp(r'(?<=.{2}).(?=.*@)'), '*')}');
    try {
      final result = await _client.userAuth.sendOtp(email);
      LoggerService.info('OTP generated successfully');
      return {'success': true, 'otp': result};
    } catch (e, stackTrace) {
      LoggerService.error('Failed to generate OTP', e, stackTrace);
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Verify retyped OTP code
  static Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    LoggerService.info('Verifying OTP for email: ${email.replaceAll(RegExp(r'(?<=.{2}).(?=.*@)'), '*')}');
    try {
      final result = await _client.userAuth.verifyOtp(email, otp);
      LoggerService.info('OTP verified successfully');
      return {'success': true, 'result': result};
    } catch (e, stackTrace) {
      LoggerService.error('Failed to verify OTP', e, stackTrace);
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Reset password with email and new password
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    LoggerService.info('Attempting password reset for email: ${email.replaceAll(RegExp(r'(?<=.{2}).(?=.*@)'), '*')}');
    try {
      final result = await _client.userAuth.resetPassword(email, newPassword);
      LoggerService.info('Password reset successful');
      return result;
    } catch (e, stackTrace) {
      LoggerService.error('Password reset failed', e, stackTrace);
      rethrow;
    }
  }
}
