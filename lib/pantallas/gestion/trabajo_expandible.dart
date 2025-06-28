import 'package:flutter/material.dart';
import 'modelo_trabajo.dart';
import 'detalle_metros_trabajados.dart';

class TrabajoExpandible extends StatefulWidget {
  final TrabajoRegistrado trabajo;
  final void Function(double metros)? onAvanceGuardado;

  const TrabajoExpandible({Key? key, required this.trabajo, this.onAvanceGuardado}) : super(key: key);

  @override
  State<TrabajoExpandible> createState() => _TrabajoExpandibleState();
}

class _TrabajoExpandibleState extends State<TrabajoExpandible> {
  double? metrosTrabajados;
  bool guardado = false;
  bool expandido = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        initiallyExpanded: expandido,
        onExpansionChanged: (val) => setState(() => expandido = val),
        title: Text(widget.trabajo.trabajo, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Cronograma: ${widget.trabajo.cronograma}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Área de trabajo: ${widget.trabajo.area} m²', style: const TextStyle(fontSize: 16)),
                Text('Nº Trabajadores: ${widget.trabajo.numTrabajadores}', style: const TextStyle(fontSize: 16)),
                if (metrosTrabajados != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text('Metros trabajados hoy: \\${metrosTrabajados!.toStringAsFixed(2)} m²',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2F1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFB2DFDB)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomPaint(
                      painter: DibujoAreaPainter(
                        points: widget.trabajo.dibujo,
                        porcentajeTrabajado: (metrosTrabajados ?? 0) / (double.tryParse(widget.trabajo.area) ?? 1),
                      ),
                      size: Size.infinite,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (!guardado)
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.open_in_full, color: Colors.white),
                      label: const Text('Ver y Registrar Avance'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF388E3C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        final resultado = await showDialog<double>(
                          context: context,
                          builder: (context) {
                            return DialogFiguraTerreno(
                              dibujo: widget.trabajo.dibujo,
                              areaTotal: double.tryParse(widget.trabajo.area) ?? 0,
                            );
                          },
                        );
                        if (resultado != null) {
                          setState(() {
                            metrosTrabajados = resultado;
                          });
                        }
                      },
                    ),
                  ),
                const SizedBox(height: 12),
                if (metrosTrabajados != null && !guardado)
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text('Guardar en Metros Trabajados'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() {
                          guardado = true;
                        });
                        if (widget.onAvanceGuardado != null) {
                          widget.onAvanceGuardado!(metrosTrabajados ?? 0);
                        }
                      },
                    ),
                  ),
                if (guardado)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        '¡Avance guardado en Metros Trabajados!',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
