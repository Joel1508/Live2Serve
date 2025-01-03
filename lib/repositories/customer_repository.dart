import 'package:app/Screens/homeScreen/home_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class CustomerRepository {
  final Box customerBox;

  CustomerRepository({required this.customerBox});

  Future<void> addCustomer(Customer customer) async {
    await customerBox.add(customer);
  }

  Future<List<Customer>> getCustomers() async {
    return customerBox.values.cast<Customer>().toList();
  }

  Future<void> syncUnsentCustomers() async {
    List<Customer> customers = await getCustomers();
    for (var customer in customers) {
      print('Syncing customer: ${customer.name}');
    }
  }
}

// Main function to initialize the app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and open required boxes
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  await Hive.openBox('customerBox');
  await Hive.openBox('partnerBox');
  await Hive.openBox('accountingBox');
  await Hive.openBox('invoiceBox');
  await Hive.openBox('projectBox');
  await Hive.openBox('goalsBox');

  // Get the opened customerBox
  var customerBox = Hive.box('customerBox');

  // Initialize your customerRepo, passing customerBox and localDb
  final customerRepo = CustomerRepository(customerBox: customerBox);

  // Run the app and pass customerRepo
  runApp(MyApp(customerRepo: customerRepo));
}

class MyApp extends StatelessWidget {
  final CustomerRepository customerRepo;

  // Constructor to accept customerRepo
  MyApp({required this.customerRepo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(customerRepo: customerRepo),
        // other routes...
      },
    );
  }
}

class LocalDatabase {
  // Example methods for inserting and retrieving customers from local database (SQLite or any other DB)
  Future<void> insertCustomer(Map<String, dynamic> customerData) async {
    // Insert customer data into the local DB (e.g., SQLite)
    print('Customer inserted into local DB: $customerData');
  }

  Future<List<Map<String, dynamic>>> getCustomers() async {
    // Fetch customers from local DB (e.g., SQLite)
    return [
      {
        'name': 'John Doe',
        'contactNumber': '1234567890',
        'email': 'john@example.com',
        'address': '123 Main St',
        'ID/NIT': '123456'
      },
      // Add more mock data as needed
    ];
  }
}

class Customer {
  final String name;
  final String contactNumber;
  final String email;
  final String address;
  final String idNit;
  final String id;
  final String uniqueCode;
  final String contact;
  final bool isSynced;

  // Constructor for Customer class
  Customer({
    required this.name,
    required this.contactNumber,
    required this.email,
    required this.address,
    required this.idNit,
    required this.id,
    required this.uniqueCode,
    required this.contact,
    required this.isSynced,
  });
}
