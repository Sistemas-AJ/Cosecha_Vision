import 'package:flutter/material.dart';
import 'modelo_trabajo.dart' as modelo_trabajo;
import 'modelo_trabajo.dart'; // Importa la variable global trabajoGuardado
import 'detalle_metros_trabajados.dart' as detalle_metros_trabajados;
import 'detalle_metros_trabajados.dart'; // Para acceso directo a DibujoAreaPainter

// Variable global para guardar el trabajo registrado

class TrabajadoresScreen extends StatefulWidget {
  const TrabajadoresScreen({super.key});

  @override
  State<TrabajadoresScreen> createState() => _TrabajadoresScreenState();
}

class _TrabajadoresScreenState extends State<TrabajadoresScreen> {
  List<Offset?> _points = [];
  bool get hayDibujo => _points.isNotEmpty;

  // El controlador para el cronograma ha sido reemplazado por una variable DateTime
  DateTime? _selectedDateTime;

  final TextEditingController trabajoController = TextEditingController();
  final TextEditingController cronogramaController = TextEditingController();
  // final TextEditingController areaController = TextEditingController();
  final TextEditingController metrosController = TextEditingController();
  final TextEditingController numeroTrabajadoresController = TextEditingController();

  // Controladores para ancho y largo
  final TextEditingController anchoController = TextEditingController();
  final TextEditingController largoController = TextEditingController();

