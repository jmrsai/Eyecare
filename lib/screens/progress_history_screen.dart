// lib/screens/progress_history_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // For charts, add fl_chart to pubspec.yaml

class ProgressHistoryScreen extends StatefulWidget {
  const ProgressHistoryScreen({super.key});

  @override
  State<ProgressHistoryScreen> createState() => _ProgressHistoryScreenState();
}

class _ProgressHistoryScreenState extends State<ProgressHistoryScreen> {
  // Dummy data for game progress
  final List<Map<String, dynamic>> _gameData = [
    {'date': '2024-06-01', 'game': 'Focus Shifter', 'score': 85, 'accuracy': 92},
    {'date': '2024-06-02', 'game': 'Tracking Trail', 'score': 78, 'accuracy': 88},
    {'date': '2024-06-03', 'game': 'Focus Shifter', 'score': 88, 'accuracy': 94},
    {'date': '2024-06-04', 'game': 'Peripheral Vision Blaster', 'score': 60, 'accuracy': 70},
    {'date': '2024-06-05', 'game': 'Tracking Trail', 'score': 82, 'accuracy': 90},
    {'date': '2024-06-06', 'game': 'Focus Shifter', 'score': 90, 'accuracy': 95},
    {'date': '2024-06-07', 'game': 'Focus Shifter', 'score': 92, 'accuracy': 96},
    {'date': '2024-06-08', 'game': 'Tracking Trail', 'score': 85, 'accuracy': 91},
    {'date': '2024-06-09', 'game': 'Peripheral Vision Blaster', 'score': 65, 'accuracy': 75},
    {'date': '2024-06-10', 'game': 'Focus Shifter', 'score': 95, 'accuracy': 98},
  ];

  String _selectedChartType = 'Score'; // 'Score' or 'Accuracy'
  String _selectedGameFilter = 'All Games'; // Filter by specific game
  String _selectedTimeRange = 'Weekly'; // 'Daily', 'Weekly', 'Monthly'

  List<Map<String, dynamic>> get _filteredData {
    List<Map<String, dynamic>> data = _gameData;

    // Filter by game
    if (_selectedGameFilter != 'All Games') {
      data = data.where((item) => item['game'] == _selectedGameFilter).toList();
    }

    // Sort by date to ensure correct chart plotting
    data.sort((a, b) => a['date'].compareTo(b['date']));

    return data;
  }

  @override
  Widget build(BuildContext context) {
    // Get unique game names for filter dropdown
    final List<String> gameNames = ['All Games'] + _gameData.map((e) => e['game'] as String).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress History'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Performance Over Time',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            // Chart Type Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SegmentedButton<String>(
                  segments: const <ButtonSegment<String>>[
                    ButtonSegment<String>(
                      value: 'Score',
                      label: Text('Score'),
                      icon: Icon(Icons.score),
                    ),
                    ButtonSegment<String>(
                      value: 'Accuracy',
                      label: Text('Accuracy'),
                      icon: Icon(Icons.check_circle_outline),
                    ),
                  ],
                  selected: <String>{_selectedChartType},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _selectedChartType = newSelection.first;
                    });
                  },
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    selectedForegroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Game Filter Dropdown
            DropdownButtonFormField<String>(
              value: _selectedGameFilter,
              decoration: InputDecoration(
                labelText: 'Filter by Game',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              items: gameNames.map((String game) {
                return DropdownMenuItem<String>(
                  value: game,
                  child: Text(game),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGameFilter = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            // Time Range Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SegmentedButton<String>(
                  segments: const <ButtonSegment<String>>[
                    ButtonSegment<String>(
                      value: 'Daily',
                      label: Text('Daily'),
                    ),
                    ButtonSegment<String>(
                      value: 'Weekly',
                      label: Text('Weekly'),
                    ),
                    ButtonSegment<String>(
                      value: 'Monthly',
                      label: Text('Monthly'),
                    ),
                  ],
                  selected: <String>{_selectedTimeRange},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _selectedTimeRange = newSelection.first;
                    });
                  },
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                    selectedForegroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Chart Display Area
            _filteredData.isEmpty
                ? Center(
              child: Text(
                'No data available for the selected filters.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
                : Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 250, // Fixed height for the chart
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: _filteredData.length.toDouble() - 1,
                      minY: 0,
                      maxY: 100, // Scores/Accuracy are usually 0-100
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant, width: 1),
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 && value.toInt() < _filteredData.length) {
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  space: 4,
                                  child: Text(
                                    _filteredData[value.toInt()]['date'].toString().substring(5), // Month-Day
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: Theme.of(context).textTheme.bodySmall,
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _filteredData.asMap().entries.map((entry) {
                            int index = entry.key;
                            Map<String, dynamic> dataPoint = entry.value;
                            return FlSpot(
                              index.toDouble(),
                              _selectedChartType == 'Score'
                                  ? dataPoint['score'].toDouble()
                                  : dataPoint['accuracy'].toDouble(),
                            );
                          }).toList(),
                          isCurved: true,
                          color: Theme.of(context).colorScheme.primary,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Detailed Activity Log',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            // List of recent activities
            _filteredData.isEmpty
                ? Center(
              child: Text(
                'No recent activities.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
                : ListView.builder(
              shrinkWrap: true, // Important for nested list views
              physics: const NeverScrollableScrollPhysics(), // Disable scrolling for nested list
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                final activity = _filteredData[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  elevation: 1.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  child: ListTile(
                    leading: const Icon(Icons.gamepad), // Added const
                    title: Text(
                      '${activity['game']}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      'Date: ${activity['date']} | Score: ${activity['score']} | Accuracy: ${activity['accuracy']}%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
