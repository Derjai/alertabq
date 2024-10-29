import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'report_data.dart';

class DataBaseService {
  static late Db? _db;

  static Future<void> connect() async {
    final uri = dotenv.env['MONGO_DB_URL'];
    if (uri == null) {
      throw Exception('No se encontró la variable de entorno MONGO_DB_URL');
    }
    _db = await Db.create(uri);
    await _db?.open();
  }

  static Future<void> disconnect() async {
    await _db?.close();
  }

  static Future<void> insertReport(Report report) async {
    if (_db == null || !_db!.isConnected) {
      throw Exception('No se ha conectado a la base de datos');
    }
    final collection = _db?.collection('reports');
    try {
      await collection?.insert(report.toMap());
    } catch (e) {
      throw Exception('Error al insertar reporte: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllReports() async {
    final collection = _db?.collection('reports');
    try {
      final reports = await collection?.find().toList() ?? [];
      return reports;
    } catch (e) {
      throw Exception('Error al obtener reportes: $e');
    }
  }
}
