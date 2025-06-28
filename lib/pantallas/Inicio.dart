import 'package:flutter/material.dart';

// Widgets personalizados (asegúrate de que las rutas sean correctas)
import 'widgets/main_card.dart';
import 'widgets/side_menu.dart';
import 'widgets/app_drawer.dart';

// Pantalla a la que se navegará
import 'gestion/trabajadores.dart';
import 'gestion/modelo_trabajo.dart';
import 'gestion/detalle_metros_trabajados.dart' as detalle_metros_trabajados;
import 'tip_dia_screen.dart';

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    // --- Configuración de Responsividad ---
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    // --- Datos del Usuario ---
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String? nombreUsuario = args != null ? args['name'] : 'Alister';

    // --- Variables para el GridView ---
    final int crossAxisCount = isMobile ? 2 : 3;
    final double childAspectRatio = isMobile ? 1.0 : 1.2;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              title: const Text(
                'Cosecha Vision',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color(0xFF388E3C),
              foregroundColor: Colors.white,
              elevation: 4,
            )
          : null,
      drawer: isMobile ? AppDrawer(nombreUsuario: nombreUsuario) : null,
      body: SafeArea(
        child: Row(
          children: [
            // Menú lateral para pantallas grandes
            if (!isMobile) SideMenu(nombreUsuario: nombreUsuario),

            // Contenido principal
            Expanded(
              child: Stack(
                children: [
                  // Fondo decorativo animado sutil
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFF1F8E9), Color(0xFFE3F2FD)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  // Header decorativo con curva y degradado
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: ClipPath(
                      clipper: _CurvedHeaderClipper(),
                      child: Container(
                        height: 110,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF388E3C), Color(0xFF4CAF50)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: isMobile ? 24 : 48, top: 24),
                            child: Text(
                              'Bienvenido a Cosecha Vision',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobile ? 20 : 28,
                                fontWeight: FontWeight.bold,
                                shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Contenido principal
                  Positioned.fill(
                    child: ListView(
                      padding: EdgeInsets.only(
                        top: isMobile ? 100 : 120,
                        left: isMobile ? 12.0 : 32.0,
                        right: isMobile ? 12.0 : 32.0,
                        bottom: 0,
                      ),
                      children: [
                        // Grid con las tarjetas de información
                        GridView.count(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: isMobile ? 12 : 20,
                          mainAxisSpacing: isMobile ? 12 : 20,
                          shrinkWrap: true,
                          childAspectRatio: childAspectRatio,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => detalle_metros_trabajados.DetalleMetrosTrabajadosScreen(),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: MainCard(
                                icon: Icons.grass,
                                title: 'Metros trabajados',
                                value: trabajosGuardados.isNotEmpty
                                    ? '${trabajosGuardados.length} registrados'
                                    : '0 registrados',
                                color: const Color(0xFF4CAF50),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TrabajadoresScreen(),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: const MainCard(
                                icon: Icons.groups,
                                title: 'Registrar trabajo',
                                value: '',
                                color: Colors.orange,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                if (trabajosGuardados.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('No hay trabajos registrados para registrar el día.')),
                                  );
                                  return;
                                }
                                // Selecciona el trabajo más reciente (último)
                                final trabajo = trabajosGuardados.last;
                                await showDialog(
                                  context: context,
                                  builder: (context) => detalle_metros_trabajados.showDetalleTrabajoDialog(trabajo: trabajo),
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: const MainCard(
                                icon: Icons.calendar_today,
                                title: 'Registrar Día',
                                value: 'Hoy',
                                color: Colors.blueAccent,
                              ),
                            ),
                            // Tarjeta decorativa para llenar el espacio vacío
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TipDiaScreen(nombreUsuario: nombreUsuario),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: const MainCard(
                                icon: Icons.lightbulb_outline,
                                title: 'Tip del día',
                                value: '¡Recuerda registrar tus avances diarios!',
                                color: Color(0xFFB2DFDB),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // Ilustración decorativa y mensaje motivacional mejorado
                        Center(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/ilustracion_campo.png',
                                height: 120,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.eco, color: Color(0xFF388E3C), size: 64),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                '¡Sigue cosechando logros!',
                                style: TextStyle(
                                  color: Color(0xFF388E3C),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Gestiona tu trabajo agrícola de forma fácil, visual y profesional.',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 18),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- CLIPPER PARA HEADER CURVO ---
class _CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(size.width / 2, size.height + 30, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

