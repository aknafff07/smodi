// lib/services/database_helper.dart

import 'package:sqflite/sqflite.dart'; // Untuk berinteraksi dengan SQLite
import 'package:path/path.dart';      // Untuk menggabungkan path database
import 'package:smodi/models/focus_session.dart'; // Impor model FocusSession kita

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  // Getter untuk mendapatkan instance database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  // Inisialisasi database
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath(); // Dapatkan path default untuk database
    final path = join(databasePath, 'focus_forge.db'); // Gabungkan path dengan nama database

    return await openDatabase(
      path,
      version: 1, // Versi database
      onCreate: _onCreate, // Callback saat database pertama kali dibuat
    );
  }

  // Callback saat database dibuat: membuat tabel focus_sessions
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE focus_sessions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        startTime TEXT NOT NULL,
        endTime TEXT NOT NULL,
        totalDurationSeconds INTEGER NOT NULL,
        focusedDurationSeconds INTEGER NOT NULL,
        distractedDurationSeconds INTEGER NOT NULL,
        focusPercentage REAL NOT NULL
      )
    ''');
  }

  // --- Metode CRUD (Create, Read) ---

  // Menambahkan sesi fokus baru
  Future<int> insertSession(FocusSession session) async {
    final db = await database;
    // Menggunakan `conflictAlgorithm: ConflictAlgorithm.replace` jika Anda ingin mengganti
    // sesi dengan ID yang sama. Biasanya untuk `insert`, tidak perlu.
    return await db.insert('focus_sessions', session.toMap());
  }

  // Mengambil semua sesi fokus
  Future<List<FocusSession>> getSessions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('focus_sessions', orderBy: 'startTime DESC'); // Urutkan dari yang terbaru

    return List.generate(maps.length, (i) {
      return FocusSession.fromMap(maps[i]);
    });
  }

  // Mengambil sesi fokus berdasarkan rentang tanggal (opsional, untuk fitur advance)
  Future<List<FocusSession>> getSessionsByDateRange(DateTime startDate, DateTime endDate) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'focus_sessions',
      where: 'startTime >= ? AND endTime <= ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'startTime DESC',
    );
    return List.generate(maps.length, (i) {
      return FocusSession.fromMap(maps[i]);
    });
  }

  // Menghitung total durasi fokus untuk semua sesi (contoh statistik)
  Future<int> getTotalFocusedDuration() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT SUM(focusedDurationSeconds) as total FROM focus_sessions');
    if (result.isNotEmpty && result[0]['total'] != null) {
      return result[0]['total'] as int;
    }
    return 0;
  }

  // Menghitung jumlah sesi
  Future<int> getSessionCount() async {
    final db = await database;
    final count = await db.rawQuery('SELECT COUNT(*) FROM focus_sessions');
    return Sqflite.firstIntValue(count) ?? 0;
  }

  // Anda bisa menambahkan metode lain seperti updateSession, deleteSession, dll.
  // Untuk tujuan F2, insert dan getSessions sudah cukup.

  // Tutup database (penting saat aplikasi ditutup)
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}