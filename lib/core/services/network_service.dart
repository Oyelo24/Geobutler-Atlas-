import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:atlas_field_companion/core/services/logger_service.dart';
import 'package:http/http.dart' as http;

class NetworkService {
  static Future<bool> checkServerConnectivity(String host, int port) async {
    LoggerService.info('Checking server connectivity to $host:$port');

    if (kIsWeb) {
      // Use HTTP request for web instead of socket
      try {
        final response = await http.get(
          Uri.parse('http://$host:$port'),
          headers: {'Access-Control-Allow-Origin': '*'},
        ).timeout(const Duration(seconds: 5));
        LoggerService.info('Server connectivity check successful (HTTP)');
        return response.statusCode < 500;
      } catch (e) {
        LoggerService.error('Server connectivity check failed (HTTP)', e);
        return false;
      }
    } else {
      // Use socket for non-web platforms
      try {
        final socket = await Socket.connect(host, port,
            timeout: const Duration(seconds: 5));
        socket.destroy();
        LoggerService.info('Server connectivity check successful');
        return true;
      } catch (e) {
        LoggerService.error('Server connectivity check failed', e);
        return false;
      }
    }
  }

  static Future<bool> checkInternetConnectivity() async {
    LoggerService.info('Checking internet connectivity');

    if (kIsWeb) {
      // Use HTTP request for web
      try {
        final response = await http
            .get(Uri.parse('https://www.google.com'))
            .timeout(const Duration(seconds: 5));
        LoggerService.info('Internet connectivity check successful (HTTP)');
        return response.statusCode == 200;
      } catch (e) {
        LoggerService.error('Internet connectivity check failed (HTTP)', e);
        return false;
      }
    } else {
      // Use InternetAddress lookup for non-web platforms
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          LoggerService.info('Internet connectivity check successful');
          return true;
        }
      } catch (e) {
        LoggerService.error('Internet connectivity check failed', e);
      }
      return false;
    }
  }

  static Future<Map<String, dynamic>> performNetworkDiagnostics() async {
    LoggerService.info('Starting network diagnostics');

    final diagnostics = <String, dynamic>{};

    // Check internet connectivity
    diagnostics['hasInternet'] = await checkInternetConnectivity();

    // Determine correct server host and port based on platform
    String serverHost;
    int serverPort = 9082; // API server port

    if (kIsWeb) {
      serverHost = 'localhost';
    } else if (!kIsWeb && Platform.isAndroid) {
      serverHost = '192.168.100.222'; // Your actual IP for real device
    } else {
      serverHost = 'localhost';
    }

    // Check server connectivity
    diagnostics['serverReachable'] =
        await checkServerConnectivity(serverHost, serverPort);
    diagnostics['serverHost'] = serverHost;
    diagnostics['serverPort'] = serverPort;

    // Check if localhost resolves (skip on web)
    if (kIsWeb) {
      diagnostics['localhostResolves'] = 'N/A (Web platform)';
      diagnostics['platform'] = 'Web';
    } else {
      diagnostics['platform'] =
          Platform.isAndroid ? 'Android' : Platform.operatingSystem;
      try {
        final addresses = await InternetAddress.lookup('localhost');
        diagnostics['localhostResolves'] = addresses.isNotEmpty;
        diagnostics['localhostAddresses'] =
            addresses.map((addr) => addr.address).toList();
      } catch (e) {
        diagnostics['localhostResolves'] = false;
        diagnostics['localhostError'] = e.toString();
      }
    }

    LoggerService.info('Network diagnostics completed: $diagnostics');
    return diagnostics;
  }
}
