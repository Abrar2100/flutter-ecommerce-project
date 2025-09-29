import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CartDB {
  static final CartDB instance = CartDB._init();
  static Database? _database;

  CartDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cart.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE cart (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      product_id INTEGER,
      name TEXT,
      price REAL,
      quantity INTEGER,
      image TEXT
    )
    ''');
  }

  Future<int> addToCart(Map<String, dynamic> item) async {
    final db = await instance.database;
    return await db.insert('cart', item,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await instance.database;
    return await db.query('cart');
  }

  Future<int> updateQuantity(int id, int quantity) async {
    final db = await instance.database;
    return await db.update('cart', {'quantity': quantity},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<int> removeItem(int id) async {
    final db = await instance.database;
    return await db.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> clearCart() async {
    final db = await instance.database;
    return await db.delete('cart');
  }

  Future<void> deleteItem(int id) async {
  final db = await instance.database;
  await db.delete(
    'cart',
    where: 'id = ?',
    whereArgs: [id],
  );
}
}