  // --- FUNCIÓN PARA SELECCIONAR FECHA Y HORA ---
  Future<void> _pickDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      helpText: 'Selecciona una fecha',
    );

    if (date == null) return; // El usuario canceló

    // Se usa 'mounted' para asegurar que el widget todavía está en el árbol.
    if (!mounted) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      helpText: 'Selecciona una hora',
    );

    if (time == null) return; // El usuario canceló

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _guardarTodo() {
    // --- VALIDACIÓN MEJORADA ---
    if (trabajoController.text.isEmpty ||
        numeroTrabajadoresController.text.isEmpty ||
        anchoController.text.isEmpty ||
        largoController.text.isEmpty ||
        _selectedDateTime == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Campos incompletos'),
          content: const Text('Por favor, complete todos los campos, incluyendo la fecha y hora, antes de guardar.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    // Formateamos el DateTime a un String para guardarlo
    final String cronograma =
        '${_selectedDateTime!.day.toString().padLeft(2, '0')}/${_selectedDateTime!.month.toString().padLeft(2, '0')}/${_selectedDateTime!.year} - ${_selectedDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}'
    ;

    // Calcular área automáticamente
    double? ancho = double.tryParse(anchoController.text);
    double? largo = double.tryParse(largoController.text);
    String areaCalculada = '';
    if (ancho != null && largo != null) {
      areaCalculada = (ancho * largo).toStringAsFixed(2);
    }


    // Guardar el trabajo en la lista global de trabajos
    modelo_trabajo.trabajosGuardados.add(
      modelo_trabajo.TrabajoRegistrado(
        trabajo: trabajoController.text,
        cronograma: cronograma,
        area: areaCalculada,
        metros: '',
        numTrabajadores: numeroTrabajadoresController.text,
        dibujo: List<Offset?>.from(_points),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Metros trabajados guardados!')),
    );

    // Limpiar campos y evitar evaluación o navegación
    setState(() {
      trabajoController.clear();
      numeroTrabajadoresController.clear();
      anchoController.clear();
      largoController.clear();
      _points.clear();
      _selectedDateTime = null;
    });
  }

  void _generarYMostrarFigura() {
    double? ancho = double.tryParse(anchoController.text);
    double? largo = double.tryParse(largoController.text);
    if (ancho != null && largo != null && ancho > 0 && largo > 0) {
      setState(() {
        _points = _generarRectangulo(ancho, largo);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Figura generada automáticamente con el ancho y largo.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingresa dimensiones válidas.')),
      );
    }
  }

  // Genera un rectángulo de ancho x largo centrado en el canvas de 500x320
  List<Offset?> _generarRectangulo(double ancho, double largo) {
    // Escalado para que quepa en el canvas
    const double canvasW = 500;
    const double canvasH = 320;
    double escala = 1.0;
    if (ancho > 0 && largo > 0) {
      double escalaW = canvasW / ancho;
      double escalaH = canvasH / largo;
      escala = escalaW < escalaH ? escalaW : escalaH;
    }
    double rectW = ancho * escala;
    double rectH = largo * escala;
    double offsetX = (canvasW - rectW) / 2;
    double offsetY = (canvasH - rectH) / 2;
    return [
      Offset(offsetX, offsetY),
      Offset(offsetX + rectW, offsetY),
      Offset(offsetX + rectW, offsetY + rectH),
      Offset(offsetX, offsetY + rectH),
      Offset(offsetX, offsetY), // Cierra el rectángulo
      null
    ];
  }

  @override
  void dispose() {
    trabajoController.dispose();
    // areaController.dispose();
    metrosController.dispose();
    numeroTrabajadoresController.dispose();
    anchoController.dispose();
    largoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Trabajo'),
        backgroundColor: const Color(0xFF388E3C),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      'Registrar Trabajo',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF388E3C),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const Divider(thickness: 1.2, color: Color(0xFFB2DFDB)),
                  const SizedBox(height: 18),
                  TextField(
                    controller: trabajoController,
                    decoration: InputDecoration(
                      labelText: 'Trabajo a realizar',
                      prefixIcon: const Icon(Icons.assignment_turned_in_rounded,
                          color: Color(0xFF388E3C)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: const Color(0xFFF1F8E9),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- WIDGET DE CRONOGRAMA REEMPLAZADO ---
                  const Text('Fecha y Hora del Cronograma', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: _pickDateTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F8E9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_month,
                                  color: Color(0xFF388E3C)),
                              const SizedBox(width: 12),
                              Text(
                                _selectedDateTime == null
                                    ? 'Seleccionar fecha y hora'
                                    : '${_selectedDateTime!.day.toString().padLeft(2, '0')}/${_selectedDateTime!.month.toString().padLeft(2, '0')}/${_selectedDateTime!.year} - ${_selectedDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _selectedDateTime == null
                                      ? Colors.grey.shade700
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Campo de área eliminado, ahora se calcula automáticamente
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: anchoController,
                          decoration: InputDecoration(
                            labelText: 'Ancho (m)',
                            hintText: 'Ej: 10',
                            prefixIcon: const Icon(Icons.swap_horiz, color: Color(0xFF388E3C)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: const Color(0xFFF1F8E9),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: largoController,
                          decoration: InputDecoration(
                            labelText: 'Largo (m)',
                            hintText: 'Ej: 15',
                            prefixIcon: const Icon(Icons.swap_vert, color: Color(0xFF388E3C)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: const Color(0xFFF1F8E9),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Campo de rendimiento por persona eliminado
                  TextField(
                    controller: numeroTrabajadoresController,
                    decoration: InputDecoration(
                      labelText: 'Número de trabajadores',
                      hintText: 'Ej: 5',
                      prefixIcon:
                          const Icon(Icons.groups, color: Color(0xFF388E3C)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: const Color(0xFFF1F8E9),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 28),
                  const Divider(thickness: 1.2, color: Color(0xFFB2DFDB)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(Icons.draw, color: Color(0xFF388E3C)),
                      SizedBox(width: 8),
                      Text('Dibujo del Área',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.auto_fix_high, color: Colors.white),
                      label: const Text('Generar Figura'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF388E3C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: _generarYMostrarFigura,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (hayDibujo)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2F1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFB2DFDB)),
                        ),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: SizedBox(
                            width: 500,
                            height: 320,
                            child: CustomPaint(
                              painter: DibujoAreaPainter(points: _points),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (!hayDibujo)
                    Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      child: const Text('No hay figura generada',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  const SizedBox(height: 36),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _guardarTodo,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text('Guardar '),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF009688),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 18),
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Eliminado el diálogo de dibujo manual. Solo se genera la figura automáticamente.
