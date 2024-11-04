import 'dart:io';

import 'package:alertabq/data/database_service.dart';
import 'package:alertabq/data/report_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SubmitReport extends StatefulWidget {
  const SubmitReport({super.key});

  @override
  State<SubmitReport> createState() => _SubmitReportState();
}

class _SubmitReportState extends State<SubmitReport> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _initializeDate();
    _connectToDatabase();
  }

  Future<void> _connectToDatabase() async {
    try {
      await DataBaseService.connect();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al conectar a la base de datos: $e'),
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
        _locationController.text =
            '${currentLocation.latitude}, ${currentLocation.longitude}';
      });
    } else {
      final permission = await location.requestPermission();
      if (permission == loc.PermissionStatus.granted) {
        final currentLocation = await location.getLocation();
        setState(() {
          _locationController.text =
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
    _dateTimeController.text = now.toIso8601String();
  }

  Future<File?> _selectFile() async {
    final status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      final result = await FilePicker.platform.pickFiles(type: FileType.media);
      if (result != null && result.files.isNotEmpty) {
        final filePath = result.files.single.path;
        if (filePath != null) {
          setState(() {
            _selectedFile = File(filePath);
          });
          return File(filePath);
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024, 10),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateTimeController.text = picked.toIso8601String();
      });
    }
  }

  Future<void> _selectLocation() async {
    final location = loc.Location();
    final hasPermission = await location.hasPermission();
    if (hasPermission == loc.PermissionStatus.granted) {
      final currentLocation = await location.getLocation();
      setState(() {
        _locationController.text =
            '${currentLocation.latitude}, ${currentLocation.longitude}';
      });
    } else {
      final permissionStatus = await location.requestPermission();
      if (permissionStatus == loc.PermissionStatus.granted) {
        final currentLocation = await location.getLocation();
        setState(() {
          _locationController.text =
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

  Future<void> _submitReport() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario no autenticado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String? attachmentUrl;
    if (_selectedFile != null) {
      attachmentUrl = await _uploadFile(_selectedFile!);
    }
    final report = Report(
        email: user.email!,
        description: _descriptionController.text.isEmpty
            ? 'Incidente'
            : _descriptionController.text,
        location: _locationController.text,
        dateTime: DateTime.parse(_dateTimeController.text),
        attachment: attachmentUrl,
        id: mongo.ObjectId());

    try {
      await DataBaseService.insertReport(report);
      if (mounted) {
        setState(() {
          _descriptionController.clear();
          _locationController.clear();
          _dateTimeController.clear();
          _selectedFile = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reporte enviado'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar reporte: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Reporte'),
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Descripción',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Descripción del incidente',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ubicación',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    hintText: 'Ubicación del incidente',
                  ),
                )),
                IconButton(
                  icon: const Icon(Icons.location_on),
                  onPressed: () {
                    _selectLocation();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Fecha',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _dateTimeController,
                  decoration: const InputDecoration(
                    hintText: 'Fecha del incidente',
                  ),
                )),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Adjuntar archivo:'),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: _selectFile,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _submitReport();
              },
              child: const Text('Enviar Reporte'),
            ),
          ],
        ),
      ),
    );
  }
}
