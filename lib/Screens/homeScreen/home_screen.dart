import 'package:app/Screens/homeScreen/add_client_invoice.dart';
import 'package:app/Screens/homeScreen/harvest_invoice.dart';
import 'package:app/Screens/homeScreen/customers/models/customer_model.dart';
import 'package:app/Screens/homeScreen/goals/goal.dart';
import 'package:app/Screens/homeScreen/goals/goals.dart';
import 'package:app/Screens/homeScreen/harvest_invoice_model.dart';
import 'package:app/Screens/homeScreen/invoice/models/invoice_model.dart';
import 'package:app/Screens/homeScreen/invoice/services/invoice_service.dart';
import 'package:app/Screens/homeScreen/project/bed_model.dart';
import 'package:app/Screens/homeScreen/user_settings/user.dart';
import 'package:app/repositories/customer_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app/Screens/homeScreen/accounting/accounting.dart';
import 'package:app/Screens/homeScreen/customers/customers.dart';
import 'package:app/Screens/homeScreen/invoice/invoice.dart';
import 'package:app/Screens/homeScreen/partners/partners.dart';
import 'package:app/Screens/homeScreen/project/project.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and open required boxes
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  Hive.registerAdapter(InvoiceAdapter());

  // Open the boxes only once in the main function
  var customerBox = await Hive.openBox<CustomerModel>('customerBox');
  var partnerBox = await Hive.openBox('partnerBox');
  var accountingBox = await Hive.openBox('accountingBox');
  var invoiceBox = await Hive.openBox<Invoice>('invoiceBox');
  var projectBox = await Hive.openBox<BedModel>('projectBox');
  final Box<Goal> goalsBox = await Hive.openBox<Goal>('goalsBox');

  // Initialize your customerRepo here, passing the customerBox
  final customerRepo = CustomerRepository(customerBox: customerBox);

  // Run the app and pass customerRepo and the opened boxes
  runApp(MyApp(
    customerRepo: customerRepo,
    partnerBox: partnerBox,
    accountingBox: accountingBox,
    invoiceBox: invoiceBox,
    projectBox: projectBox,
    goalsBox: goalsBox,
  ));
}

class MyApp extends StatelessWidget {
  final CustomerRepository customerRepo;
  final Box partnerBox;
  final Box accountingBox;
  final Box<Invoice> invoiceBox;
  final Box<BedModel> projectBox;
  final Box<Goal> goalsBox;

  // Constructor
  MyApp({
    required this.customerRepo,
    required this.partnerBox,
    required this.accountingBox,
    required this.invoiceBox,
    required this.projectBox,
    required this.goalsBox,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/home_screen': (context) => HomeScreen(
              customerRepo: customerRepo,
              projectBox: projectBox, // Pass projectBox here
            ),
        '/partners': (context) => PartnersScreen(partnerBox: partnerBox),
        '/customers': (context) => CustomersScreen(customerRepo: customerRepo),
        '/accounting': (context) => AccountingScreen(
              accountingBox: accountingBox,
              customerRepo: customerRepo,
            ),
        '/invoice': (context) => InvoiceScreen(),
        '/project': (context) =>
            HydroponicBedsScreen(projectBox: projectBox), // Use projectBox here
        '/goals': (context) => GoalsScreen(
              goalsBox: goalsBox,
              customerRepo: customerRepo,
            ),
        '/user': (context) => UserScreen(),
        '/add_client_invoice': (context) => InvoiceClientScreen(
              onInvoiceSaved: (InvoiceModel) {},
            ),
        '/add_tool': (context) => HarvestInvoiceScreen(
              onInvoiceSaved: (invoice) {
                print('Invoice saved: $invoice');
              },
              costsBox: Hive.box<HarvestCost>('harvest_cost'),
            ),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  final CustomerRepository customerRepo;
  final Box<BedModel> projectBox;

  HomeScreen({required this.customerRepo, required this.projectBox});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HydroponicBedsScreen(projectBox: widget.projectBox),
      AccountingScreen(
          accountingBox: Hive.box('accountingBox'),
          customerRepo: widget.customerRepo),
    ];
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      // Show add options bottom sheet
      _showAddOptions();
    } else if (index == 2) {
      // Navigate to user profile
      Navigator.pushNamed(context, '/user');
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add New',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.receipt, color: Colors.blue),
                title: Text('Client Invoice'),
                onTap: () async {
                  Navigator.pop(context); // Close the bottom sheet
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InvoiceClientScreen(
                        onInvoiceSaved: (Invoice invoice) async {
                          try {
                            await InvoiceService.instance.addInvoice(invoice);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Invoice saved successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to save invoice: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.nature, color: Colors.green),
                title: Text('Harvest Invoice'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/add_tool');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9FAFB),
        leadingWidth: 150,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Color(0xFFFFDBDD5),
                  child: const Text(
                    'L',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.blue[100],
                  child: const Text(
                    'S',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.blue[100],
                  child: const Text(
                    'N',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
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
            onPressed: () => Navigator.pushNamed(context, '/user'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Key Metrics Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Key Metrics',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          // Horizontal containers for Key Metrics
          Container(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildContainer('Container 1'),
                _buildContainer('Container 2'),
                _buildContainer('Container 3'),
              ],
            ),
          ),
          // Features Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Features',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          // 3x2 grid of feature cards
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _buildFeatureCard('Customers', Icons.person),
                  _buildFeatureCard('Partners', Icons.group),
                  _buildFeatureCard('Project', Icons.business),
                  _buildFeatureCard('Accounting', Icons.account_balance_wallet),
                  _buildFeatureCard('Bill History', Icons.history),
                  _buildFeatureCard('Goals', Icons.flag),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildContainer(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Container(
        width: 360,
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(child: Text(title)),
      ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon) {
    return InkWell(
      onTap: () {
        switch (title) {
          case 'Customers':
            Navigator.pushNamed(context, '/customers');
            break;
          case 'Partners':
            Navigator.pushNamed(context, '/partners');
            break;
          case 'Project':
            Navigator.pushNamed(context, '/project');
            break;
          case 'Accounting':
            Navigator.pushNamed(context, '/accounting');
            break;
          case 'Bill History':
            Navigator.pushNamed(context, '/invoice');
            break;
          case 'Goals':
            Navigator.pushNamed(context, '/goals');
            break;
        }
      },
      child: Card(
        color: Colors.blue[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
