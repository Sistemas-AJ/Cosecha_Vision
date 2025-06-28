import 'package:flutter/material.dart';
import 'dart:math';
import 'modelo_trabajo.dart'; // Importamos el modelo para tener acceso a trabajoGuardado
import 'registro_hoy_button.dart';
// Asegúrate de importar el archivo correcto si TrabajoExpandible está en otro archivo, por ejemplo:
// import 'trabajo_expandible.dart';

// Variable global para guardar los registros diarios
List<Map<String, dynamic>> registrosDiarios = [];

class DetalleMetrosTrabajadosScreen extends StatefulWidget {
  @override
  State<DetalleMetrosTrabajadosScreen> createState() => _DetalleMetrosTrabajadosScreenState();
}

// Si no tienes el widget TrabajoExpandible, agrégalo aquí como un ejemplo básico:
class TrabajoExpandible extends StatelessWidget {
  final dynamic trabajo;
  final Function(double) onAvanceGuardado;

  const TrabajoExpandible({
    Key? key,
    required this.trabajo,
    required this.onAvanceGuardado,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(trabajo.trabajo ?? ''),
        subtitle: Text('Cronograma: ${trabajo.cronograma}\nÁrea: ${trabajo.area} m²\nN° Trabajadores: ${trabajo.numTrabajadores}'),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return _DetalleTrabajoDialog(trabajo: trabajo);
              },
            );
          },
        ),
      ),
    );
  }

}

class _DetalleTrabajoDialog extends StatefulWidget {
  final dynamic trabajo;
  const _DetalleTrabajoDialog({Key? key, required this.trabajo}) : super(key: key);

  @override
  State<_DetalleTrabajoDialog> createState() => _DetalleTrabajoDialogState();
}

// Exportar correctamente la función para mostrar el diálogo
Widget showDetalleTrabajoDialog({required dynamic trabajo}) {
  return _DetalleTrabajoDialog(trabajo: trabajo);
}

class _DetalleTrabajoDialogState extends State<_DetalleTrabajoDialog> {
  final TextEditingController metrosController = TextEditingController();
  DateTime? selectedDate;
  double porcentajeTrabajado = 0.0;
  List<Map<String, dynamic>> avances = [];
  int? editIndex;

  @override
  void initState() {
    super.initState();
    // Cargar avances previos si existen (puedes asociar por trabajo)
    avances = registrosDiarios.where((r) => r['trabajoId'] == widget.trabajo.hashCode).toList();
  }

  @override
  void dispose() {
    metrosController.dispose();
    super.dispose();
  }

  double get areaTotal => double.tryParse(widget.trabajo.area.toString()) ?? 0;

  double get metrosAcumulados {
    double total = 0;
    for (var a in avances) {
      total += (a['metros'] ?? 0);
    }
    return total;
  }

  void actualizarPorcentaje() {
    setState(() {
      porcentajeTrabajado = areaTotal > 0 ? (metrosAcumulados / areaTotal).clamp(0.0, 1.0) : 0.0;
    });
  }

  Future<void> pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
      helpText: 'Selecciona la fecha del avance',
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void guardarAvance() {
    final metros = double.tryParse(metrosController.text) ?? 0;
    if (metros <= 0 || selectedDate == null) return;
    final avance = {
      'trabajoId': widget.trabajo.hashCode,
      'fecha': selectedDate,
      'metros': metros,
    };
    setState(() {
      if (editIndex != null) {
        avances[editIndex!] = avance;
        editIndex = null;
      } else {
        avances.add(avance);
      }
      // Actualizar global
      registrosDiarios.removeWhere((r) => r['trabajoId'] == widget.trabajo.hashCode && r['fecha'] == selectedDate);
      registrosDiarios.add(avance);
      metrosController.clear();
      selectedDate = null;
      actualizarPorcentaje();
    });
  }

  void editarAvance(int index) {
    setState(() {
      metrosController.text = avances[index]['metros'].toString();
      selectedDate = avances[index]['fecha'];
      editIndex = index;
    });
  }

