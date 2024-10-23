import 'package:alertabq/widgets/custom_drawer.dart';
import 'package:alertabq/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';

class MyReports extends StatefulWidget {
  const MyReports({super.key});

  @override
  State<MyReports> createState() => _MyReportsState();
}

class _MyReportsState extends State<MyReports> {
  int _selectedIndex = 1;
  int drawerIndex = 3;
  void _onItemTapped(int index) {
    setState(() {
      drawerIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/Home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/Profile');
        break;
      case 2:
        Navigator.popUntil(context, ModalRoute.withName('/'));
        break;
      case 3:
        break;
    }
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/Home');
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/Reports');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color textColor =
        isDarkMode ? const Color(0xFFF8F9FA) : const Color(0xFF2D3748);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis reportes'),
      ),
      drawer: CustomDrawer(
        isDarkMode: isDarkMode,
        textColor: textColor,
        selectedIndex: drawerIndex,
        onItemTapped: _onItemTapped,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    ReportCard(
                      location: 'Ubicación 1',
                      dateTime: '2023-10-01 14:30',
                      description: 'Descripción del reporte 1',
                      attachment: 'assets/attachment1.png',
                      events: [
                        Event(
                          location: 'Ubicación Evento 1',
                          dateTime: '2023-10-01 15:00',
                          description: 'Descripción del evento 1',
                          attachment: 'assets/attachment2.png',
                        ),
                        Event(
                          location: 'Ubicación Evento 2',
                          dateTime: '2023-10-01 16:00',
                          description: 'Descripción del evento 2',
                          attachment: null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const ReportCard(
                      location: 'Ubicación 2',
                      dateTime: '2023-10-02 10:00',
                      description: 'Descripción del reporte 2',
                      attachment: null,
                      events: [],
                    ),
                  ],
                ),
              ),
              CustomNavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onDestinationSelected)
            ],
          ),
          Positioned(
            bottom: 100,
            right: 5,
            child: FloatingActionButton(
              onPressed: () {
                // Lógica para el botón de emergencia
              },
              tooltip: 'Botón de emergencia',
              child: const Icon(Icons.local_police),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 5,
            child: FloatingActionButton(
              onPressed: () {
                // Lógica para crear un nuevo reporte
              },
              tooltip: 'Reportar incidente',
              child: const Icon(Icons.assignment_add),
            ),
          ),
        ],
      ),
    );
  }
}

class ReportCard extends StatefulWidget {
  final String location;
  final String dateTime;
  final String description;
  final String? attachment;
  final List<Event> events;

  const ReportCard({
    required this.location,
    required this.dateTime,
    required this.description,
    this.attachment,
    required this.events,
    super.key,
  });

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.attachment != null)
              Image.asset(
                widget.attachment!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 10),
            Text('Ubicación: ${widget.location}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Fecha y Hora: ${widget.dateTime}'),
            Text('Descripción: ${widget.description}'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Lógica para añadir eventos
                  },
                  child: const Text('Añadir Evento'),
                ),
                TextButton(
                  onPressed: () {
                    // Lógica para borrar el reporte
                  },
                  child: const Text('Borrar'),
                ),
              ],
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Eventos',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
            if (_isExpanded)
              Column(
                children: widget.events.map((event) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: EventCard(event: event),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({required this.event, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[600],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.attachment != null)
              Image.asset(
                event.attachment!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            Text('Ubicación: ${event.location}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Fecha y Hora: ${event.dateTime}'),
            Text('Descripción: ${event.description}'),
          ],
        ),
      ),
    );
  }
}

class Event {
  final String location;
  final String dateTime;
  final String description;
  final String? attachment;

  Event({
    required this.location,
    required this.dateTime,
    required this.description,
    this.attachment,
  });
}
