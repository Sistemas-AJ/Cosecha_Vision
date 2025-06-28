import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String? nombreUsuario;
  const AppDrawer({super.key, this.nombreUsuario});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF43EA7A), Color(0xFF388E3C)],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF388E3C), Color(0xFF4CAF50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Color(0xFF388E3C), size: 38),
                  ),
                  const SizedBox(width: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombreUsuario ?? 'Usuario',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Panel de control',
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text('Inicio', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.white),
              title: const Text('Ayuda', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Ayuda'),
                    content: const Text('Aquí puedes encontrar ayuda sobre el uso de la aplicación.'),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.white),
              title: const Text('Contactarte', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Contacto'),
                    content: const Text('Para soporte, escribe a: soporte@cosechavision.com'),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Configuración', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              onTap: () {/* Navegar a otra pantalla */},
            ),
            const Divider(color: Colors.white54, thickness: 1, indent: 16, endIndent: 16),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              onTap: () {/* Lógica de logout */},
            ),
            const SizedBox(height: 18),
            Center(
              child: Text(
                'Cosecha Vision v1.0',
                style: TextStyle(color: Colors.white70, fontSize: 13, fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
