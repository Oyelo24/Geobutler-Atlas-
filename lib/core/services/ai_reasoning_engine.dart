import '../../shared/models/models.dart';
import '../config/ai_config.dart';
import '../services/ai_service.dart';

class AIReasoningEngine {
  
  static Future<String> generateResponse(String query, Map<String, dynamic> context) async {
    if (AIConfig.useBackendAI) {
      return await _useBackendAI(query, context);
    } else {
      return _getFallbackResponse(query, context);
    }
  }
  
  static Future<String> _useBackendAI(String query, Map<String, dynamic> context) async {
    try {
      print('DEBUG: Calling AIService.chatWithAtlas with query: $query');
      final response = await AIService.chatWithAtlas(query);
      print('DEBUG: Received response: $response');
      return response;
    } catch (e) {
      print('DEBUG: AI service failed with error: $e');
      return _getFallbackResponse(query, context);
    }
  }
  
  static bool _isAnalysisQuery(String query) {
    final analysisKeywords = ['analyze', 'analysis', 'quality', 'accuracy', 'data', 'points'];
    return analysisKeywords.any((keyword) => query.toLowerCase().contains(keyword));
  }
  
  static bool _isRecommendationQuery(String query) {
    final recommendationKeywords = ['recommend', 'suggest', 'advice', 'should', 'best', 'improve'];
    return recommendationKeywords.any((keyword) => query.toLowerCase().contains(keyword));
  }
  
  static String _formatRecommendations(List<String> recommendations, String query) {
    if (recommendations.isEmpty) {
      return "I'd be happy to provide recommendations. Could you be more specific about what aspect of surveying you'd like guidance on?";
    }
    
    final intro = "Based on your project data, here are my recommendations:\n\n";
    final formattedRecs = recommendations.map((rec) => "• $rec").join('\n');
    
    return intro + formattedRecs;
  }
  
  static String _getGeneralSurveyingResponse(String query) {
    final lowerQuery = query.toLowerCase();
    
    if (lowerQuery.contains('gps') || lowerQuery.contains('accuracy')) {
      return "For GPS surveying, aim for accuracy under 3 meters for professional work. Factors affecting accuracy include satellite geometry, atmospheric conditions, and obstructions. Consider RTK corrections for sub-meter precision.";
    } else if (lowerQuery.contains('equipment') || lowerQuery.contains('instrument')) {
      return "Essential surveying equipment includes GNSS receivers, total stations, levels, and data collectors. Choose equipment based on your accuracy requirements and survey type. Regular calibration is crucial for reliable results.";
    } else if (lowerQuery.contains('boundary') || lowerQuery.contains('property')) {
      return "Boundary surveys require careful research of deeds, plats, and existing monuments. Follow the hierarchy of evidence: monuments, courses and distances, then area. Always document your findings thoroughly.";
    } else {
      return "I'm Atlas, your surveying AI assistant. I can help with GPS accuracy, equipment selection, survey procedures, and data analysis. What specific surveying topic would you like to discuss?";
    }
  }
  
  static String _getFallbackResponse(String query, Map<String, dynamic> context) {
    final lowerQuery = query.toLowerCase();
    
    if (lowerQuery.contains('gps') || lowerQuery.contains('accuracy')) {
      return "For GPS surveying, aim for accuracy under 3 meters for professional work. Factors affecting accuracy include satellite geometry, atmospheric conditions, and obstructions. Consider RTK corrections for sub-meter precision.";
    } else if (lowerQuery.contains('equipment') || lowerQuery.contains('instrument')) {
      return "Essential surveying equipment includes GNSS receivers, total stations, levels, and data collectors. Choose equipment based on your accuracy requirements and survey type. Regular calibration is crucial for reliable results.";
    } else if (lowerQuery.contains('boundary') || lowerQuery.contains('property')) {
      return "Boundary surveys require careful research of deeds, plats, and existing monuments. Follow the hierarchy of evidence: monuments, courses and distances, then area. Always document your findings thoroughly.";
    } else if (lowerQuery.contains('analyze') || lowerQuery.contains('analysis')) {
      return "I can analyze your survey data for accuracy, completeness, and quality issues. Currently running in offline mode - connect to the backend server for detailed AI analysis.";
    } else if (lowerQuery.contains('recommend') || lowerQuery.contains('suggest')) {
      return "Here are some general surveying recommendations:\n\n• Maintain GPS accuracy below 3 meters\n• Take multiple readings at critical points\n• Document environmental conditions\n• Regular equipment calibration\n• Use systematic collection patterns";
    } else {
      return "I'm Atlas, your surveying AI assistant. I can help with GPS accuracy, equipment selection, survey procedures, and data analysis. What specific surveying topic would you like to discuss?";
    }
  }
}