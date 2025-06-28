import 'package:flutter/material.dart';

class MetrosTrabajadosScreen extends StatelessWidget {
  final String trabajo;
  final String cronograma;
  final String area;
  final String metros;
  final String numTrabajadores;
  final int puntosDibujo;

  const MetrosTrabajadosScreen({
    super.key,
    required this.trabajo,
    required this.cronograma,
    required this.area,
    required this.metros,
    required this.numTrabajadores,
    required this.puntosDibujo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metros Trabajados'),
        backgroundColor: const Color(0xFF388E3C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Datos del Trabajo Registrado',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF388E3C)),
                ),
                const SizedBox(height: 18),
                Text('Trabajo: $trabajo', style: const TextStyle(fontSize: 18)),
                Text('Cronograma: $cronograma', style: const TextStyle(fontSize: 18)),
                Text('Área de trabajo: $area m²', style: const TextStyle(fontSize: 18)),
                Text('Metros de trabajo: $metros m', style: const TextStyle(fontSize: 18)),
                Text('Nº Trabajadores: $numTrabajadores', style: const TextStyle(fontSize: 18)),
                Text('Puntos del dibujo: $puntosDibujo', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    label: const Text('Volver'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF388E3C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
