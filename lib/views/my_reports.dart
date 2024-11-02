import 'dart:io';

import 'package:alertabq/auth/auth_service.dart';
import 'package:alertabq/data/database_service.dart';
import 'package:alertabq/data/report_data.dart';
import 'package:alertabq/widgets/custom_drawer.dart';
import 'package:alertabq/widgets/custom_navigation_bar.dart';
import 'package:alertabq/widgets/pannic_button.dart';
import 'package:alertabq/widgets/report_button.dart';
import 'package:alertabq/widgets/report_card.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:location/location.dart' as loc;
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MyReports extends StatefulWidget {
  const MyReports({super.key});

  @override
  State<MyReports> createState() => _MyReportsState();
}

class _MyReportsState extends State<MyReports> {
  final _auth = AuthService();
  int _selectedIndex = 1;
  int drawerIndex = 3;
  late Future<List<Map<String, dynamic>>> _reports;
  final locationController = TextEditingController();
  final dateTimeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _reports = _fetchReports();
    _initializeLocation(locationController);
    _initializeDate(dateTimeController);
  }

  Future<List<Map<String, dynamic>>> _fetchReports() async {
    final user = _auth.currentUser;
    if (user == null) {
      return [];
    }
    if (user.email != null) {
      return await DataBaseService.getReportsByUser(user.email!);
    }
    return [];
  }

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
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/Reports');
        break;
    }
  }

  void _panicButtonPressed() async {
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

    final locationController = TextEditingController();
    final dateTimeController = TextEditingController();
    await _initializeLocation(locationController);
    _initializeDate(dateTimeController);
    final report = Report(
      email: user.email!,
      description: 'Emergencia',
      location: locationController.text,
      dateTime: DateTime.parse(dateTimeController.text),
      priority: true,
      id: mongo.ObjectId(),
    );

    try {
      await DataBaseService.insertReport(report);
      setState(() {
        _reports = _fetchReports();
      });
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
    _showAddEventDialog(id);
  }

  void _onNegative(mongo.ObjectId id) async {
    try {
      await DataBaseService.deleteReport(id);
      setState(() {
        _reports = _fetchReports();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Reporte eliminado'),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al eliminar el reporte: $e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  void _addEvent(mongo.ObjectId reportId, Event event) async {
    try {
      await DataBaseService.addEventToReport(reportId, event);
      setState(() {
        _reports = _fetchReports();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Evento añadido al reporte'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al añadir evento al reporte: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _initializeLocation(
      TextEditingController locationController) async {
    final location = loc.Location();
    final hasPermission = await location.hasPermission();
    if (hasPermission == loc.PermissionStatus.granted) {
      final currentLocation = await location.getLocation();
      locationController.text =
          '${currentLocation.latitude}, ${currentLocation.longitude}';
    } else {
      final permission = await location.requestPermission();
      if (permission == loc.PermissionStatus.granted) {
        final currentLocation = await location.getLocation();
        locationController.text =
            '${currentLocation.latitude}, ${currentLocation.longitude}';
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

  void _initializeDate(TextEditingController dateTimeController) {
    final now = DateTime.now();
    dateTimeController.text = now.toIso8601String();
  }

  Future<File?> _selectFile(TextEditingController attachmentController) async {
    final status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      final result = await FilePicker.platform.pickFiles(type: FileType.media);
      if (result != null && result.files.isNotEmpty) {
        final filePath = result.files.single.path;
        if (filePath != null) {
          final file = File(filePath);
          final url = await _uploadFile(file);
          if (url != null) {
            attachmentController.text = url;
          }
          return file;
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permiso de almacenamiento denegado'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    return null;
  }

  Future<String?> _uploadFile(File file) async {
    try {
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('uploads/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al subir archivo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  }

  void _showAddEventDialog(mongo.ObjectId reportId) {
    final descriptionController = TextEditingController();
    final attachmentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir Evento'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: locationController,
                        decoration:
                            const InputDecoration(labelText: 'Ubicación'),
                      ),
                    ),
                    IconButton(
                        onPressed: () => _initializeLocation,
                        icon: const Icon(Icons.location_on))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: dateTimeController,
                        decoration:
                            const InputDecoration(labelText: 'Fecha y Hora'),
                      ),
                    ),
                    IconButton(
                        onPressed: () => _initializeDate,
                        icon: const Icon(Icons.calendar_today))
                  ],
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                TextField(
                  controller: attachmentController,
                  decoration: const InputDecoration(labelText: 'Adjunto (URL)'),
                ),
                IconButton(
                    onPressed: () => _selectFile(attachmentController),
                    icon: const Icon(Icons.attach_file))
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final event = Event(
                  location: locationController.text,
                  dateTime: DateTime.parse(dateTimeController.text),
                  description: descriptionController.text,
                  attachment: attachmentController.text.isNotEmpty
                      ? attachmentController.text
                      : null,
                );
                _addEvent(reportId, event);
                Navigator.of(context).pop();
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }

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
      body: Stack(children: [
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _reports,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('No hay reportes asociados a tu cuenta'));
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
                    events: (report['events'] as List<dynamic>? ?? [])
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
          child: PannicButton(onPressed: _panicButtonPressed),
        ),
        Positioned(
          bottom: 10,
          right: 5,
          child: ReportButton(onPressed: _reportButtonPressed),
        ),
      ]),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }
}
