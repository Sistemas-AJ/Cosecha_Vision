import 'package:flutter/material.dart';

class TrabajadorDetalleScreen extends StatelessWidget {
  const TrabajadorDetalleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Trabajador'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nombre:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextFormField(decoration: const InputDecoration(hintText: 'Ingrese el nombre')),
            const SizedBox(height: 16),
            const Text('DNI:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextFormField(decoration: const InputDecoration(hintText: 'Ingrese el DNI')),
            const SizedBox(height: 16),
            const Text('Cargo:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextFormField(decoration: const InputDecoration(hintText: 'Ingrese el cargo')),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text('Horas trabajadas:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextFormField(decoration: const InputDecoration(hintText: 'Ej: 40')),
            const SizedBox(height: 16),
            const Text('Cronograma semanal:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextFormField(decoration: const InputDecoration(hintText: 'Ej: Lunes a Viernes, 8am-5pm')),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text('Observaciones:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextFormField(
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'Ingrese observaciones'),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text('Documentos adjuntos:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Subir documento'),
            ),
          ],
        ),
      ),
    );
  }
}

