import 'package:flutter/material.dart';

class RegistrarJornadaScreen extends StatelessWidget {
  const RegistrarJornadaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Jornada'),
        backgroundColor: const Color(0xFF388E3C),
      ),
      body: const Center(
        child: Text('Pantalla para registrar la jornada diaria del personal.'),
      ),
    );
  }
}
