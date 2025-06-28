import 'package:flutter/material.dart';
import 'gestion/personal_screen.dart';
import 'gestion/tipos_trabajo_screen.dart';
import 'gestion/registrar_jornada_screen.dart';
import 'gestion/reportes_screen.dart';

class GestionTrabajosScreen extends StatelessWidget {
  const GestionTrabajosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Cosecha'),
        backgroundColor: const Color(0xFF388E3C),
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3,
          padding: const EdgeInsets.all(16.0),
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.9,
          children: [
            _ManagementCard(
              title: 'Gestionar Personal',
              subtitle: 'Añadir, ver o editar trabajadores.',
              icon: Icons.people_alt_rounded,
              color: Colors.blue.shade700,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonalScreen()));
              },
            ),
            _ManagementCard(
              title: 'Tipos de Trabajo',
              subtitle: 'Definir las labores (siembra, riego, etc.).',
              icon: Icons.agriculture_rounded,
              color: Colors.orange.shade700,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const TiposTrabajoScreen()));
              },
            ),
            _ManagementCard(
              title: 'Registrar Jornada',
              subtitle: 'Anotar el trabajo diario del personal.',
              icon: Icons.app_registration_rounded,
              color: Colors.green.shade700,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrarJornadaScreen()));
              },
            ),
            _ManagementCard(
              title: 'Reportes y Desempeño',
              subtitle: 'Ver asistencia y productividad.',
              icon: Icons.bar_chart_rounded,
              color: Colors.purple.shade700,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportesScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}


// Widget reutilizable para las tarjetas del panel de gestión
class _ManagementCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ManagementCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: color, width: 6)),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 48.0, color: color),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
