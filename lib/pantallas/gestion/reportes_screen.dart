import 'package:flutter/material.dart';

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes y Desempeño'),
        backgroundColor: const Color(0xFF388E3C),
      ),
      body: const Center(
        child: Text('Pantalla para reportes y estadísticas de desempeño.'),
      ),
    );
  }
}
