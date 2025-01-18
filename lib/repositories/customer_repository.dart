import 'package:app/Screens/homeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app/Screens/homeScreen/customers/models/customer_model.dart';
import 'package:app/Screens/homeScreen/project/bed_model.dart';

class CustomerRepository {
  final Box<CustomerModel> customerBox;

  CustomerRepository({required this.customerBox});

  Future<void> addCustomer(CustomerModel customer) async {
    await customerBox.add(customer);
  }

  Future<List<CustomerModel>> getCustomers() async {
    return customerBox.values.toList();
  }

  Future<void> syncUnsentCustomers() async {
    List<CustomerModel> customers = await getCustomers();
    for (var customer in customers) {
      print('Syncing customer: ${customer.name}');
    }
  }
}

// Main function to initialize the app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  // Register Hive Adapters
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(CustomerModelAdapter());
  }

  // Register other adapters if needed
  // if (!Hive.isAdapterRegistered(1)) {
  //   Hive.registerAdapter(BedModelAdapter());
  // }

  // Open typed boxes
  final customerBox = await Hive.openBox<CustomerModel>('customerBox');
  final projectBox = await Hive.openBox<BedModel>('projectBox');

  // Open other boxes
  await Hive.openBox('partnerBox');
  await Hive.openBox('accountingBox');
  await Hive.openBox('invoiceBox');
  await Hive.openBox('goalsBox');

  // Initialize your customerRepo
  final customerRepo = CustomerRepository(customerBox: customerBox);

  // Run the app and pass customerRepo
  runApp(MyApp(customerRepo: customerRepo, projectBox: projectBox));
}

class MyApp extends StatelessWidget {
  final CustomerRepository customerRepo;
  final Box<BedModel> projectBox;

  const MyApp({Key? key, required this.customerRepo, required this.projectBox})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) =>
            HomeScreen(customerRepo: customerRepo, projectBox: projectBox),
      },
    );
  }
}
