import 'package:etic_mobile/features/auth/domain/credentials.dart';
import 'package:etic_mobile/shared/db/app_database.dart';
import 'package:sqflite/sqflite.dart';

class SqliteAuthRepository {
  Future<bool> login(Credentials credentials) async {
    final Database db = await AppDatabase.instance;

    // Asumimos tabla 'usuarios' con columnas 'usuario' y 'password'.
    final res = await db.query(
      'usuarios',
      columns: ['usuario'],
      where: 'LOWER(usuario) = ? AND password = ?',
      whereArgs: [credentials.email.trim().toLowerCase(), credentials.password],
      limit: 1,
    );

    return res.isNotEmpty;
  }

  Future<void> logout() async {
    // No se requiere estado en DB para logout local.
  }
}

