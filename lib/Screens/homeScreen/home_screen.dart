import 'package:app/repositories/customer_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app/Screens/homeScreen/accounting/accounting.dart';
import 'package:app/Screens/homeScreen/add_tool.dart';
import 'package:app/Screens/homeScreen/customers/customers.dart';
import 'package:app/Screens/homeScreen/goals/goals.dart';
import 'package:app/Screens/homeScreen/invoice/invoice.dart';
import 'package:app/Screens/homeScreen/partners/partners.dart';
import 'package:app/Screens/homeScreen/project/project.dart';
import 'package:app/Screens/homeScreen/settings.dart';
import 'package:app/Screens/homeScreen/user.dart';

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
            ),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final CustomerRepository customerRepo;

  HomeScreen({required this.customerRepo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDEDCDD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: const Text(
            'JA',
            style: TextStyle(color: Colors.black),
          ),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Key metrics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 200,
            child: PageView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildPlaceholderCard('Accounts Graph Placeholder'),
                _buildPlaceholderCard('Card Details Placeholder'),
                _buildPlaceholderCard('Stock Metrics Placeholder'),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildGridButton(context, 'Customers', '/customers'),
                  _buildGridButton(context, 'Partners', '/partners'),
                  _buildGridButton(context, 'Project', '/project'),
                  _buildGridButton(context, 'Accounting', '/accounting'),
                  _buildGridButton(context, 'Bill history', '/invoice'),
                  _buildGridButton(context, 'Goals', '/goals'),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddToolScreen()),
                );
              },
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserScreen()));
        },
      ),
    );
  }

  Widget _buildGridButton(BuildContext context, String label, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(text),
      ),
    );
  }
}
