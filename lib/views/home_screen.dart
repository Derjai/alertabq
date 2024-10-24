import 'package:alertabq/widgets/custom_drawer.dart';
import 'package:alertabq/widgets/custom_navigation_bar.dart';
import 'package:alertabq/widgets/pannic_button.dart';
import 'package:alertabq/widgets/report_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int drawerIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      drawerIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/Profile');
        break;
      case 2:
        Navigator.popUntil(context, ModalRoute.withName('/'));
        break;
      case 3:
        break;
    }
  }

  void onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/History');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/Reports');
        break;
    }
  }

  void _pannicButtonPressed() {}

  void _reportButtonPressed() {
    Navigator.pushNamed(context, '/SubmitReport');
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
      drawer: CustomDrawer(
          isDarkMode: isDarkMode,
          textColor: textColor,
          selectedIndex: drawerIndex,
          onItemTapped: _onItemTapped),
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
                  child: PannicButton(onPressed: _pannicButtonPressed),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: ReportButton(onPressed: _reportButtonPressed),
                ),
              ],
            ),
          ),
          CustomNavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: onDestinationSelected,
          ),
        ],
      ),
    );
  }
}
