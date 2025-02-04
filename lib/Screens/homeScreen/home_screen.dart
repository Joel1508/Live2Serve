import 'package:FRES.CO/Screens/homeScreen/add_client_invoice.dart';
import 'package:FRES.CO/Screens/homeScreen/harvest_invoice.dart';
import 'package:FRES.CO/Screens/homeScreen/customers/models/customer_model.dart';
import 'package:FRES.CO/Screens/homeScreen/goals/goal.dart';
import 'package:FRES.CO/Screens/homeScreen/goals/goals.dart';
import 'package:FRES.CO/Screens/homeScreen/harvest_invoice_model.dart';
import 'package:FRES.CO/Screens/homeScreen/invoice/models/invoice_model.dart';
import 'package:FRES.CO/Screens/homeScreen/invoice/services/invoice_service.dart';
import 'package:FRES.CO/Screens/homeScreen/project/models/bed_model.dart';
import 'package:FRES.CO/Screens/homeScreen/user_settings/user.dart';
import 'package:FRES.CO/repositories/customer_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:FRES.CO/Screens/homeScreen/accounting/accounting.dart';
import 'package:FRES.CO/Screens/homeScreen/customers/customers.dart';
import 'package:FRES.CO/Screens/homeScreen/invoice/invoice.dart';
import 'package:FRES.CO/Screens/homeScreen/partners/partners.dart';
import 'package:FRES.CO/Screens/homeScreen/project/project.dart';

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
        '/': (context) => HomeScreen(
              customerRepo: customerRepo,
              projectBox: projectBox,
            ),
        '/home_screen': (context) => HomeScreen(
              customerRepo: customerRepo,
              projectBox: projectBox,
            ),
        '/partners': (context) => PartnersScreen(partnerBox: partnerBox),
        '/customers': (context) => CustomersScreen(customerRepo: customerRepo),
        '/accounting': (context) => AccountingScreen(
              accountingBox: accountingBox,
              customerRepo: customerRepo,
            ),
        '/invoice': (context) => InvoiceScreen(),
        '/project': (context) => HydroponicBedsScreen(projectBox: projectBox),
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
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
          case '/home_screen':
            return MaterialPageRoute(
              builder: (context) => HomeScreen(
                customerRepo: customerRepo,
                projectBox: projectBox,
              ),
            );
          case '/partners':
            return MaterialPageRoute(
              builder: (context) => PartnersScreen(partnerBox: partnerBox),
            );
          case '/customers':
            return MaterialPageRoute(
              builder: (context) => CustomersScreen(customerRepo: customerRepo),
            );
          case '/accounting':
            return MaterialPageRoute(
              builder: (context) => AccountingScreen(
                accountingBox: accountingBox,
                customerRepo: customerRepo,
              ),
            );
          case '/invoice':
            return MaterialPageRoute(
              builder: (context) => InvoiceScreen(),
            );
          case '/project':
            return MaterialPageRoute(
              builder: (context) =>
                  HydroponicBedsScreen(projectBox: projectBox),
            );
          case '/goals':
            return MaterialPageRoute(
              builder: (context) => GoalsScreen(
                goalsBox: goalsBox,
                customerRepo: customerRepo,
              ),
            );
          case '/user':
            return MaterialPageRoute(
              builder: (context) => UserScreen(),
            );
          case '/add_client_invoice':
            return MaterialPageRoute(
              builder: (context) => InvoiceClientScreen(
                onInvoiceSaved: (invoice) {},
              ),
            );
          case '/add_tool':
            return MaterialPageRoute(
              builder: (context) => HarvestInvoiceScreen(
                onInvoiceSaved: (invoice) {
                  print('Invoice saved: $invoice');
                },
                costsBox: Hive.box<HarvestCost>('harvest_cost'),
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => HomeScreen(
                customerRepo: customerRepo,
                projectBox: projectBox,
              ),
            );
        }
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
      _showAddOptions();
    } else if (index == 2) {
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
                'Añadir nuevo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.receipt, color: Colors.blue),
                title: Text('Factura para cliente'),
                onTap: () async {
                  Navigator.pop(context);
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InvoiceClientScreen(
                        onInvoiceSaved: (Invoice invoice) async {
                          try {
                            await InvoiceService.instance.addInvoice(invoice);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Factura guardada exitosamente'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Error al guardar la factura: $e'),
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
                title: Text('Factura de cosecha'),
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
        backgroundColor: Color(0xFFFECEDEA),
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
        title: Image.asset(
          'assets/images/fresco.png',
          height: 30,
          fit: BoxFit.contain,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () => Navigator.pushNamed(context, '/user'),
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFFECEDEA),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Acciones rápidas',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black54),
              ),
              SizedBox(height: 32),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  children: [
                    _buildFeatureCard(
                        'Clientes', Icons.person, Colors.green[50]!),
                    _buildFeatureCard(
                        'Asociados', Icons.group, Colors.blue[50]!),
                    _buildFeatureCard(
                        'Proyecto', Icons.business, Colors.purple[50]!),
                    _buildFeatureCard('Contabilidad',
                        Icons.account_balance_wallet, Colors.orange[50]!),
                    _buildFeatureCard(
                        'Historial', Icons.history, Colors.red[50]!),
                    _buildFeatureCard('Metas', Icons.flag, Colors.teal[50]!),
                  ],
                ),
              ),
              SizedBox(
                height: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/images/model1.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFFECEDEA),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.black54,
              ),
              label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Añadir',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Usuario',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black54,
        unselectedItemColor: Colors.black54,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, Color backgroundColor) {
    return InkWell(
      onTap: () {
        switch (title) {
          case 'Clientes':
            Navigator.pushNamed(context, '/customers');
            break;
          case 'Asociados':
            Navigator.pushNamed(context, '/partners');
            break;
          case 'Proyecto':
            Navigator.pushNamed(context, '/project');
            break;
          case 'Contabilidad':
            Navigator.pushNamed(context, '/accounting');
            break;
          case 'Historial':
            Navigator.pushNamed(context, '/invoice');
            break;
          case 'Metas':
            Navigator.pushNamed(context, '/goals');
            break;
        }
      },
      child: Card(
        color: backgroundColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.lightBlue),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
