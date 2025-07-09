// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:healthcare/screens/onboarding_screen.dart'; // Import onboarding screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Animation duration
      vsync: this,
    );

    // Scale animation for the logo/icon
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack, // A bouncy effect for the scale
      ),
    );

    // Color animation for the background gradient
    _colorAnimation = ColorTween(
      begin: Colors.blue.shade200, // Starting color
      end: Colors.blue.shade500,   // Ending color
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Smooth color transition
      ),
    );

    // Start the animation and navigate after completion
    _controller.forward().whenComplete(() {
      // For demonstration, we'll go to onboarding first.
      // In a real app, you'd check if the user is new/logged in
      // and navigate to OnboardingScreen or AuthScreen accordingly.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          // Apply a gradient background that animates its color
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _colorAnimation.value ?? Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.primary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent, // Make scaffold background transparent to show gradient
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Icon(
                      Icons.visibility, // Eye icon for the app logo
                      size: 120.0,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  FadeTransition(
                    opacity: _controller, // Fade in the text
                    child: Text(
                      'Visionary Care',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  FadeTransition(
                    opacity: _controller,
                    child: Text(
                      'Your Partner in Eye Health',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
