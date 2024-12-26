import 'package:attendance_ktp/features/model/employee_model.dart';
import 'package:attendance_ktp/features/model/response_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _dBService = DatabaseService._internal();
  factory DatabaseService() => _dBService;
  DatabaseService._internal();
  final uuid = const Uuid();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'employee_database.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // When the database is first created, create a table to store user
  // and a table to store users.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE employee(_id TEXT PRIMARY KEY, name TEXT, sak TEXT, standard TEXT, created_on TEXT, updated_on TEXT)',
    );
  }

  Future<List<EmployeeModel>> getAllNote() async {
    final db = await _dBService.database;
    List<EmployeeModel> res = [];
    // Calculate the date range for the last 7 days
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    // Query the database with a date filter
    List<Map<String, Object?>> result = await db.query(
      'employee',
      where: 'created_on >= ?',
      whereArgs: [sevenDaysAgo.toString()],
    );
    for (var e in result) {
      res.add(
        EmployeeModel(
          id: e['_id']?.toString() ?? '',
          name: e['name']?.toString() ?? '',
          sak: e['sak']?.toString() ?? '',
          standard: e['standard']?.toString() ?? '',
          createdOn: e['created_on'] != null
              ? DateTime.tryParse(e['created_on'].toString()) ?? DateTime.now()
              : DateTime.now(),
          updatedOn: e['updated_on'] != null
              ? DateTime.tryParse(e['updated_on'].toString()) ?? DateTime.now()
              : DateTime.now(),
        ),
      );
    }
    return res;
  }

  Future<EmployeeModel> getNoteById(String id) async {
    final db = await _dBService.database;
    // Query berdasarkan ID
    List<Map<String, Object?>> result = await db.query(
      'employee',
      where: '_id = ?',
      whereArgs: [id],
    );
    // Jika tidak ditemukan, kembalikan null
    if (result.isEmpty) return EmployeeModel();
    // Ambil data pertama dari hasil
    var e = result.first;

    return EmployeeModel(
      id: e['_id']?.toString() ?? '',
      name: e['name']?.toString() ?? '',
      sak: e['sak']?.toString() ?? '',
      standard: e['standard']?.toString() ?? '',
      createdOn: e['created_on'] != null
          ? DateTime.tryParse(e['created_on'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedOn: e['updated_on'] != null
          ? DateTime.tryParse(e['updated_on'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Future<ResponseModel> createEmployee(EmployeeModel dt) async {
    try {
      final db = await _dBService.database;
      // Cek apakah data dengan id, sak, dan standard sudah ada
      final List<Map<String, dynamic>> existingData = await db.query(
        'employee',
        where: '_id = ? AND sak = ? AND standard = ?',
        whereArgs: [dt.id, dt.sak, dt.standard],
      );

      if (existingData.isNotEmpty) {
        // Jika ditemukan data duplikat, kembalikan error
        return ResponseModel(
          isSucces: false,
          message: 'Data dengan ID, SAK, dan Standard yang sama sudah ada.',
        );
      }
      await db.insert(
        'employee',
        dt.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return ResponseModel(
          isSucces: true, message: 'Employee Berhasil disimpan');
    } catch (e) {
      return ResponseModel(isSucces: false, message: 'Error: $e');
    }
  }

  Future<ResponseModel> updateEmployee(EmployeeModel updatedNote) async {
    try {
      final db = await _dBService.database;
      final result = await db.update(
        'employee',
        updatedNote.toMap(),
        where: '_id = ?',
        whereArgs: [updatedNote.id],
      );
      if (result > 0) {
        return ResponseModel(isSucces: true, message: 'Update Berhasil');
      } else {
        return ResponseModel(isSucces: false, message: 'Update Gagal');
      }
    } catch (e) {
      return ResponseModel(isSucces: false, message: 'Error $e');
    }
  }

  Future<ResponseModel> deleteEmployee(String id) async {
    final db = await _dBService.database;
    // Query untuk memastikan data ada
    List<Map<String, Object?>> result = await db.query(
      'employee',
      where: '_id = ?',
      whereArgs: [id], // Tidak perlu konversi karena _id sudah TEXT
    );

    if (result.isEmpty) {
      return ResponseModel(
          isSucces: false, message: 'Data not found'); // Data tidak ditemukan
    }

    // Jika data ditemukan, hapus
    await db.delete(
      'employee',
      where: '_id = ?',
      whereArgs: [id], // Hapus berdasarkan _id
    );

    return ResponseModel(isSucces: true, message: 'Deleted successfully');
  }
}
