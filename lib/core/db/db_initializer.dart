import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle, MissingPluginException;
import 'package:path_provider/path_provider.dart';

class DbInitializer {
  static const String _assetDbPath = 'assets/bd/etic_system.db';
  static const String _targetSubdir = 'bd';
  static const String _fileName = 'etic_system.db';

  /// Copia la BD desde assets al dispositivo si no existe.
  /// Devuelve la ruta final del archivo en el dispositivo.
  static Future<String> ensureDatabaseCopied() async {
    if (kIsWeb) {
      // En web no hay sistema de archivos local persistente para este uso.
      debugPrint('DbInitializer: omitido en Web');
      return _assetDbPath;
    }

    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final bdDir = Directory('${docsDir.path}/$_targetSubdir');
      if (!await bdDir.exists()) {
        await bdDir.create(recursive: true);
      }

      final dbPath = '${bdDir.path}/$_fileName';
      final dbFile = File(dbPath);
      if (await dbFile.exists()) {
        return dbPath;
      }

      final byteData = await rootBundle.load(_assetDbPath);
      final bytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      await dbFile.writeAsBytes(bytes, flush: true);
      return dbPath;
    } on MissingPluginException catch (e) {
      // Fallback si el plugin aún no está registrado (p.ej., hot reload tras agregar dependencia).
      debugPrint('DbInitializer: MissingPluginException: $e');
      final tmp = Directory.systemTemp;
      final bdDir = Directory('${tmp.path}/$_targetSubdir');
      if (!await bdDir.exists()) {
        await bdDir.create(recursive: true);
      }
      final dbPath = '${bdDir.path}/$_fileName';
      final dbFile = File(dbPath);
      if (!await dbFile.exists()) {
        final byteData = await rootBundle.load(_assetDbPath);
        final bytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
        await dbFile.writeAsBytes(bytes, flush: true);
      }
      return dbPath;
    }
  }
}
