import 'package:alertabq/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  int _selectedIndex = 2;
  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/Home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/History');
        break;
      case 2:
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Usuario',
                  style: TextStyle(fontSize: 20.0, color: textColor)),
              accountEmail: Text('usuario@ejemplo.com',
                  style: TextStyle(fontSize: 20.0, color: textColor)),
              currentAccountPicture: const CircleAvatar(
                child: Text(
                  'U',
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
              decoration: const BoxDecoration(),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              selected: false,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurar cuenta'),
              selected: false,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              selected: false,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
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
                  child: const Text('Confirmar'),
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
