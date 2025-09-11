import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Garden',
      theme: ThemeData(useMaterial3: true),
      home: const WelcomeScreen(),
      routes: {
        '/signup': (context) => const Placeholder(), // depois substitui
        '/login': (context) => const Placeholder(),  // depois substitui
      },
    );
  }
}
