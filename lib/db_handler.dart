import 'user.dart';
import 'orders.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  String dBName = 'gosend_clone_new.db';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initializedDB();
    return _database!;
  }

  Future<Database> initializedDB() async {
    Database db = await _getDB();

    return db;
    // String path = await getDatabasesPath();
    // return openDatabase(
    //   join(path, "gosend_clone_new.db"),
    //   onCreate: (database, version) async {

    //   },
    //   version: 1,
    // );
  }

  Future<Database> _getDB() async {
    final path = await _getPath(); // Get a location using getDatabasesPath

    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {users} TABLE statement on the database.
    await db.execute(
        "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT NOT NULL, nik INTEGER, pass TEXT NOT NULL, pic STRING)");
    await db.execute(
        "CREATE TABLE orders (id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT NOT NULL, iduser INTEGER NOT NULL,  isNew INTEGER NOT NULL, date INTEGER NOT NULL, lat1 DOUBLE, lang1 DOUBLE, lat2 DOUBLE, lang2 DOUBLE, picorder STRING)");
  }

  Future<String> _getPath() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dBName);
    return path;
  }

  Future<int> insertUser(User user) async {
    final Database db = await initializedDB();
    return await db.insert('users', user.toMap());
  }

  Future<int> insertOrder(Orders orders) async {
    final Database db = await initializedDB();
    return await db.insert('orders', orders.toMap());
  }

  Future<List<User>> getAllUsers() async {
    final Database db = await initializedDB();
    List<Map<String, dynamic>> result = await db.query('users');
    return result.map((e) => User.fromMap(e)).toList();
  }

  Future<User?> getLogin(String user, String password) async {
    final Database db = await initializedDB();

    var res = await db.rawQuery(
        "SELECT DISTINCT * FROM users WHERE nama = '$user' and pass = '$password'");

    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }

  Future<User> getLoginById(
    int userid,
  ) async {
    final Database db = await initializedDB();

    var res = await db.query('users', where: 'id = ?', whereArgs: [userid]);

    return User.fromMap(res.first);
  }

  Future<List<Orders>> getAllOrdersByStatus(int status, int iduser) async {
    final Database db = await initializedDB();
    List<Map<String, dynamic>> result = await db.query('orders',
        where: 'isNew=? and iduser=?', whereArgs: [status, iduser], limit: 50);

    return result.map((e) => Orders.fromMap(e)).toList();
  }

  Future<void> updateUserUsingHelper(User user) async {
    final Database db = await initializedDB();
    await db
        .update('users', user.toMap(), where: 'id= ?', whereArgs: [user.id]);
  }

  Future<void> updateOrderUsingHelper(Orders orders) async {
    final Database db = await initializedDB();
    await db.update('orders', orders.toMap(),
        where: 'id= ?', whereArgs: [orders.id]);
  }
}
