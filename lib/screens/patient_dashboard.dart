// lib/screens/patient_dashboard.dart
import 'package:flutter/material.dart';
import 'package:healthcare/screens/games_library_screen.dart';
import 'package:healthcare/screens/progress_history_screen.dart';
import 'package:healthcare/screens/profile_settings_screen.dart';
import 'package:healthcare/screens/focus_shifter_game.dart'; // Import the example game

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  int _selectedIndex = 0; // Current index for BottomNavigationBar

  // List of screens for the patient's bottom navigation
  static const List<Widget> _patientScreens = <Widget>[
    _PatientHomeContent(), // Home content for the dashboard
    GamesLibraryScreen(),
    ProgressHistoryScreen(),
    ProfileSettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Dashboard'),
        centerTitle: true,
      ),
      body: _patientScreens[_selectedIndex], // Display the selected screen
      // Bottom Navigation Bar for Patient Flow
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        // Updated: Use onSurfaceVariant for unselected item color (more Material 3 compliant)
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures all labels are shown
      ),
    );
  }
}

// Separate widget for the home content of the patient dashboard
class _PatientHomeContent extends StatelessWidget {
  const _PatientHomeContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Hello, Patient!',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Here are your assigned exercises and progress updates.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Daily Exercise Card
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              // Updated: Use surfaceContainerHighest instead of deprecated surfaceVariant
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'Your Daily Exercise',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        // Updated: Use onSurfaceVariant for text color
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Complete "Focus Shifter" today for 10 minutes.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        // Updated: Use onSurfaceVariant for text color
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to the specific game screen
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const FocusShifterGame()),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Exercise'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Progress Indicator
            Text(
              'Overall Progress',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.75, // Placeholder progress
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
              // Updated: Use surfaceContainerHighest instead of deprecated surfaceVariant
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.tertiary),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '75% Completed',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  // Updated: Use onSurfaceVariant for text color
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
