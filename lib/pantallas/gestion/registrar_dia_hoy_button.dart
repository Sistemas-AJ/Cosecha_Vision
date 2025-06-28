import 'package:flutter/material.dart';

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
    return GestureDetector(
      onTap: () async {
        final hoy = DateTime.now();
        final TextEditingController hoyController = TextEditingController(
          text: avanceHoy != null ? avanceHoy!['metros'].toString() : '',
        );
        final result = await showDialog<Map<String, dynamic>>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Registrar Día Hoy'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: hoyController,
                    decoration: InputDecoration(
                      labelText: 'Metros trabajados hoy',
                      hintText: 'Ej: 50.5',
                      prefixIcon: Icon(Icons.square_foot, color: Color(0xFF388E3C)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 16),
                  if (avanceHoy != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Avance de hoy:', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 6),
                        Text('Fecha: '
                            '${hoy.day.toString().padLeft(2, '0')}/'
                            '${hoy.month.toString().padLeft(2, '0')}/'
                            '${hoy.year}'),
                        Text('Metros trabajados: ${avanceHoy!['metros']} m²'),
                      ],
                    )
                  else
                    Text('No hay avance registrado para hoy.', style: TextStyle(color: Colors.grey)),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final metros = double.tryParse(hoyController.text) ?? 0;
                    if (metros > 0) {
                      Navigator.pop(context, {
                        'trabajoId': trabajo.hashCode,
                        'fecha': hoy,
                        'metros': metros,
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Guardar'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
            );
          },
        );
        if (result != null) {
          onAvanceGuardado(result);
        }
      },
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Color(0xFF64B5F6), Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, color: Colors.white, size: 28),
            SizedBox(height: 6),
            Text('Registrar Día', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            Text('Hoy', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
