import 'package:flutter/material.dart';
import 'modelo_trabajo.dart';

class DetalleMetrosTrabajadosScreen extends StatelessWidget {
  final dynamic trabajo;
  const DetalleMetrosTrabajadosScreen({Key? key, required this.trabajo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle Metros Trabajados'),
        backgroundColor: const Color(0xFF388E3C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Datos del Trabajo Registrado',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF388E3C)),
                  ),
                  const SizedBox(height: 18),
                  Text('Trabajo:  {trabajo.trabajo}', style: const TextStyle(fontSize: 18)),
                  Text('Cronograma:  {trabajo.cronograma}', style: const TextStyle(fontSize: 18)),
                  Text('Área de trabajo:  {trabajo.area} m²', style: const TextStyle(fontSize: 18)),
                  Text('Metros de trabajo:  {trabajo.metros} m', style: const TextStyle(fontSize: 18)),
                  Text('Nº Trabajadores:  {trabajo.numTrabajadores}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 24),
                  const Text('Dibujo del área:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFB2DFDB)),
                    ),
                    child: CustomPaint(
                      painter: DibujoAreaPainter(trabajo.dibujo),
                    ),
                  ),
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
                  const SizedBox(height: 24),
                  Text(
                    evaluarRendimiento(
                      areaDiariaObjetivo: double.tryParse(trabajo.area) ?? 0,
                      cantidadPersonas: int.tryParse(trabajo.numTrabajadores) ?? 0,
                      rendimientoPorPersona: (double.tryParse(trabajo.area) ?? 0) /
                          ((int.tryParse(trabajo.numTrabajadores) ?? 1) == 0
                              ? 1
                              : int.tryParse(trabajo.numTrabajadores)!),
                    ),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DibujoAreaPainter extends CustomPainter {
  final List<Offset?> points;
  DibujoAreaPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF388E3C)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DibujoAreaPainter oldDelegate) =>
      oldDelegate.points != points;
}

String evaluarRendimiento({
  required double areaDiariaObjetivo,
  required int cantidadPersonas,
  required double rendimientoPorPersona,
}) {
  double areaTotalTrabajada = cantidadPersonas * rendimientoPorPersona;

  if (areaTotalTrabajada >= areaDiariaObjetivo) {
    return "OK: Personal suficiente para cubrir el área diaria.";
  } else {
    int personasFaltantes = (areaDiariaObjetivo / rendimientoPorPersona).ceil() - cantidadPersonas;
    return "Atención: Faltan $personasFaltantes personas para cubrir el área diaria.";
  }
}
