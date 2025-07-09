// lib/screens/role_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:healthcare/screens/patient_dashboard.dart'; // Import patient dashboard
import 'package:healthcare/screens/professional_dashboard.dart'; // Import professional dashboard

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Role'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Are you a Healthcare Professional or a Patient?',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48.0),
              // Card for Healthcare Professional
              RoleSelectionCard(
                icon: Icons.medical_services,
                title: 'Healthcare Professional',
                description: 'Manage patients, assign exercises, and track progress.',
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const ProfessionalDashboard()),
                  );
                },
              ),
              const SizedBox(height: 24.0),
              // Card for Patient
              RoleSelectionCard(
                icon: Icons.person,
                title: 'Patient',
                description: 'Access exercises, play games, and monitor your eye health.',
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const PatientDashboard()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleSelectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const RoleSelectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0, // Elevated card for better visual separation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // More rounded corners
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0), // Match InkWell border radius
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 60.0,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16.0),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
