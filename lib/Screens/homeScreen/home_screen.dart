import 'package:app/repositories/customer_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app/Screens/homeScreen/accounting/accounting.dart';
import 'package:app/Screens/homeScreen/customers/customers.dart';
import 'package:app/Screens/homeScreen/goals/goals.dart';
import 'package:app/Screens/homeScreen/invoice/invoice.dart';
import 'package:app/Screens/homeScreen/partners/partners.dart';
import 'package:app/Screens/homeScreen/project/project.dart';
import 'package:app/Screens/homeScreen/project/interactive_map.dart';

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

  // Initialize your customerRepo here, passing the customerBox and localDb
  final customerRepo = CustomerRepository(customerBox: customerBox);

  // Run the app and pass customerRepo
  runApp(MyApp(customerRepo: customerRepo));
}

class MyApp extends StatelessWidget {
  final CustomerRepository customerRepo;

  MyApp({required this.customerRepo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(customerRepo: customerRepo),
        '/partners': (context) => PartnersScreen(
              partnerBox: Hive.box('partnerBox'),
            ),
        '/customers': (context) => CustomersScreen(
              customerRepo: customerRepo,
            ),
        '/accounting': (context) => AccountingScreen(
              accountingBox: Hive.box('accountingBox'),
            ),
        '/invoice': (context) => InvoiceScreen(
              invoiceBox: Hive.box('invoiceBox'),
            ),
        '/project': (context) => HydroponicBedsScreen(
              projectBox: Hive.box('projectBox'),
            ),
        '/goals': (context) => GoalsApp(
              goalsBox: Hive.box('goalsBox'),
              customerRepo: customerRepo,
            ),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  final CustomerRepository customerRepo;

  HomeScreen({required this.customerRepo});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HydroponicBedsScreen(projectBox: Hive.box('projectBox')),
    InteractiveMapScreen(),
    AccountingScreen(accountingBox: Hive.box('accountingBox')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Colors.orange[300],
              child: const Text(
                'L',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 4),
            CircleAvatar(
              backgroundColor: Colors.blue[300],
              child: const Text(
                'S',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 4),
            CircleAvatar(
              backgroundColor: Colors.green[300],
              child: const Text(
                'N',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // no actions
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Beds',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Accounting',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
