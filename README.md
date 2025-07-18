# Cosecha Vision

Aplicación Flutter para la gestión agrícola, enfocada en el registro y visualización de avances diarios de trabajos en campo.

## Estructura del proyecto

- `lib/` — Código fuente principal de la app.
  - `main.dart` — Punto de entrada de la aplicación.
  - `pantallas/` — Contiene las pantallas y widgets principales.
    - `gestion/` — Lógica y pantallas para gestión de trabajos y avances.
    - `detalle_metros_trabajados.dart` — Pantalla para ver y registrar avances diarios, con visualización gráfica del área trabajada.
    - `registro_hoy_button.dart` — Widget para mostrar el avance del día actual.
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/` — Archivos y carpetas para soporte multiplataforma.
- `pubspec.yaml` — Configuración de dependencias y recursos de Flutter.
- `README.md` — Documentación del proyecto.

## Funcionalidades principales

- Registro de metros trabajados por día y por trabajo.
- Visualización de historial de avances y progreso acumulado.
- Dibujo visual del área trabajada.
- Interfaz moderna y fácil de usar, con botones diferenciados para registrar y consultar avances.

## Instalación y ejecución

1. Clona el repositorio:
   ```
   git clone https://github.com/Sistemas-AJ/Cosecha_Vision.git
   ```
2. Entra a la carpeta del proyecto:
   ```
   cd Cosecha_Vision
   ```
3. Instala las dependencias:
   ```
   flutter pub get
   ```
4. Ejecuta la app:
   ```
   flutter run
   ```

---

Desarrollado por Sistemas AJ