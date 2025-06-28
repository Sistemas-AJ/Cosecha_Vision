import 'package:flutter/material.dart';

class PersonalScreen extends StatelessWidget {
  const PersonalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Personal'),
        backgroundColor: const Color(0xFF388E3C),
      ),
      body: const Center(
        child: Text('Pantalla para gestionar el personal.'),
      ),
    );
  }
}
