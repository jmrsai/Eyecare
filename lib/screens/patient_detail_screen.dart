// lib/screens/patient_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // For charts, add fl_chart to pubspec.yaml

class PatientDetailScreen extends StatelessWidget {
  final String patientId;

  const PatientDetailScreen({super.key, required this.patientId});

  // Dummy patient data for demonstration
  Map<String, dynamic> get _patientData {
    // In a real app, you'd fetch this from a database using patientId
    return {
      'id': patientId,
      'name': 'Alice Johnson',
      'age': 35,
      'gender': 'Female',
      'contact': 'alice.j@example.com',
      'lastVisit': '2024-06-15',
      'diagnosis': 'Myopia',
      'prescription': 'Glasses - OD: -2.00, OS: -1.75',
      'assignedGames': ['Focus Shifter', 'Tracking Trail'],
      'gameProgress': [
        {'date': '2024-06-01', 'game': 'Focus Shifter', 'score': 85, 'accuracy': 92},
        {'date': '2024-06-05', 'game': 'Tracking Trail', 'score': 78, 'accuracy': 88},
        {'date': '2024-06-10', 'game': 'Focus Shifter', 'score': 90, 'accuracy': 95},
        {'date': '2024-06-15', 'game': 'Tracking Trail', 'score': 82, 'accuracy': 90},
        {'date': '2024-06-20', 'game': 'Focus Shifter', 'score': 92, 'accuracy': 96},
      ],
      'notes': 'Patient shows good compliance with exercises. Slight improvement in visual acuity.',
    };
  }

  @override
  Widget build(BuildContext context) {
    final patient = _patientData;

    return DefaultTabController(
      length: 4, // Overview, History, Games, Notes
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    patient['name'],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Placeholder for patient photo
                      Container(
                        color: Theme.of(context).colorScheme.primary,
                        child: Icon(
                          Icons.person,
                          size: 100,
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
                        ),
                      ),
                      // Gradient overlay for better text readability
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, -0.4),
                            colors: <Color>[
                              Theme.of(context).colorScheme.primary.withOpacity(0.6),
                              Theme.of(context).colorScheme.primary.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'History'),
                      Tab(text: 'Games'),
                      Tab(text: 'Notes'),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              // Overview Tab
              _buildOverviewTab(patient, context),
              // History Tab
              _buildHistoryTab(patient, context),
              // Games Tab
              _buildGamesTab(patient, context),
              // Notes Tab
              _buildNotesTab(patient, context),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Action to assign new exercises
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Assigning new exercises...')),
            );
          },
          icon: const Icon(Icons.assignment),
          label: const Text('Assign Exercises'),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          foregroundColor: Theme.of(context).colorScheme.onTertiary,
          elevation: 6.0,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildOverviewTab(Map<String, dynamic> patient, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            context,
            title: 'Patient Information',
            children: [
              _buildInfoRow(context, 'ID:', patient['id']),
              _buildInfoRow(context, 'Age:', patient['age'].toString()),
              _buildInfoRow(context, 'Gender:', patient['gender']),
              _buildInfoRow(context, 'Contact:', patient['contact']),
              _buildInfoRow(context, 'Last Visit:', patient['lastVisit']),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            title: 'Assigned Exercises',
            children: [
              if (patient['assignedGames'].isEmpty)
                Text(
                  'No exercises assigned yet.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )
              else
                ...patient['assignedGames'].map<Widget>((game) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline, size: 18, color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(width: 8),
                      Text(
                        game,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                )).toList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(Map<String, dynamic> patient, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            context,
            title: 'Medical History',
            children: [
              _buildInfoRow(context, 'Diagnosis:', patient['diagnosis']),
              _buildInfoRow(context, 'Prescription:', patient['prescription']),
              // Add more history items as needed
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            title: 'Appointment History',
            children: [
              // Dummy appointment history
              _buildInfoRow(context, '2024-06-15:', 'Routine check-up'),
              _buildInfoRow(context, '2024-03-10:', 'Follow-up on myopia progression'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGamesTab(Map<String, dynamic> patient, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Game Progress Charts',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          // Example Bar Chart for Game Scores
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Focus Shifter Scores Over Time',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        barGroups: patient['gameProgress'].where((g) => g['game'] == 'Focus Shifter').map<BarChartGroupData>((data) {
                          return BarChartGroupData(
                            x: patient['gameProgress'].indexOf(data), // Use index for x-axis
                            barRods: [
                              BarChartRodData(
                                toY: data['score'].toDouble(),
                                color: Theme.of(context).colorScheme.primary,
                                width: 16,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          );
                        }).toList(),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                // Display dates or game attempt numbers
                                final data = patient['gameProgress'].where((g) => g['game'] == 'Focus Shifter').toList();
                                if (value.toInt() >= 0 && value.toInt() < data.length) {
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    space: 4,
                                    child: Text(
                                      data[value.toInt()]['date'].toString().substring(5), // Show month-day
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                              reservedSize: 30,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: Theme.of(context).textTheme.bodySmall,
                                );
                              },
                              reservedSize: 30,
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Example Line Chart for Accuracy
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tracking Trail Accuracy Over Time',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: patient['gameProgress'].where((g) => g['game'] == 'Tracking Trail').map<FlSpot>((data) {
                              return FlSpot(
                                patient['gameProgress'].indexOf(data).toDouble(),
                                data['accuracy'].toDouble(),
                              );
                            }).toList(),
                            isCurved: true,
                            color: Theme.of(context).colorScheme.secondary,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final data = patient['gameProgress'].where((g) => g['game'] == 'Tracking Trail').toList();
                                if (value.toInt() >= 0 && value.toInt() < data.length) {
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    space: 4,
                                    child: Text(
                                      data[value.toInt()]['date'].toString().substring(5),
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                              reservedSize: 30,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: Theme.of(context).textTheme.bodySmall,
                                );
                              },
                              reservedSize: 30,
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
                        minX: 0,
                        maxX: patient['gameProgress'].where((g) => g['game'] == 'Tracking Trail').length.toDouble() - 1,
                        minY: 0,
                        maxY: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesTab(Map<String, dynamic> patient, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            context,
            title: 'Professional Notes',
            children: [
              Text(
                patient['notes'] ?? 'No notes available.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Action to edit notes
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Editing notes...')),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Notes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper widget to build consistent info cards
  Widget _buildInfoCard(BuildContext context, {required String title, required List<Widget> children}) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  // Helper widget to build consistent info rows
  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom SliverPersistentHeaderDelegate for the TabBar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor, // Match scaffold background
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
