// lib/screens/my_exercises_screen.dart
import 'package:flutter/material.dart';
import 'package:healthcare/screens/focus_shifter_game.dart'; // Import the example game

class MyExercisesScreen extends StatefulWidget {
  const MyExercisesScreen({super.key});

  @override
  State<MyExercisesScreen> createState() => _MyExercisesScreenState();
}

class _MyExercisesScreenState extends State<MyExercisesScreen> {
  // Dummy data for assigned routines/exercises
  final List<Map<String, dynamic>> _assignedRoutines = [
    {
      'id': 'R001',
      'name': 'Daily Eye Warm-up',
      'description': 'A quick routine to prepare your eyes for the day.',
      'progress': 0.75, // 75% complete
      'exercises': [
        {'name': 'Eye Rolls', 'duration': '2 min', 'completed': true},
        {'name': 'Near/Far Focus', 'duration': '3 min', 'completed': true},
        {'name': 'Palming', 'duration': '1 min', 'completed': false},
      ],
    },
    {
      'id': 'R002',
      'name': 'Focus Improvement Routine',
      'description': 'Exercises designed to enhance your focusing ability.',
      'progress': 0.30,
      'exercises': [
        {'name': 'Focus Shifter Game', 'duration': '10 min', 'completed': false},
        {'name': 'Pencil Push-ups', 'duration': '5 min', 'completed': false},
      ],
    },
    {
      'id': 'R003',
      'name': 'Tracking & Peripheral Drill',
      'description': 'Improve your eye tracking and peripheral awareness.',
      'progress': 1.0, // 100% complete
      'exercises': [
        {'name': 'Tracking Trail Game', 'duration': '8 min', 'completed': true},
        {'name': 'Peripheral Vision Blaster', 'duration': '7 min', 'completed': true},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Exercises & Routines'),
        centerTitle: true,
      ),
      body: _assignedRoutines.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_turned_in_outlined, size: 80, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              'No exercises assigned yet!',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Your healthcare professional will assign routines here.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _assignedRoutines.length,
        itemBuilder: (context, index) {
          final routine = _assignedRoutines[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.fitness_center,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              title: Text(
                routine['name'],
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    routine['description'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: routine['progress'],
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                    // Updated: Use surfaceContainerHighest instead of deprecated surfaceVariant
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.tertiary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(routine['progress'] * 100).toInt()}% Completed',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              children: [
                // List of individual exercises within the routine
                ...routine['exercises'].map<Widget>((exercise) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: exercise['completed'],
                          onChanged: (bool? newValue) {
                            // In a real app, update the completion status in your data source
                            setState(() {
                              exercise['completed'] = newValue!;
                              // Recalculate routine progress here if needed
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${exercise['name']} ${newValue! ? 'completed!' : 'unmarked.'}')),
                            );
                          },
                          activeColor: Theme.of(context).colorScheme.secondary,
                        ),
                        Expanded(
                          child: Text(
                            '${exercise['name']} (${exercise['duration']})',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              decoration: exercise['completed'] ? TextDecoration.lineThrough : null,
                              color: exercise['completed']
                                  ? Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7)
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        if (exercise['name'].contains('Game')) // Add play button for games
                          IconButton(
                            icon: Icon(Icons.play_arrow, color: Theme.of(context).colorScheme.primary),
                            onPressed: () {
                              if (exercise['name'] == 'Focus Shifter Game') {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const FocusShifterGame()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Launching ${exercise['name']}... (Game not implemented yet)')),
                                );
                              }
                            },
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
