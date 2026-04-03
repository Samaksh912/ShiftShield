import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../widgets/primary_button.dart';
import 'slide_1_dark.dart';
import 'slide_2_dark.dart';
import 'slide_3_dark.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRoutes.login);
    }
  }

  void _skipOnboarding() {
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Stack(
        children: [
          // The sliding content
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              Slide1Dark(),
              Slide2Dark(),
              Slide3Dark(),
            ],
          ),
          
          // Fixed Top Header (No glass blur as per image, just text)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "HORIZON",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: _skipOnboarding,
                      child: Text(
                        "SKIP",
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: context.colors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Fixed Bottom Controls Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    context.colors.surface,
                    context.colors.surface.withAlpha(230),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.6, 1.0],
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start, // Left aligned dots
                  children: [
                    // Progress Indicator (Left Aligned for Asymmetry)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(3, (index) {
                        final isActive = _currentPage == index;
                        return Container(
                          margin: EdgeInsets.only(right: 8),
                          height: 4,
                          width: isActive ? 32 : 8,
                          decoration: BoxDecoration(
                            color: isActive ? context.colors.primary : context.colors.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: isActive ? [
                              BoxShadow(
                                color: context.colors.primary.withAlpha(76), // ~0.3 opacity
                                blurRadius: 8,
                              )
                            ] : [],
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 32),
                    // Primary Action
                    PrimaryButton(
                      // Real app context: If it's the 1st slide mockup shows 'GET STARTED' 
                      // but typically this advances. We defaults to NEXT unless slide 3
                      text: "GET STARTED", 
                      icon: Icons.arrow_forward,
                      onPressed: _nextPage,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
