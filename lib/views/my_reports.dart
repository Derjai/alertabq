import 'package:alertabq/widgets/custom_drawer.dart';
import 'package:alertabq/widgets/custom_navigation_bar.dart';
import 'package:alertabq/widgets/pannic_button.dart';
import 'package:alertabq/widgets/report_button.dart';
import 'package:alertabq/widgets/report_card.dart';
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

  void _panicButtonPressed() {}

  void _reportButtonPressed() {
    Navigator.pushNamed(context, '/SubmitReport');
  }

  void _onConfirm() {}
  void _onNegative() {}

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color textColor =
        isDarkMode ? const Color(0xFFF8F9FA) : const Color(0xFF2D3748);
    String buttonAction = 'Añadir evento';
    String negativeButtonAction = 'Eliminar';
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
                      onConfirm: _onConfirm,
                      onNegative: _onNegative,
                      buttonAction: buttonAction,
                      negativeButtonAction: negativeButtonAction,
                    ),
                    const SizedBox(height: 20),
                    ReportCard(
                      location: 'Ubicación 2',
                      dateTime: '2023-10-02 10:00',
                      description: 'Descripción del reporte 2',
                      attachment: null,
                      events: const [],
                      onConfirm: _onConfirm,
                      onNegative: _onNegative,
                      buttonAction: buttonAction,
                      negativeButtonAction: negativeButtonAction,
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
            left: 5,
            child: PannicButton(onPressed: _panicButtonPressed),
          ),
          Positioned(
            bottom: 100,
            right: 5,
            child: ReportButton(onPressed: _reportButtonPressed),
          ),
        ],
      ),
    );
  }
}
