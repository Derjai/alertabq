import 'package:alertabq/views/my_reports.dart';
import 'package:alertabq/views/reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Ya estamos en la vista de Inicio
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyReports()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Reports()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color textColor =
        isDarkMode ? const Color(0xFFF8F9FA) : const Color(0xFF2D3748);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('AlertaBQ', style: TextStyle(fontSize: 20.0)),
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
              selected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurar cuenta'),
              selected: false,
              onTap: () {
                Navigator.popAndPushNamed(context, '/Profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              selected: false,
              onTap: () {
                Navigator.popAndPushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    width: size.width * 0.9,
                    child: FlutterMap(
                      mapController: MapController(),
                      options: const MapOptions(
                        initialCenter: LatLng(10.96854, -74.78132),
                        initialZoom: 12.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                          userAgentPackageName: 'com.e',
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: FloatingActionButton(
                    onPressed: () {},
                    tooltip: 'Botón de emergencia',
                    child: const Icon(Icons.local_police),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/Submit');
                    },
                    tooltip: 'Reportar incidente',
                    child: const Icon(Icons.assignment_add),
                  ),
                ),
              ],
            ),
          ),
          NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: 'Inicio',
                ),
                NavigationDestination(
                    icon: Icon(Icons.history), label: 'Mis reportes'),
                NavigationDestination(
                    icon: Icon(Icons.verified), label: 'Verificar reportes'),
              ])
        ],
      ),
    );
  }
}
