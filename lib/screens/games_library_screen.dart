// lib/screens/games_library_screen.dart (Updated)
import 'package:flutter/material.dart';
import 'package:healthcare/screens/focus_shifter_game.dart'; // Import the example game

class GamesLibraryScreen extends StatefulWidget {
  const GamesLibraryScreen({super.key});

  @override
  State<GamesLibraryScreen> createState() => _GamesLibraryScreenState();
}

class _GamesLibraryScreenState extends State<GamesLibraryScreen> {
  // Dummy data for games
  final List<Map<String, String>> _games = [
    {
      'id': 'G001',
      'name': 'Focus Shifter',
      'description': 'Improve your eye focusing ability.',
      'type': 'Focus',
      'difficulty': 'Easy',
      'image': 'assets/game_focus_shifter.png', // Placeholder
    },
    {
      'id': 'G002',
      'name': 'Tracking Trail',
      'description': 'Enhance smooth pursuit eye movements.',
      'type': 'Tracking',
      'difficulty': 'Medium',
      'image': 'assets/game_tracking_trail.png',
    },
    {
      'id': 'G003',
      'name': 'Peripheral Vision Blaster',
      'description': 'Expand your peripheral awareness.',
      'type': 'Peripheral Vision',
      'difficulty': 'Hard',
      'image': 'assets/game_peripheral_blaster.png',
    },
    {
      'id': 'G004',
      'name': 'Color Matcher',
      'description': 'Improve color discrimination and attention.',
      'type': 'Cognitive',
      'difficulty': 'Easy',
      'image': 'assets/game_color_matcher.png',
    },
    {
      'id': 'G005',
      'name': 'Eye Yoga Guide',
      'description': 'Relax and stretch your eye muscles.',
      'type': 'Relaxation',
      'difficulty': 'Easy',
      'image': 'assets/game_eye_yoga.png',
    },
  ];

  List<Map<String, String>> _filteredGames = [];
  String? _selectedFilterType; // Filter by game type

  @override
  void initState() {
    super.initState();
    _filteredGames = _games; // Initialize with all games
  }

  // Function to filter games by type
  void _filterGames() {
    setState(() {
      _filteredGames = _games.where((game) {
        return _selectedFilterType == null || game['type'] == _selectedFilterType;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get unique game types for filter chips
    final List<String> gameTypes = _games.map((game) => game['type']!).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Games Library'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Chips for game types
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: _selectedFilterType == null,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilterType = selected ? null : _selectedFilterType;
                        _filterGames();
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ...gameTypes.map((type) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(type),
                      selected: _selectedFilterType == type,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilterType = selected ? type : null;
                          _filterGames();
                        });
                      },
                    ),
                  )),
                ],
              ),
            ),
          ),
          Expanded(
            child: _filteredGames.isEmpty
                ? Center(
              child: Text(
                'No games found for this filter.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two cards per row
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.8, // Adjust aspect ratio for card height
              ),
              itemCount: _filteredGames.length,
              itemBuilder: (context, index) {
                final game = _filteredGames[index];
                return GameCard(
                  game: game,
                  onTap: () {
                    // Navigate to the specific game screen
                    if (game['id'] == 'G001') {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const FocusShifterGame()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Launching ${game['name']}... (Game not implemented yet)')),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final Map<String, String> game;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.game,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      clipBehavior: Clip.antiAlias, // Ensures content is clipped to card shape
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                // Updated: Use surfaceContainerHighest instead of deprecated surfaceVariant
                color: Theme.of(context).colorScheme.surfaceContainerHighest, // Placeholder for image
                child: Center(
                  child: Icon(
                    Icons.gamepad, // Generic game icon
                    size: 60,
                    // Updated: Use onSurfaceVariant for icon color
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
                  ),
                ),
                // In a real app, use Image.asset(game['image']!, fit: BoxFit.cover)
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game['name']!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    game['description']!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text(game['type']!),
                        labelStyle: Theme.of(context).textTheme.labelSmall,
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        side: BorderSide.none,
                      ),
                      Chip(
                        label: Text(game['difficulty']!),
                        labelStyle: Theme.of(context).textTheme.labelSmall,
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        side: BorderSide.none,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
