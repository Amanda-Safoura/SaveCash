import 'package:flutter/material.dart';
import 'dart:async';

import 'package:save_cash/views/connexion.dart';
import 'package:save_cash/views/inscription.dart'; // Pour utiliser Timer
import 'package:save_cash/views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Launch(),
      routes: {
        '/inscription': (context) => const Inscription(),
        '/connexion': (context) => const Connexion(),
      },
    );
  }
}

class Launch extends StatefulWidget {
  const Launch({super.key});

  @override
  _LaunchState createState() => _LaunchState();
}

class _LaunchState extends State<Launch> {
  @override
  void initState() {
    super.initState();
    // Rediriger après 2 secondes
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/connexion');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAEFF7F), // Couleur de fond verte claire
      body: Center(
        child: Image.asset(
          'assets/logo.png', // Assure-toi que l'image est dans le dossier 'assets'
          width: 350,
          height: 350,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
