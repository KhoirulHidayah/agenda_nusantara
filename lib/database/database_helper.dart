import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/tugas.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('agenda_nusantara.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // TABEL TUGAS
    await db.execute('''
      CREATE TABLE tugas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        judul TEXT NOT NULL,
        deskripsi TEXT,
        tanggal_jatuh_tempo TEXT NOT NULL,
        kategori TEXT NOT NULL,
        selesai INTEGER NOT NULL DEFAULT 0,
        tanggal_dibuat TEXT NOT NULL
      )
    ''');

    // TABEL PENGATURAN
    await db.execute('''
      CREATE TABLE pengaturan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kunci TEXT NOT NULL UNIQUE,
        nilai TEXT NOT NULL
      )
    ''');

    // DATA LOGIN DEFAULT
    await db.insert('pengaturan', {
      'kunci': 'username',
      'nilai': 'user',
    });

    await db.insert('pengaturan', {
      'kunci': 'password',
      'nilai': 'user',
    });

    print('Database berhasil dibuat');
    print('Username: user');
    print('Password: user');
  }

  // ─────────────────────────────────────────────
  // TUGAS
  // ─────────────────────────────────────────────

  Future<int> insertTugas(Tugas tugas) async {
    final db = await database;
    return await db.insert('tugas', tugas.toMap());
  }

  Future<List<Tugas>> getAllTugas() async {
    final db = await database;

    final result = await db.query(
      'tugas',
      orderBy: 'tanggal_jatuh_tempo DESC',
    );

    return result.map((m) => Tugas.fromMap(m)).toList();
  }

  Future<void> updateSelesai(int id, bool selesai) async {
    final db = await database;

    await db.update(
      'tugas',
      {
        'selesai': selesai ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, int>> getStatistik() async {
    final db = await database;

    final selesai = Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM tugas WHERE selesai = 1',
          ),
        ) ??
        0;

    final belum = Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM tugas WHERE selesai = 0',
          ),
        ) ??
        0;

    return {
      'selesai': selesai,
      'belum': belum,
    };
  }

  Future<Map<String, int>> getTugasSelesaiPerHari() async {
    final db = await database;

    final rows = await db.rawQuery('''
      SELECT tanggal_dibuat, COUNT(*) AS total
      FROM tugas
      WHERE selesai = 1
      GROUP BY tanggal_dibuat
      ORDER BY tanggal_dibuat DESC
      LIMIT 7
    ''');

    return {
      for (final r in rows)
        r['tanggal_dibuat'] as String: r['total'] as int,
    };
  }

  // ─────────────────────────────────────────────
  // PENGATURAN
  // ─────────────────────────────────────────────

  Future<String?> getPengaturan(String kunci) async {
    final db = await database;

    final rows = await db.query(
      'pengaturan',
      where: 'kunci = ?',
      whereArgs: [kunci],
    );

    if (rows.isEmpty) return null;

    return rows.first['nilai'] as String;
  }

  Future<void> setPengaturan(String kunci, String nilai) async {
    final db = await database;

    await db.insert(
      'pengaturan',
      {
        'kunci': kunci,
        'nilai': nilai,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

