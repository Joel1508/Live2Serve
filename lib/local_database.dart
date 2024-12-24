import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  final Box customerBox;
  static Database? _database;

  LocalDatabase({required this.customerBox});

  // Initialize the database
  Future<void> init() async {
    if (_database != null) {
      return; // Return if the database is already initialized
    }

    // Get the application's documents directory
    final appDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDir.path, 'customer_db.db');

    // Open the database
    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        // Create the table when the database is first created
        db.execute('''
          CREATE TABLE customers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            contactNumber TEXT,
            email TEXT,
            address TEXT
          )
        ''');
      },
    );
  }

  // Insert customer data into the customerBox (Hive)
  Future<void> insertCustomer(Map<String, dynamic> customerData) async {
    await customerBox.add(customerData);
  }

  // Retrieve customers from the customerBox (Hive)
  Future<List<Map<String, dynamic>>> getCustomers() async {
    return customerBox.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // Insert customer data into the SQLite database
  Future<void> insertCustomerSQLite(Map<String, dynamic> customerData) async {
    final db = await _database;
    if (db == null) return;

    await db.insert(
      'customers',
      customerData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve customers from the SQLite database
  Future<List<Map<String, dynamic>>> getCustomersSQLite() async {
    final db = await _database;
    if (db == null) return [];

    return await db.query('customers');
  }
}
