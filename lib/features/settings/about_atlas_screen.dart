import 'package:flutter/material.dart';
import '../../shared/widgets/app_header.dart';
import '../../core/theme/app_theme.dart';

class AboutAtlasScreen extends StatelessWidget {
  const AboutAtlasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(
        title: 'About Atlas',
        subtitle: 'AI surveying assistant',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.secondaryColor, AppTheme.secondaryColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(Icons.smart_toy, size: 64, color: Colors.black87),
                  SizedBox(height: 16),
                  Text(
                    'Atlas AI',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your intelligent surveying companion',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              'What is Atlas?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Atlas is an advanced AI assistant specifically trained for surveying and geospatial work. It provides intelligent guidance, answers technical questions, and helps optimize your field operations.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Capabilities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            _buildCapabilityItem('🎯', 'GPS and positioning guidance'),
            _buildCapabilityItem('📐', 'Survey calculations and formulas'),
            _buildCapabilityItem('🛠️', 'Equipment recommendations'),
            _buildCapabilityItem('📋', 'Best practices and standards'),
            _buildCapabilityItem('🔍', 'Data quality analysis'),
            _buildCapabilityItem('💬', 'Natural conversation interface'),
            
            const SizedBox(height: 24),
            
            const Text(
              'How to Use Atlas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            _buildStepItem('1', 'Navigate to the Atlas tab'),
            _buildStepItem('2', 'Ask questions in natural language'),
            _buildStepItem('3', 'Get instant expert guidance'),
            _buildStepItem('4', 'Apply insights to your work'),
            
            const SizedBox(height: 32),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Example Questions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text('• "How do I improve GPS accuracy?"'),
                  SizedBox(height: 4),
                  Text('• "What\'s the best traverse method?"'),
                  SizedBox(height: 4),
                  Text('• "Explain closure error calculation"'),
                  SizedBox(height: 4),
                  Text('• "Recommend equipment for boundary survey"'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCapabilityItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStepItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}