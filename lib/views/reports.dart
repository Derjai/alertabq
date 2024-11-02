import 'package:alertabq/auth/auth_service.dart';
import 'package:alertabq/data/database_service.dart';
import 'package:alertabq/data/report_data.dart';
import 'package:alertabq/widgets/custom_drawer.dart';
import 'package:alertabq/widgets/custom_navigation_bar.dart';
import 'package:alertabq/widgets/pannic_button.dart';
import 'package:alertabq/widgets/report_button.dart';
import 'package:alertabq/widgets/report_card.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  final _auth = AuthService();
  int _selectedIndex = 2;
  int drawerIndex = 3;
  String? _location;
  String? _dateTime;
  late Future<List<Map<String, dynamic>>> _reports;

  Future<void> _onItemTapped(int index) async {
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
        await _auth.signOut();
        if (mounted) {
          Navigator.popUntil(context, ModalRoute.withName('/'));
        }
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
        Navigator.pushReplacementNamed(context, '/History');
        break;
      case 2:
        break;
    }
  }

  void _pannicButtonPressed() async {
    await _createPanicReport();
  }

  Future<void> _createPanicReport() async {
    final user = _auth.currentUser;
    if (user?.email == null) {
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

    await _initializeLocation();
    _initializeDate();
    if (_location == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo obtener la ubicación'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (user?.email! == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo obtener el correo del usuario'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final report = Report(
      email: user!.email!,
      description: 'Emergencia',
      location: _location!,
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

  void _onConfirm(mongo.ObjectId id) async {
    try {
      await DataBaseService.confirmReport(id, true);
      setState(() {
        _reports = _fetchReports();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reporte confirmado'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al confirmar reporte: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onNegative(mongo.ObjectId id) async {
    try {
      await DataBaseService.confirmReport(id, false);
      setState(() {
        _reports = _fetchReports();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reporte marcado como no confirmado'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al procesar solicitud: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _initializeLocation() async {
    final location = loc.Location();
    final hasPermission = await location.hasPermission();
    if (hasPermission == loc.PermissionStatus.granted) {
      final currentLocation = await location.getLocation();
      setState(() {
        _location = '${currentLocation.latitude}, ${currentLocation.longitude}';
      });
    } else {
      final permission = await location.requestPermission();
      if (permission == loc.PermissionStatus.granted) {
        final currentLocation = await location.getLocation();
        setState(() {
          _location =
              '${currentLocation.latitude}, ${currentLocation.longitude}';
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

  void _initializeDate() {
    final now = DateTime.now();
    setState(() {
      _dateTime = now.toIso8601String();
    });
  }

  Future<List<Map<String, dynamic>>> _fetchReports() async {
    final user = _auth.currentUser;
    if (user == null) {
      return [];
    }
    if (user.email != null) {
      return await DataBaseService.getReports(user.email!);
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    _reports = _fetchReports();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color textColor =
        isDarkMode ? const Color(0xFFF8F9FA) : const Color(0xFF2D3748);
    String buttonAction = 'Confirmar';
    String negativeButtonAction = 'No info';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes'),
      ),
      drawer: CustomDrawer(
        isDarkMode: isDarkMode,
        textColor: textColor,
        selectedIndex: drawerIndex,
        onItemTapped: _onItemTapped,
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _reports,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No hay nuevos reportes'),
                );
              } else {
                final reports = snapshot.data!;
                return ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return ReportCard(
                      location: report['location'],
                      dateTime: report['dateTime'],
                      description: report['description'],
                      attachment: report['attachment'],
                      events: (report['events'] as List<dynamic>)
                          .map((e) => Event.fromMap(e))
                          .toList(),
                      onConfirm: () =>
                          _onConfirm(report['_id'] as mongo.ObjectId),
                      onNegative: () =>
                          _onNegative(report['_id'] as mongo.ObjectId),
                      buttonAction: buttonAction,
                      negativeButtonAction: negativeButtonAction,
                    );
                  },
                );
              }
            },
          ),
          Positioned(
            bottom: 10,
            left: 5,
            child: PannicButton(onPressed: _pannicButtonPressed),
          ),
          Positioned(
            bottom: 10,
            right: 5,
            child: ReportButton(onPressed: _reportButtonPressed),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }
}
