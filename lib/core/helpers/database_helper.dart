import 'dart:math';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'restaurant.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tables (
        id INTEGER PRIMARY KEY,
        name TEXT,
        room_type TEXT,
        status TEXT,
        number_of_guests INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE food_categories (
        id INTEGER PRIMARY KEY,
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE food (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER,
        name TEXT,
        price REAL,
        image TEXT,
        FOREIGN KEY(category_id) REFERENCES food_categories(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        table_id INTEGER,
        order_number TEXT,
        status TEXT,
        FOREIGN KEY(table_id) REFERENCES tables(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER,
        food_id INTEGER,
        quantity INTEGER,
        FOREIGN KEY(order_id) REFERENCES orders(id),
        FOREIGN KEY(food_id) REFERENCES food(id)
      )
    ''');

    for (int i = 1; i <= 19; i++) {
      await db.insert('tables', {
        'id': i,
        'name': 'T$i',
        'room_type': 'inner',
        'status': 'available',
        'number_of_guests': 0,
      });
    }
    for (int i = 20; i <= 38; i++) {
      await db.insert('tables', {
        'id': i,
        'name': 'T${i - 19}',
        'room_type': 'outer',
        'status': 'available',
        'number_of_guests': 0,
      });
    }

    final categories = [
      'BENTO BOX',
      'BUILD YOUR OWN RAMEN',
      'CHEESECAKE SERIES',
      'DESSERTS',
      'DRINKS',
      'EXTRAS',
      'FRUIT TEA',
      'HANG-IN RAMEN',
      'JAM MILKY',
      'JAPANESE GRILLE',
      'KID MENU',
      'LEMONADE PARADISE'
    ];

    for (var i = 0; i < categories.length; i++) {
      await db.insert('food_categories', {'id': i + 1, 'name': categories[i]});
    }
  }

  Future<void> insertRandomFoodItems() async {
    final db = await database;
    final foodItems = {
      1: ['Chicken Bento', 'Beef Bento', 'Vegetarian Bento'],
      2: ['Shoyu Ramen', 'Tonkotsu Ramen', 'Miso Ramen'],
      3: [
        'Classic Cheesecake',
        'Strawberry Cheesecake',
        'Chocolate Cheesecake'
      ],
      4: ['Mochi', 'Dorayaki', 'Taiyaki'],
      5: ['Green Tea', 'Sake', 'Matcha Latte'],
      6: ['Extra Noodles', 'Extra Soup', 'Extra Toppings'],
      7: ['Mango Tea', 'Peach Tea', 'Lychee Tea'],
      8: ['Spicy Ramen', 'Mild Ramen', 'Salty Ramen'],
      9: ['Milk Tea', 'Taro Milk', 'Honeydew Milk'],
      10: ['Grilled Fish', 'Grilled Chicken', 'Grilled Beef'],
      11: ['Kid Ramen', 'Kid Bento', 'Kid Dessert'],
      12: ['Classic Lemonade', 'Strawberry Lemonade', 'Blueberry Lemonade'],
    };

    final random = Random();

    for (var categoryId in foodItems.keys) {
      for (var itemName in foodItems[categoryId]!) {
        final price = (random.nextDouble() * 10) + 5;
        await db.insert('food', {
          'category_id': categoryId,
          'name': itemName,
          'price': price,
          'image': 'path/to/image'
        });
      }
    }
  }

  Future<List<Map<String, dynamic>>> getTables(String roomType) async {
    final db = await database;
    return await db
        .query('tables', where: 'room_type = ?', whereArgs: [roomType]);
  }

  Future<List<Map<String, dynamic>>> getFoodCategories() async {
    final db = await database;
    return await db.query('food_categories');
  }

  Future<List<Map<String, dynamic>>> getFoodItems(int categoryId) async {
    final db = await database;
    return await db
        .query('food', where: 'category_id = ?', whereArgs: [categoryId]);
  }

  Future<List<Map<String, dynamic>>> getAllFoodItems() async {
    final db = await database;
    return await db.query('food');
  }

  // Future<List<Map<String, dynamic>>> getAllTableNames() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> result = await db.rawQuery(
  //       "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';");
  //   return result.map((row) => row['name'] as String).toList();
  // }

  Future<List<Map<String, dynamic>>> getAllFoodTableValues() async {
    final db = await database;
    return await db.query('food');
  }

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    final db = await database;
    return await db.query('food_categories');
  }

  Future<int> createOrder(int tableId, String orderNumber) async {
    final db = await database;
    return await db.insert('orders', {
      'table_id': tableId,
      'order_number': orderNumber,
      'status': 'pending',
    });
  }

  Future<void> addOrderItem(int orderId, int foodId, int quantity) async {
    final db = await database;
    await db.insert('order_items', {
      'order_id': orderId,
      'food_id': foodId,
      'quantity': quantity,
    });
  }

  Future<void> updateOrderItem(int orderItemId, int quantity) async {
    final db = await database;
    await db.update(
      'order_items',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [orderItemId],
    );
  }

  Future<List<Map<String, dynamic>>> getOrderItems(int orderId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT order_items.quantity, food.name, food.price 
      FROM order_items 
      INNER JOIN food ON order_items.food_id = food.id 
      WHERE order_items.order_id = ?
    ''', [orderId]);
  }

  Future<Map<String, dynamic>?> getOrderItem(int orderId, int foodId) async {
    final db = await database;
    final result = await db.query(
      'order_items',
      where: 'order_id = ? AND food_id = ?',
      whereArgs: [orderId, foodId],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllOrders() async {
    final db = await database;
    return await db.query('orders');
  }
}
