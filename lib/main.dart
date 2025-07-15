// lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the color scheme for Material 3.
    // Using ColorScheme.fromSeed for dynamic color generation based on a primary seed color.
    final ColorScheme lightColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blueAccent, // A vibrant blue for eye care theme
      brightness: Brightness.light,
    );

    final ColorScheme darkColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blueAccent,
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'Visionary Care',
      // Apply Material 3 theme data
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
        // Define text theme using Google Fonts for 'Inter'
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: lightColorScheme.primary,
          foregroundColor: lightColorScheme.onPrimary,
          elevation: 4.0, // Add a subtle shadow
        ),
        // Corrected: Use ButtonThemeData for buttonTheme
        buttonTheme: const ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)), // Rounded corners for buttons
          ),
        ),
        // Corrected: Use CardThemeData for cardTheme
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners for cards
          ),
          elevation: 2.0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners for input fields
          ),
          filled: true,
          // Updated: Use surfaceContainerHighest instead of deprecated surfaceVariant
          fillColor: lightColorScheme.surfaceContainerHighest.withOpacity(0.2),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
          elevation: 4.0,
        ),
        // Corrected: Use ButtonThemeData for buttonTheme
        buttonTheme: const ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
        ),
        // Corrected: Use CardThemeData for cardTheme
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 2.0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          // Updated: Use surfaceContainerHighest instead of deprecated surfaceVariant
          fillColor: darkColorScheme.surfaceContainerHighest.withOpacity(0.2),
        ),
      ),
      home: const SplashScreen(), // Set SplashScreen as the initial route
    );
  }
}
