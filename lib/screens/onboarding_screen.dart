// lib/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:healthcare/screens/auth_screen.dart'; // Import authentication screen

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Define onboarding pages with content
  final List<Map<String, String>> onboardingPages = [
    {
      'image': 'assets/onboarding1.png', // Placeholder, ideally use a real asset
      'title': 'Personalized Eye Care',
      'description': 'Get tailored exercises and insights from professionals.',
    },
    {
      'image': 'assets/onboarding2.png',
      'title': 'Engaging Eye Games',
      'description': 'Improve your vision with fun and interactive exercises.',
    },
    {
      'image': 'assets/onboarding3.png',
      'title': 'Track Your Progress',
      'description': 'Monitor your eye health journey with detailed charts.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingPages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPage(
                imagePath: onboardingPages[index]['image']!,
                title: onboardingPages[index]['title']!,
                description: onboardingPages[index]['description']!,
              );
            },
          ),
          // Dots indicator for page navigation
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingPages.length,
                    (index) => buildDot(index, context),
              ),
            ),
          ),
          // Skip/Next/Get Started Button
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage < onboardingPages.length - 1)
                  TextButton(
                    onPressed: () {
                      _pageController.jumpToPage(onboardingPages.length - 1);
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                Expanded(child: Container()), // Spacer
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage < onboardingPages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // Navigate to authentication screen after onboarding
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const AuthScreen()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 4.0,
                  ),
                  child: Text(
                    _currentPage == onboardingPages.length - 1 ? 'Get Started' : 'Next',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build the dots for the page indicator
  Widget buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Placeholder for image - in a real app, you'd use Image.asset(imagePath)
          // For now, using an icon to represent the image
          Icon(
            Icons.remove_red_eye, // Example icon
            size: 150,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 48),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
