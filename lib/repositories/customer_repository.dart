import 'package:hive/hive.dart'; // Assuming you're using Hive for local storage
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// CustomerRepository class to interact with local database (Hive) and any remote databases
class CustomerRepository {
  final Box customerBox;

  // Constructor to accept localDb and customerBox
  CustomerRepository({required this.customerBox});

  // Add a new customer
  Future<void> addCustomer(Customer customer) async {
    // Logic to save customer (e.g., via Supabase or SQLite)
    print('Customer added: ${customer.name}');

    // Save customer in Hive (customerBox)
    await customerBox.add({
      'name': customer.name,
      'contactNumber': customer.contactNumber,
      'email': customer.email,
      'address': customer.address,
    });
  }

  // Retrieve a list of customers
  Future<List<Customer>> getCustomers() async {
    final customersData =
        customerBox.values.map((e) => Map<String, dynamic>.from(e)).toList();
    return customersData.map((data) {
      return Customer(
        name: data['name'],
        contactNumber: data['contactNumber'],
        email: data['email'],
        address: data['address'],
        idNit: data['ID/NIT'],
        id: '',
        uniqueCode: '',
        contact: '',
        isSynced: false,
      );
    }).toList();
  }

  // Sync unsent customers with a remote server (e.g., Supabase, Firebase, etc.)
  Future<void> syncUnsentCustomers() async {
    List<Customer> customers = await getCustomers();

    for (var customer in customers) {
      print('Syncing customer: ${customer.name}');
      // Simulate syncing process to a remote server
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

class HomeScreen extends StatelessWidget {
  final CustomerRepository customerRepo;

  HomeScreen({required this.customerRepo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customer Management')),
      body: Center(child: Text('Welcome to the Customer App!')),
    );
  }
}
