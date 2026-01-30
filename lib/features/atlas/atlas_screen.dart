import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/app_state_provider.dart';
import '../../shared/widgets/app_header.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/ai_reasoning_engine.dart';
import '../../core/services/ai_service.dart';
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
  bool _hasText = false;
  bool _showSidebar = false;

  final List<QuickAction> _quickActions = [
    QuickAction(
      icon: Icons.bar_chart,
      label: 'Analyze data',
      prompt: 'Can you analyze my current field data and give me a summary?',
    ),
    QuickAction(
      icon: Icons.description,
      label: 'Generate report',
      prompt: 'Please generate a survey report for my active project.',
    ),
    QuickAction(
      icon: Icons.lightbulb_outline,
      label: 'Get recommendations',
      prompt: 'Can you give me recommendations for my project?',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_onTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(appStateProvider).activeChatSession == null) {
        ref.read(appStateProvider.notifier).setActiveChatSession(
          ref.read(appStateProvider).chatSessions.first
        );
      }
    });
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _inputController.text.trim().isNotEmpty;
    });
  }

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

  void _handleSend([String? text]) async {
    final messageText = text ?? _inputController.text;
    if (messageText.trim().isEmpty) return;

    final state = ref.read(appStateProvider);
    
    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: MessageRole.user,
      content: messageText,
      timestamp: DateTime.now(),
    );
    
    ref.read(appStateProvider.notifier).addMessageToActiveSession(userMessage);

    _inputController.clear();
    setState(() {
      _isTyping = true;
      _hasText = false;
    });
    _scrollToBottom();

    try {
      // Generate AI response using reasoning engine
      final context = {
        'activeProject': state.activeProject,
        'points': state.points,
        'gpsStatus': 'active',
        'lastAccuracy': state.points.isNotEmpty ? state.points.last.accuracy : null,
      };
      
      final response = await AIReasoningEngine.generateResponse(messageText, context);

      setState(() {
        _isTyping = false;
      });

      final assistantMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: MessageRole.assistant,
        content: response,
        timestamp: DateTime.now(),
      );
      
      ref.read(appStateProvider.notifier).addMessageToActiveSession(assistantMessage);
      
    } catch (e) {
      setState(() {
        _isTyping = false;
      });
      
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: MessageRole.assistant,
        content: "I'm currently experiencing connectivity issues. Here's some general surveying guidance based on your question.",
        timestamp: DateTime.now(),
      );
      
      ref.read(appStateProvider.notifier).addMessageToActiveSession(errorMessage);
    }
    
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    final activeSession = state.activeChatSession;
    final messages = activeSession?.messages ?? [];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atlas'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => setState(() => _showSidebar = !_showSidebar),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ref.read(appStateProvider.notifier).createNewChatSession();
              setState(() => _showSidebar = false);
            },
          ),
        ],
      ),
      body: Row(
        children: [
          if (_showSidebar) _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    itemCount: messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length && _isTyping) {
                        return _buildTypingIndicator();
                      }
                      
                      final message = messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
                ),
                
                // Quick Actions
                if (messages.isEmpty) Container(
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
                          onPressed: _hasText ? () => _handleSend() : null,
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                          style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: _hasText ? null : Colors.grey.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    final state = ref.watch(appStateProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final sidebarWidth = screenWidth > 600 ? 280.0 : screenWidth * 0.75;
    
    return Container(
      width: sidebarWidth,
      decoration: const BoxDecoration(
        color: AppTheme.cardColor,
        border: Border(
          right: BorderSide(color: AppTheme.borderColor),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                ref.read(appStateProvider.notifier).createNewChatSession();
                setState(() => _showSidebar = false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 20),
                  SizedBox(width: 8),
                  Text('New Chat'),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: state.chatSessions.length,
              itemBuilder: (context, index) {
                final session = state.chatSessions[index];
                final isActive = session.id == state.activeChatSession?.id;
                
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isActive ? AppTheme.primaryColor.withOpacity(0.1) : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(
                      session.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                        color: isActive ? AppTheme.primaryColor : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      DateFormat('MMM d, HH:mm').format(session.updatedAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.mutedColor,
                      ),
                    ),
                    trailing: session.id != '1' ? IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18),
                      onPressed: () {
                        ref.read(appStateProvider.notifier).deleteChatSession(session.id);
                      },
                    ) : null,
                    onTap: () {
                      ref.read(appStateProvider.notifier).setActiveChatSession(session);
                      setState(() => _showSidebar = false);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.role == MessageRole.user;
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth > 600 ? screenWidth * 0.7 : screenWidth * 0.85;
    
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
                    maxWidth: maxWidth,
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