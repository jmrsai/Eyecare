// lib/models/patient.dart

// A basic data model for a Patient
class Patient {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String contact;
  final String lastVisit;
  final String diagnosis;
  final String prescription;
  final List<String> assignedGames;
  final List<Map<String, dynamic>> gameProgress;
  final String? notes; // Nullable notes

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.contact,
    required this.lastVisit,
    required this.diagnosis,
    required this.prescription,
    this.assignedGames = const [], // Default empty list
    this.gameProgress = const [], // Default empty list
    this.notes,
  });

  // Factory constructor to create a Patient from a JSON map (e.g., from Firestore)
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      contact: json['contact'] as String,
      lastVisit: json['lastVisit'] as String,
      diagnosis: json['diagnosis'] as String,
      prescription: json['prescription'] as String,
      assignedGames: List<String>.from(json['assignedGames'] ?? []),
      gameProgress: List<Map<String, dynamic>>.from(json['gameProgress'] ?? []),
      notes: json['notes'] as String?,
    );
  }

  // Method to convert a Patient object to a JSON map (e.g., for Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'contact': contact,
      'lastVisit': lastVisit,
      'diagnosis': diagnosis,
      'prescription': prescription,
      'assignedGames': assignedGames,
      'gameProgress': gameProgress,
      'notes': notes,
    };
  }
}
