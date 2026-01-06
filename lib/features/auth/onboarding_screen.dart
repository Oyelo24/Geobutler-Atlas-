import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  int currentSlide = 0;
  final PageController _pageController = PageController();
  late ConfettiController _confettiController;
  late AnimationController _slideAnimationController;
  late Animation<double> _slideAnimation;

  final List<OnboardingSlide> slides = [
    OnboardingSlide(
      icon: Icons.location_on,
      title: 'Collect Field Data Smarter',
      description: 'Log coordinates, points, and notes directly from your phone. Work seamlessly in the field with high-precision data capture.',
    ),
    OnboardingSlide(
      icon: Icons.smart_toy,
      title: 'Meet Atlas, Your AI Butler',
      description: 'Atlas watches your data, detects issues, and explains results. Get real-time insights and recommendations as you survey.',
    ),
    OnboardingSlide(
      icon: Icons.description,
      title: 'From Field to Report Instantly',
      description: 'Generate clean survey summaries and reports automatically. Export to PDF or CSV with one tap.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _slideAnimationController, curve: Curves.easeOut),
    );
    _slideAnimationController.forward();
  }

  void _handleNext() {
    if (currentSlide < slides.length - 1) {
      setState(() {
        currentSlide++;
      });
      _pageController.animateToPage(
        currentSlide,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _slideAnimationController.reset();
      _slideAnimationController.forward();
    } else {
      // Trigger confetti on completion
      _confettiController.play();
      Future.delayed(const Duration(milliseconds: 500), () {
        widget.onComplete();
      });
    }
  }

  void _handleSkip() {
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppTheme.backgroundColor,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Skip button
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextButton(
                        onPressed: _handleSkip,
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: AppTheme.mutedColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Content
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          currentSlide = index;
                        });
                        _slideAnimationController.reset();
                        _slideAnimationController.forward();
                      },
                      itemCount: slides.length,
                      itemBuilder: (context, index) {
                        final slide = slides[index];
                        return AnimatedBuilder(
                          animation: _slideAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, 50 * (1 - _slideAnimation.value)),
                              child: Opacity(
                                opacity: _slideAnimation.value,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Icon with pulse animation
                                      TweenAnimationBuilder<double>(
                                        duration: const Duration(milliseconds: 800),
                                        tween: Tween(begin: 0.8, end: 1.0),
                                        builder: (context, scale, child) {
                                          return Transform.scale(
                                            scale: scale,
                                            child: Container(
                                              width: 128,
                                              height: 128,
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
                                              child: Icon(
                                                slide.icon,
                                                size: 64,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      
                                      const SizedBox(height: 40),
                                      
                                      // Title
                                      Text(
                                        slide.title,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      
                                      const SizedBox(height: 16),
                                      
                                      // Description
                                      Text(
                                        slide.description,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: AppTheme.mutedColor,
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
              
                  // Bottom section
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        // Progress indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(slides.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentSlide = index;
                                });
                                _pageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                                _slideAnimationController.reset();
                                _slideAnimationController.forward();
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                height: 8,
                                width: index == currentSlide ? 32 : 8,
                                decoration: BoxDecoration(
                                  color: index == currentSlide
                                      ? AppTheme.primaryColor
                                      : AppTheme.mutedColor.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            );
                          }),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Next button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _handleNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currentSlide == slides.length - 1 ? 'Get Started' : 'Next',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.chevron_right, size: 20),
                              ],
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
          
          // Confetti overlay
          Positioned.fill(
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: -1.57, // radians - upward direction
              emissionFrequency: 0.1,
              numberOfParticles: 30,
              maxBlastForce: 50,
              minBlastForce: 20,
              gravity: 0.2,
              shouldLoop: false,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                AppTheme.primaryColor,
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _confettiController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }
}

class OnboardingSlide {
  final IconData icon;
  final String title;
  final String description;

  OnboardingSlide({
    required this.icon,
    required this.title,
    required this.description,
  });
}