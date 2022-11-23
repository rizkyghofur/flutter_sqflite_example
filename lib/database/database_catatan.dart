// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/catatan.dart';

class DatabaseCatatan {
  static final DatabaseCatatan instance = DatabaseCatatan._init();

  static Database? _database;

  DatabaseCatatan._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableCatatan ( 
  ${CatatanFields.id} $idType, 
  ${CatatanFields.isImportant} $boolType,
  ${CatatanFields.number} $integerType,
  ${CatatanFields.title} $textType,
  ${CatatanFields.description} $textType,
  ${CatatanFields.time} $textType
  )
''');
  }

  Future<Catatan> create(Catatan note) async {
    final db = await instance.database;

    final id = await db.insert(tableCatatan, note.toJson());
    return note.copy(id: id);
  }

  Future<Catatan> readCatatan(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCatatan,
      columns: CatatanFields.values,
      where: '${CatatanFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Catatan.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Catatan>> readAllCatatan() async {
    final db = await instance.database;

    const orderBy = '${CatatanFields.time} ASC';

    final result = await db.query(tableCatatan, orderBy: orderBy);

    return result.map((json) => Catatan.fromJson(json)).toList();
  }

  Future<int> update(Catatan note) async {
    final db = await instance.database;

    return db.update(
      tableCatatan,
      note.toJson(),
      where: '${CatatanFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableCatatan,
      where: '${CatatanFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
