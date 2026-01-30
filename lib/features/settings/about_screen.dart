import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About GeoButler'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GeoButler - Atlas Field Companion',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 24),
            Text(
              'GeoButler is a comprehensive surveying and mapping solution powered by AI. Our Atlas Field Companion app helps surveyors collect, analyze, and manage field data efficiently.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Features:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• AI-powered data analysis with Atlas'),
            Text('• Real-time field data collection'),
            Text('• Project management and tracking'),
            Text('• Interactive mapping and visualization'),
            Text('• Comprehensive reporting tools'),
            Text('• Offline data synchronization'),
          ],
        ),
      ),
    );
  }
}