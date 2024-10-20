import 'package:flutter/material.dart';

class SubmitReport extends StatefulWidget {
  const SubmitReport({super.key});

  @override
  _SubmitReportState createState() => _SubmitReportState();
}

class _SubmitReportState extends State<SubmitReport> {
  final TextEditingController _locationController =
      TextEditingController(text: 'Ubicación predeterminada');
  final TextEditingController _dateTimeController =
      TextEditingController(text: '2023-10-01 14:30');
  final TextEditingController _descriptionController = TextEditingController();
  String? _attachment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Reporte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo para la ubicación
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Ubicación',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.location_on),
                  onPressed: () {
                    // Lógica para seleccionar ubicación en el mapa
                  },
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Campo para la fecha y hora
            TextField(
              controller: _dateTimeController,
              decoration: InputDecoration(
                labelText: 'Fecha y Hora',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    // Lógica para seleccionar fecha y hora
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dateTimeController.text = pickedDate.toString();
                      });
                    }
                  },
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Campo para la descripción
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            // Botón para adjuntar archivo
            Row(
              children: [
                const Text('Adjuntar archivo:'),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {
                    // Lógica para adjuntar archivo
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Botón para enviar reporte
            ElevatedButton(
              onPressed: () {
                // Lógica para enviar reporte
              },
              child: const Text('Enviar Reporte'),
            ),
          ],
        ),
      ),
    );
  }
}