  void eliminarAvance(int index) {
    setState(() {
      registrosDiarios.removeWhere((r) => r['trabajoId'] == widget.trabajo.hashCode && r['fecha'] == avances[index]['fecha']);
      avances.removeAt(index);
      actualizarPorcentaje();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Detalle del Trabajo'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trabajo: \n${widget.trabajo.trabajo}', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Cronograma: ${widget.trabajo.cronograma}'),
            SizedBox(height: 8),
            Text('Área: ${widget.trabajo.area} m²'),
            SizedBox(height: 8),
            Text('N° Trabajadores: ${widget.trabajo.numTrabajadores}'),
            SizedBox(height: 18),
            // Botón tipo "Registrar Día Hoy" (ahora solo abre el diálogo, la lógica se mueve afuera)
            Center(
              child: Column(
                children: [
                  RegistroHoyButton(
                    trabajo: widget.trabajo,
                    avanceHoy: avances.firstWhere(
                      (a) {
                        final hoy = DateTime.now();
                        return a['fecha'].day == hoy.day && a['fecha'].month == hoy.month && a['fecha'].year == hoy.year;
                      },
                      orElse: () => <String, dynamic>{},
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Agregar otro día'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF388E3C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                    onPressed: () async {
                      final TextEditingController metrosController = TextEditingController();
                      DateTime? selectedDate;
                      final result = await showDialog<Map<String, dynamic>>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Agregar avance de otro día'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: metrosController,
                                decoration: const InputDecoration(
                                  labelText: 'Metros trabajados',
                                  prefixIcon: Icon(Icons.square_foot),
                                ),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.date_range),
                                label: const Text('Seleccionar fecha'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  final now = DateTime.now();
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: now,
                                    firstDate: DateTime(now.year - 2),
                                    lastDate: DateTime(now.year + 2),
                                  );
                                  if (picked != null) {
                                    selectedDate = picked;
                                  }
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final metros = double.tryParse(metrosController.text) ?? 0;
                                if (metros > 0 && selectedDate != null) {
                                  Navigator.pop(context, {
                                    'trabajoId': widget.trabajo.hashCode,
                                    'fecha': selectedDate,
                                    'metros': metros,
                                  });
                                }
                              },
                              child: const Text('Guardar'),
                            ),
                          ],
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          avances.add(result);
                          registrosDiarios.add(result);
                          actualizarPorcentaje();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 18),
            // El avance del día se muestra ahora solo en el diálogo del botón azul
            SizedBox(height: 18),
            // Resumen visual del avance
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Color(0xFFf1f8e9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFFB2DFDB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total trabajado: ${metrosAcumulados.toStringAsFixed(2)} m² / Área total: ${areaTotal.toStringAsFixed(2)} m²',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF388E3C)),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Falta: ${(areaTotal - metrosAcumulados).clamp(0, areaTotal).toStringAsFixed(2)} m²',
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14),
            Text('Dibujo del área:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Container(
              width: 250,
              height: 160,
              decoration: BoxDecoration(
                color: Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFB2DFDB)),
              ),
              child: CustomPaint(
                painter: DibujoAreaPainter(points: widget.trabajo.dibujo ?? [], porcentajeTrabajado: porcentajeTrabajado),
              ),
            ),
            SizedBox(height: 18),
            if (avances.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Historial de avances:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  ...avances.map((a) {
                    int idx = avances.indexOf(a);
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 2),
                      child: ListTile(
                        title: Text('Fecha: ${a['fecha'].day.toString().padLeft(2, '0')}/${a['fecha'].month.toString().padLeft(2, '0')}/${a['fecha'].year}'),
                        subtitle: Text('Metros: ${a['metros']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => editarAvance(idx),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => eliminarAvance(idx),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cerrar'),
        ),
      ],
    );
  }
  State<DetalleMetrosTrabajadosScreen> createState() => _DetalleMetrosTrabajadosScreenState();
}

class _DetalleMetrosTrabajadosScreenState extends State<DetalleMetrosTrabajadosScreen> {
  @override
  Widget build(BuildContext context) {
    if (trabajosGuardados.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle Metros Trabajados')),
        body: const Center(child: Text('No hay actividades registradas.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle Metros Trabajados'),
        backgroundColor: const Color(0xFF388E3C),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: trabajosGuardados.length,
        itemBuilder: (context, index) {
          return TrabajoExpandible(
            trabajo: trabajosGuardados[index],
            onAvanceGuardado: (metros) {
              setState(() {
                // Aquí puedes guardar el avance en una lista global si lo deseas
              });
            },
          );
        },
      ),
    );
  }
}

// --- BOTÓN PARA REGISTRAR AVANCE DEL DÍA DE HOY ---
class RegistrarDiaHoyButton extends StatelessWidget {
  final dynamic trabajo;
  final Function(Map<String, dynamic>) onAvanceGuardado;
  final Map<String, dynamic>? avanceHoy;

  const RegistrarDiaHoyButton({
    Key? key,
    required this.trabajo,
    required this.onAvanceGuardado,
    this.avanceHoy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.today, color: Colors.white),
      label: Text(avanceHoy == null ? 'Registrar día hoy' : 'Editar avance de hoy'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF388E3C),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      ),
      onPressed: () async {
        final TextEditingController metrosController = TextEditingController(
          text: avanceHoy != null ? avanceHoy!['metros'].toString() : '',
        );
        final result = await showDialog<double>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(avanceHoy == null ? 'Registrar avance de hoy' : 'Editar avance de hoy'),
            content: TextField(
              controller: metrosController,
              decoration: const InputDecoration(
                labelText: 'Metros trabajados hoy',
                prefixIcon: Icon(Icons.square_foot),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  final metros = double.tryParse(metrosController.text) ?? 0;
                  Navigator.pop(context, metros);
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        );
        if (result != null && result > 0) {
          final hoy = DateTime.now();
          final avance = {
            'trabajoId': trabajo.hashCode,
            'fecha': DateTime(hoy.year, hoy.month, hoy.day),
            'metros': result,
          };
          onAvanceGuardado(avance);
        }
      },
    );
  }
}

