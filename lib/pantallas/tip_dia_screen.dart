import 'package:flutter/material.dart';

class TipDiaScreen extends StatelessWidget {
  final String? nombreUsuario;
  const TipDiaScreen({Key? key, this.nombreUsuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu día y tu motivación'),
        backgroundColor: const Color(0xFF388E3C),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: const Color(0xFFB2DFDB),
                child: Icon(Icons.person, color: Color(0xFF388E3C), size: 48),
              ),
              const SizedBox(height: 18),
              Text(
                nombreUsuario != null ? '¡Hola, $nombreUsuario!' : '¡Hola! 😊',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF388E3C),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Recuerda que cada día es una nueva oportunidad para crecer y cosechar éxitos. ¡Tú puedes! 🌱',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Card(
                color: const Color(0xFF4CAF50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    children: const [
                      Text(
                        'Tip del día',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '¡Registra tus avances diarios y verás tu progreso crecer como una gran cosecha!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
