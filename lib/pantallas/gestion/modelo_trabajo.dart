import 'package:flutter/material.dart';
import 'dart:ui';

class TrabajoRegistrado {
  final String trabajo;
  final String cronograma;
  final String area;
  final String metros;
  final String numTrabajadores;
  final List<Offset?> dibujo;

  TrabajoRegistrado({
    required this.trabajo,
    required this.cronograma,
    required this.area,
    required this.metros,
    required this.numTrabajadores,
    required this.dibujo,
  });
}


// Lista global para múltiples trabajos registrados
List<TrabajoRegistrado> trabajosGuardados = [];
// Si necesitas compatibilidad con el código anterior, puedes dejar trabajoGuardado como null o deprecado.
TrabajoRegistrado? trabajoGuardado; // DEPRECATED: Usar trabajosGuardados
