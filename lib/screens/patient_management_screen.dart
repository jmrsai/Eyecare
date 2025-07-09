// lib/screens/patient_management_screen.dart
import 'package:flutter/material.dart';
import 'package:healthcare/screens/patient_detail_screen.dart'; // Import patient detail screen

class PatientManagementScreen extends StatefulWidget {
  const PatientManagementScreen({super.key});

  @override
  State<PatientManagementScreen> createState() => _PatientManagementScreenState();
}

class _PatientManagementScreenState extends State<PatientManagementScreen> {
  // Dummy patient data for demonstration
  final List<Map<String, String>> _patients = [
    {'id': 'P001', 'name': 'Alice Johnson', 'status': 'Active', 'lastVisit': '2024-06-15'},
    {'id': 'P002', 'name': 'Bob Williams', 'status': 'Inactive', 'lastVisit': '2024-03-20'},
    {'id': 'P003', 'name': 'Charlie Brown', 'status': 'Active', 'lastVisit': '2024-07-01'},
    {'id': 'P004', 'name': 'Diana Prince', 'status': 'Active', 'lastVisit': '2024-05-10'},
    {'id': 'P005', 'name': 'Eve Adams', 'status': 'Inactive', 'lastVisit': '2023-11-22'},
  ];

  List<Map<String, String>> _filteredPatients = [];
  String _searchQuery = '';
  String? _selectedStatusFilter; // Filter by 'Active', 'Inactive', or null for all

  @override
  void initState() {
    super.initState();
    _filteredPatients = _patients; // Initialize with all patients
  }

  // Function to filter patients based on search query and status
  void _filterPatients() {
    setState(() {
      _filteredPatients = _patients.where((patient) {
        final matchesSearch = patient['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            patient['id']!.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesStatus = _selectedStatusFilter == null || patient['status'] == _selectedStatusFilter;
        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Management'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                _searchQuery = value;
                _filterPatients();
              },
              decoration: InputDecoration(
                labelText: 'Search Patients',
                hintText: 'Search by name or ID',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _filterPatients();
                    });
                  },
                )
                    : null,
              ),
            ),
          ),
          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _selectedStatusFilter == null,
                  onSelected: (selected) {
                    setState(() {
                      _selectedStatusFilter = selected ? null : _selectedStatusFilter;
                      _filterPatients();
                    });
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Active'),
                  selected: _selectedStatusFilter == 'Active',
                  onSelected: (selected) {
                    setState(() {
                      _selectedStatusFilter = selected ? 'Active' : null;
                      _filterPatients();
                    });
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Inactive'),
                  selected: _selectedStatusFilter == 'Inactive',
                  onSelected: (selected) {
                    setState(() {
                      _selectedStatusFilter = selected ? 'Inactive' : null;
                      _filterPatients();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredPatients.isEmpty
                ? Center(
              child: Text(
                'No patients found.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
                : ListView.builder(
              itemCount: _filteredPatients.length,
              itemBuilder: (context, index) {
                final patient = _filteredPatients[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        patient['name']![0],
                        style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                      ),
                    ),
                    title: Text(
                      patient['name']!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      'ID: ${patient['id']} | Status: ${patient['status']}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onTap: () {
                      // Navigate to Patient Detail Screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PatientDetailScreen(patientId: patient['id']!),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Action to add a new patient
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add New Patient Form')),
          );
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Add Patient'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        foregroundColor: Theme.of(context).colorScheme.onTertiary,
        elevation: 6.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
