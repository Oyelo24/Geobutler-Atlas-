import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/app_state_provider.dart';
import '../../shared/widgets/app_header.dart';
import '../../core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class AtlasScreen extends ConsumerStatefulWidget {
  const AtlasScreen({super.key});

  @override
  ConsumerState<AtlasScreen> createState() => _AtlasScreenState();
}

class _AtlasScreenState extends ConsumerState<AtlasScreen> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;

  final List<QuickAction> _quickActions = [
    QuickAction(
      icon: Icons.bar_chart,
      label: 'Analyze my data',
      prompt: 'Can you analyze my current field data and give me a summary?',
    ),
    QuickAction(
      icon: Icons.description,
      label: 'Generate report',
      prompt: 'Please generate a survey report for my active project.',
    ),
    QuickAction(
      icon: Icons.warning_outlined,
      label: 'Check for errors',
      prompt: 'Are there any errors or anomalies in my recent measurements?',
    ),
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend([String? text]) {
    final messageText = text ?? _inputController.text;
    if (messageText.trim().isEmpty) return;

    final state = ref.read(appStateProvider);
    
    // Add user message
    ref.read(appStateProvider.notifier).addMessage(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: MessageRole.user,
        content: messageText,
        timestamp: DateTime.now(),
      ),
    );

    _inputController.clear();
    setState(() {
      _isTyping = true;
    });
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      
      setState(() {
        _isTyping = false;
      });

      String response = '';
      
      if (messageText.toLowerCase().contains('analyze')) {
        response = "I've analyzed your data for ${state.activeProject?.name ?? 'your project'}. Here's what I found:\n\n• ${state.activeProject?.pointsCount ?? 0} points collected\n• Average accuracy: Good\n• ${state.warnings.length} potential issues detected\n\nWould you like me to explain any specific findings?";
      } else if (messageText.toLowerCase().contains('report')) {
        response = "I can generate a survey report for ${state.activeProject?.name ?? 'your project'}. The report will include:\n\n• Project summary\n• Point coordinates table\n• Accuracy statistics\n• Recommendations\n\nWould you like me to proceed with PDF or CSV format?";
      } else if (messageText.toLowerCase().contains('error') || messageText.toLowerCase().contains('anomal')) {
        if (state.warnings.isNotEmpty) {
          response = "I've detected ${state.warnings.length} issue(s) in your data:\n\n${state.warnings.map((w) => '• ${w.message}').join('\n')}\n\nWould you like me to explain how to resolve these?";
        } else {
          response = "Great news! I haven't detected any significant errors or anomalies in your current data. Your measurements look consistent and accurate.";
        }
      } else {
        response = "I understand you're asking about \"$messageText\". I'm here to help with:\n\n• Data analysis and quality checks\n• Error detection and explanations\n• Report generation\n• Survey calculations\n\nHow can I assist you further?";
      }

      ref.read(appStateProvider.notifier).addMessage(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          role: MessageRole.assistant,
          content: response,
          timestamp: DateTime.now(),
        ),
      );
      
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    
    return Scaffold(
      body: Column(
        children: [
          const AppHeader(
            title: 'Atlas',
            subtitle: 'Your AI surveying assistant',
          ),
          
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: state.messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                
                final message = state.messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          
          // Quick Actions
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _quickActions.length,
              itemBuilder: (context, index) {
                final action = _quickActions[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: () => _handleSend(action.prompt),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondaryColor,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(action.icon, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          action.label,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Input Area
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      hintText: 'Ask Atlas anything...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppTheme.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppTheme.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppTheme.primaryColor),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    onSubmitted: (_) => _handleSend(),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: IconButton(
                    onPressed: _inputController.text.trim().isEmpty ? null : () => _handleSend(),
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.role == MessageRole.user;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.smart_toy,
                size: 16,
                color: AppTheme.accentColor,
              ),
            ),
            const SizedBox(width: 12),
          ],
          
          Expanded(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isUser ? AppTheme.primaryColor : AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(16).copyWith(
                      topLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                      topRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                    ),
                    border: isUser ? null : Border.all(color: AppTheme.borderColor),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: isUser ? Colors.white : Colors.black,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('HH:mm').format(message.timestamp),
                  style: TextStyle(
                    fontSize: 10,
                    color: isUser ? AppTheme.primaryColor.withOpacity(0.7) : AppTheme.mutedColor,
                  ),
                ),
              ],
            ),
          ),
          
          if (isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.person,
                size: 16,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.smart_toy,
              size: 16,
              color: AppTheme.accentColor,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16).copyWith(
                topLeft: const Radius.circular(4),
              ),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 600 + (index * 200)),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.mutedColor.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class QuickAction {
  final IconData icon;
  final String label;
  final String prompt;

  QuickAction({
    required this.icon,
    required this.label,
    required this.prompt,
  });
}