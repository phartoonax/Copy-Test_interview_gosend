import 'user.dart';
import 'orders.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> initializedDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, "gosend_clone.db"),
      onCreate: (database, version) async {
        await database.execute(
            "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT NOT NULL, nik INTEGER, pass TEXT NOT NULL, pic BLOB )");
        await database.execute(
            "CREATE TABLE orders (id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT NOT NULL, iduser INTEGER NOT NULL,  isNew INTEGER NOT NULL, date INTEGER NOT NULL, lat1 DOUBLE, lang1 DOUBLE, lat2 DOUBLE, lang2 DOUBLE, picorder BLOB)");
        User userutama = User(id: 0, name: 'DRIVER 1', password: '1234');
        Orders dummyOrder = Orders(
            id: 0,
            name: 'tes',
            idUser: 0,
            isnew: 1,
            dateEpoch: DateTime.now().millisecondsSinceEpoch);
        Orders dummyOrder2 = Orders(
            id: 1,
            name: 'tes 2',
            idUser: 0,
            isnew: 1,
            dateEpoch: DateTime.now().millisecondsSinceEpoch);
        insertUser(userutama).then((value) => print("Check 1 = $value"));
        insertOrder(dummyOrder).then((value) => print("Check 2 = $value"));
        insertOrder(dummyOrder2).then((value) => print("Check 2 = $value"));
      },
      version: 1,
    );
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
    List<Map<String, dynamic>> result =
        await db.query('orders', where: "isNew='$status'");

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
