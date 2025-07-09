// lib/screens/focus_shifter_game.dart
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui'; // For ImageFilter

class FocusShifterGame extends StatefulWidget {
  const FocusShifterGame({super.key});

  @override
  State<FocusShifterGame> createState() => _FocusShifterGameState();
}

class _FocusShifterGameState extends State<FocusShifterGame> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blurAnimation;
  late Animation<double> _scaleAnimation;

  Offset _targetPosition = Offset.zero;
  bool _isTargetVisible = false;
  int _score = 0;
  int _taps = 0;
  int _hits = 0;
  int _round = 0;
  final int _maxRounds = 10; // Number of targets to appear
  bool _gameStarted = false;
  bool _gameEnded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Duration for blur/focus cycle
    )..addListener(() {
      setState(() {}); // Rebuild to apply animation values
    });

    _blurAnimation = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut), // Blur to clear
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut), // Scale up as it focuses
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller to prevent memory leaks
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _score = 0;
      _taps = 0;
      _hits = 0;
      _round = 0;
      _gameStarted = true;
      _gameEnded = false;
    });
    _showNextTarget();
  }

  void _showNextTarget() {
    if (_round >= _maxRounds) {
      _endGame();
      return;
    }

    setState(() {
      _isTargetVisible = true;
      _round++;
    });

    // Generate random position for the target
    final random = Random();
    final size = MediaQuery.of(context).size;
    // Ensure target is within safe bounds and not too close to edges
    _targetPosition = Offset(
      random.nextDouble() * (size.width - 100) + 50,
      random.nextDouble() * (size.height - 200) + 100, // Account for app bar/bottom bar
    );

    _controller.reset();
    _controller.forward().whenComplete(() {
      // After animation completes, target stays visible for a short duration
      Future.delayed(const Duration(seconds: 1), () {
        if (_isTargetVisible) { // If not tapped, hide it
          setState(() {
            _isTargetVisible = false;
          });
          _showNextTarget();
        }
      });
    });
  }

  void _handleTap(TapDownDetails details) {
    if (!_gameStarted || _gameEnded || !_isTargetVisible) return;

    setState(() {
      _taps++;
    });

    // Check if the tap was on the target
    // We need to consider the actual position of the target, not just the raw tap
    // A simple way is to check if the tap is within a certain radius of the target's center.
    final double targetRadius = 40.0 * _scaleAnimation.value; // Half of 80 width
    final double distance = (_targetPosition - details.localPosition).distance;

    if (distance <= targetRadius) {
      setState(() {
        _hits++;
        _score += 10; // Increase score for a hit
        _isTargetVisible = false; // Hide target immediately on hit
      });
      _controller.stop(); // Stop current animation
      _showNextTarget(); // Show next target
    } else {
      // Missed tap
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Missed! Try again.'), // Added const
          duration: const Duration(milliseconds: 500),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _endGame() {
    setState(() {
      _gameEnded = true;
      _gameStarted = false;
      _isTargetVisible = false;
    });
    _controller.stop(); // Ensure animation stops
    _showGameSummary();
  }

  void _showGameSummary() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          title: const Text('Game Over!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Your Score: $_score'),
              Text('Targets Hit: $_hits / $_round'),
              Text('Accuracy: ${(_taps > 0 ? (_hits / _taps * 100) : 0).toStringAsFixed(1)}%'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startGame(); // Option to play again
              },
              child: const Text('Play Again'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to Games Library
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Shifter Game'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTapDown: _handleTap,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(context).colorScheme.surface, // Game background
          child: Stack(
            children: [
              // Game Instructions / Start Screen
              if (!_gameStarted && !_gameEnded)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lens_outlined,
                        size: 100,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Focus Shifter',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Tap the circle when it comes into clear focus. Improve your eye accommodation!',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: _startGame,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Game'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.tertiary,
                          foregroundColor: Theme.of(context).colorScheme.onTertiary,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 6.0,
                        ),
                      ),
                    ],
                  ),
                ),
              // Game UI (Score, Round)
              if (_gameStarted && !_gameEnded)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text('Score: $_score'),
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                      ),
                      Chip(
                        label: Text('Round: $_round / $_maxRounds'),
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
                      ),
                    ],
                  ),
                ),
              // The animated target
              if (_isTargetVisible && _gameStarted && !_gameEnded)
                Positioned(
                  left: _targetPosition.dx - 40, // Center the target
                  top: _targetPosition.dy - 40,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _controller.value, // Fade in the target
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: _blurAnimation.value,
                          sigmaY: _blurAnimation.value,
                        ),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.adjust, // Fixed: Replaced Icons.target with Icons.adjust
                              color: Theme.of(context).colorScheme.onSecondary,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
