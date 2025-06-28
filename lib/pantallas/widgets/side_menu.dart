import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final String? nombreUsuario;
  const SideMenu({super.key, this.nombreUsuario});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF388E3C),
            Color(0xFF4CAF50),
          ],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                const Icon(Icons.eco, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Text(
                  'Cosecha\nVision',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Color(0xFF388E3C)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    nombreUsuario ?? 'Usuario',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
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
