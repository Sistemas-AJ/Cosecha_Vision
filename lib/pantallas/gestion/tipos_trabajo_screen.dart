import 'package:flutter/material.dart';

class TiposTrabajoScreen extends StatelessWidget {
  const TiposTrabajoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipos de Trabajo'),
        backgroundColor: const Color(0xFF388E3C),
      ),
      body: const Center(
        child: Text('Pantalla para gestionar los tipos de trabajo.'),
      ),
    );
  }
}
