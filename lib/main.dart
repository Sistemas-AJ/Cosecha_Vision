// lib/main.dart

import 'package:flutter/material.dart';

// --- IMPORTACIONES CORREGIDAS ---
// Asegúrate de que los nombres de las clases dentro de estos archivos
// sean PantallaBienvenida, PantallaLogin, PantallaRegistro y PantallaInicio.

import 'pantallas/gestion/Bienvenida.dart'; // Corregido: está en la carpeta 'gestion'
import 'pantallas/registro/Login.dart';     // Corregido: está en la carpeta 'registro'
import 'pantallas/registro/Registro.dart';   // Corregido: está en la carpeta 'registro'
import 'pantallas/Inicio.dart';

void main() {
  runApp(const CosechaVisionApp());
}

class CosechaVisionApp extends StatelessWidget {
  const CosechaVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosecha Vision',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      // La pantalla inicial (home) ahora usa la clase correcta
      home: const PantallaBienvenida(),
      // Las rutas ahora usan los nombres de clase correctos
      routes: {
        '/login': (context) => const PantallaLogin(),
        '/registro': (context) => const PantallaRegistro(),
        '/inicio': (context) => const PantallaInicio(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}