// --- WIDGET DEL DIÁLOGO (CORREGIDO) ---
class DialogFiguraTerreno extends StatefulWidget {
  final List<Offset?> dibujo;
  final double areaTotal;

  const DialogFiguraTerreno({required this.dibujo, required this.areaTotal, Key? key}) : super(key: key);

  @override
  State<DialogFiguraTerreno> createState() => _DialogFiguraTerrenoState();
}

class _DialogFiguraTerrenoState extends State<DialogFiguraTerreno> {
  final TextEditingController metrosController = TextEditingController();
  double porcentajeTrabajado = 0.0;

  @override
  void dispose() {
    metrosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Registrar Avance del Terreno',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Color(0xFF388E3C))),
            const SizedBox(height: 18),
            TextField(
              controller: metrosController,
              decoration: InputDecoration(
                labelText: 'Área trabajada (m²)',
                hintText: 'Ej: 50.5',
                prefixIcon:
                    const Icon(Icons.square_foot, color: Color(0xFF388E3C)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  final metros = double.tryParse(value) ?? 0;
                  if (widget.areaTotal > 0) {
                    porcentajeTrabajado = (metros / widget.areaTotal).clamp(0.0, 1.0);
                  }
                });
              },
            ),
            const SizedBox(height: 18),
            Expanded(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: CustomPaint(
                    painter: DibujoAreaPainter(
                      points: widget.dibujo,
                      porcentajeTrabajado: porcentajeTrabajado,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text('Registrar avance'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF388E3C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                final metros = double.tryParse(metrosController.text) ?? 0;
                Navigator.pop(context, metros);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// --- PINTOR (PAINTER) CON LÓGICA DE RELLENO CORREGIDA ---
class DibujoAreaPainter extends CustomPainter {
  final List<Offset?> points;
  final double porcentajeTrabajado; // Usamos un nombre más descriptivo

  DibujoAreaPainter({required this.points, this.porcentajeTrabajado = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final validPoints = points.where((p) => p != null).cast<Offset>().toList();
    if (validPoints.length < 2) return;

    // Lógica para escalar y centrar la figura
    final double minX = validPoints.map((p) => p.dx).reduce(min);
    final double maxX = validPoints.map((p) => p.dx).reduce(max);
    final double minY = validPoints.map((p) => p.dy).reduce(min);
    final double maxY = validPoints.map((p) => p.dy).reduce(max);

    final double originalWidth = maxX - minX;
    final double originalHeight = maxY - minY;
    if (originalWidth <= 0 || originalHeight <= 0) return;

    final double scale = min(size.width / originalWidth, size.height / originalHeight);
    final double offsetX = (size.width - (originalWidth * scale)) / 2;
    final double offsetY = (size.height - (originalHeight * scale)) / 2;

    // Crear un Path (una ruta/forma) a partir de los puntos
    final path = Path();
    final firstPoint = validPoints.first;
    path.moveTo(
      (firstPoint.dx - minX) * scale + offsetX,
      (firstPoint.dy - minY) * scale + offsetY,
    );
    for (int i = 1; i < validPoints.length; i++) {
      final p = validPoints[i];
      path.lineTo(
        (p.dx - minX) * scale + offsetX,
        (p.dy - minY) * scale + offsetY,
      );
    }
    path.close(); // Es crucial cerrar el path para poder rellenarlo

    // --- Lógica de Pintado Correcta ---

    // 1. Dibuja el fondo (el área total)
    canvas.drawPath(path, Paint()..color = Colors.grey.shade300);

    // 2. Usa el path como un "molde" (clip) para rellenar el progreso
    if (porcentajeTrabajado > 0) {
      canvas.save();
      canvas.clipPath(path); // A partir de aquí, solo se dibuja DENTRO de la forma

      // Crea y dibuja el rectángulo de progreso
      final progressRect = Rect.fromLTWH(
        0,
        size.height * (1 - porcentajeTrabajado),
        size.width,
        size.height * porcentajeTrabajado,
      );
      canvas.drawRect(progressRect, Paint()..color = const Color(0xFF4CAF50));
      
      canvas.restore(); // Libera el molde para dibujar el borde
    }

    // 3. Dibuja el contorno de la figura encima de todo
    canvas.drawPath(path, Paint()
      ..color = const Color(0xFF388E3C)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(DibujoAreaPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.porcentajeTrabajado != porcentajeTrabajado;
  }
}