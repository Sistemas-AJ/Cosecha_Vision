import 'package:flutter/material.dart';

class RegistroHoyButton extends StatelessWidget {
  final dynamic trabajo;
  final Map<String, dynamic>? avanceHoy;

  const RegistroHoyButton({
    Key? key,
    required this.trabajo,
    this.avanceHoy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.info_outline, color: Colors.white),
      label: const Text('Registro de hoy'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Registro de hoy'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Trabajo: \n${trabajo.trabajo}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                if (avanceHoy != null && avanceHoy!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Avance de hoy:', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('${avanceHoy!['metros']} m²', style: const TextStyle(fontSize: 16)),
                      Text('Fecha: ${avanceHoy!['fecha'] != null ? (avanceHoy!['fecha'] is DateTime ? (avanceHoy!['fecha'] as DateTime).day.toString().padLeft(2, '0') + "/" + (avanceHoy!['fecha'] as DateTime).month.toString().padLeft(2, '0') + "/" + (avanceHoy!['fecha'] as DateTime).year.toString() : avanceHoy!['fecha'].toString()) : ''}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                if (avanceHoy == null || avanceHoy!.isEmpty)
                  const Text('No hay avance registrado para hoy.', style: TextStyle(fontSize: 16)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
      },
    );
  }
}
