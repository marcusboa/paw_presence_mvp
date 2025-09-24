import 'package:flutter/material.dart';

// Import our screens
import 'screens/splash_screen.dart';   // [NEW] Import Splash Screen

void main() {
  runApp(const MyApp());
}

enum UserRole { petSitter, petOwner }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paw Presence MVP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),  // [NEW] Set SplashScreen as entry point
    );
  }
}
