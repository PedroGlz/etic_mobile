import 'package:sqflite/sqflite.dart';
import 'package:etic_mobile/core/db/db_initializer.dart';

class AppDatabase {
  AppDatabase._();

  static Database? _instance;

  static Future<Database> get instance async {
    if (_instance != null) return _instance!;
    final path = await DbInitializer.ensureDatabaseCopied();
    _instance = await openDatabase(path);
    return _instance!;
  }

  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }
}
