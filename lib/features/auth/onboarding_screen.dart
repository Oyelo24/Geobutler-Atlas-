import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentSlide = 0;
  final PageController _pageController = PageController();

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
    } else {
      widget.onComplete();
    }
  }

  void _handleSkip() {
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                  },
                  itemCount: slides.length,
                  itemBuilder: (context, index) {
                    final slide = slides[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon
                          Container(
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
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
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