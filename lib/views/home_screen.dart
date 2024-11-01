import 'package:alertabq/auth/auth_service.dart';
import 'package:alertabq/data/database_service.dart';
import 'package:alertabq/data/report_data.dart';
import 'package:alertabq/widgets/custom_drawer.dart';
import 'package:alertabq/widgets/custom_navigation_bar.dart';
import 'package:alertabq/widgets/pannic_button.dart';
import 'package:alertabq/widgets/report_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:location/location.dart' as loc;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = AuthService();
  int _selectedIndex = 0;
  int drawerIndex = 0;
  String? _location;
  String? _dateTime;
  LatLng? _currentLatLng;
  List<LatLng> _reportMarkers = [];
  final MapController _mapController = MapController();

  Future<void> _onItemTapped(int index) async {
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
        await _auth.signOut();
        break;
      case 3:
        break;
    }
  }

  Future<void> _initializeLocation() async {
    final location = loc.Location();
    final hasPermission = await location.hasPermission();
    if (hasPermission == loc.PermissionStatus.granted) {
      final currentLocation = await location.getLocation();
      setState(() {
        _location = '${currentLocation.latitude}, ${currentLocation.longitude}';
        _currentLatLng =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _reportMarkers.insert(0, _currentLatLng!);
      });
    } else {
      final permission = await location.requestPermission();
      if (permission == loc.PermissionStatus.granted) {
        final currentLocation = await location.getLocation();
        setState(() {
          _location =
              '${currentLocation.latitude}, ${currentLocation.longitude}';
          _currentLatLng =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Permiso de ubicación denegado'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  List<Marker> convertToMarkers() {
    return _reportMarkers.asMap().entries.map((entry) {
      final index = entry.key;
      final latLng = entry.value;
      return Marker(
          width: 80.0,
          height: 80.0,
          point: latLng,
          child: Builder(
            builder: (ctx) => Icon(
                index == 0 ? Icons.person_pin_circle : Icons.warning,
                color: index == 0 ? Colors.blue : Colors.red,
                size: 40.0,
                key: ValueKey(
                    index == 0 ? 'current_location' : 'report_$index')),
          ));
    }).toList();
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

  void _pannicButtonPressed() async {
    await _createPanicReport();
  }

  Future<void> _createPanicReport() async {
    final user = _auth.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario no autenticado'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    _initializeDate();
    final report = Report(
      email: user.email!,
      description: 'Emergencia',
      location: _location ?? 'Desconocida',
      dateTime: DateTime.parse(_dateTime ?? DateTime.now().toIso8601String()),
      priority: true,
      id: mongo.ObjectId(),
    );

    try {
      await DataBaseService.insertReport(report);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reporte de pánico enviado'),
            backgroundColor: Colors.green,
          ),
        );
        _fetchReports();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar reporte de pánico: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _reportButtonPressed() {
    Navigator.pushNamed(context, '/SubmitReport');
  }

  void _initializeDate() {
    final now = DateTime.now();
    setState(() {
      _dateTime = now.toIso8601String();
    });
  }

  Future<void> _fetchReports() async {
    try {
      final reports = await DataBaseService.getAllReports();
      setState(() {
        _reportMarkers = reports
            .map((report) {
              final location = report['location']?.split(', ');
              if (location != null && location.length == 2) {
                final lat = double.tryParse(location[0]);
                final lng = double.tryParse(location[1]);
                if (lat != null && lng != null) {
                  return LatLng(lat, lng);
                }
              }
              return null;
            })
            .whereType<LatLng>()
            .toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al obtener reportes: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _fetchReports();
  }

  @override
  void dispose() {
    _reportMarkers.clear();
    super.dispose();
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
                    child: _currentLatLng == null
                        ? const Center(child: CircularProgressIndicator())
                        : FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              initialCenter: _currentLatLng ??
                                  const LatLng(10.96854, -74.78132),
                              initialZoom: 16,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.alertabq',
                              ),
                              MarkerLayer(markers: convertToMarkers()),
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
