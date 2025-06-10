// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart';
// import 'dart:io';
//
// class SQLiteService {
//   static final SQLiteService _instance = SQLiteService._internal();
//   factory SQLiteService() => _instance;
//   SQLiteService._internal();
//
//   static Database? _database;
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDb();
//     return _database!;
//   }
//
//   Future<Database> _initDb() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, "focus_forge.db");
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }
//
//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE user_settings (
//         key TEXT PRIMARY KEY,
//         value TEXT
//       )
//     ''');
//     // Tambahkan tabel lain di sini jika diperlukan nanti
//   }
//
//   // Contoh: Menyimpan pengaturan
//   Future<void> saveSetting(String key, String value) async {
//     final db = await database;
//     await db.insert(
//       'user_settings',
//       {'key': key, 'value': value},
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   // Contoh: Mengambil pengaturan
//   Future<String?> getSetting(String key) async {
//     final db = await database;
//     List<Map<String, dynamic>> maps = await db.query(
//       'user_settings',
//       where: 'key = ?',
//       whereArgs: [key],
//     );
//     if (maps.isNotEmpty) {
//       return maps.first['value'] as String?;
//     }
//     return null;
//   }
// }