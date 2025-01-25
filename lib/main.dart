import 'package:app/index.dart';
import 'package:app/Screens/homeScreen/home_screen.dart';
import 'package:app/repositories/customer_repository.dart'
    show CustomerRepository;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Screens/homeScreen/customers/customers.dart' as customers_screen;
import 'Screens/homeScreen/partners/partners.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('transactions');
  Hive.init(directory.path);

  // Register adapters first
  _registerAdapters();

  // Initialize boxes with error handling
  final boxes = await _initializeBoxes();

  // Initialize repositories
  final customerRepo = CustomerRepository(
      customerBox: boxes['customerBox'] as Box<CustomerModel>);

  await Supabase.initialize(
    url: 'https://fqdpwiskvyiopqgxuaml.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZxZHB3aXNrdnlpb3BxZ3h1YW1sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM1MDM3MzYsImV4cCI6MjA0OTA3OTczNn0.dkxwbnUkKb2fcpzEFR2uoNCsY_f06wntVxWrZsuxt70',
  );

  runApp(MyApp(
    customerRepo: customerRepo,
    projectBox: boxes['projectBox'] as Box<BedModel>,
    invoiceBox: boxes['invoiceBox'] as Box<Invoice>,
  ));
}

void _registerAdapters() {
  Hive.registerAdapter(CustomerModelAdapter());
  Hive.registerAdapter(BedModelAdapter());
  Hive.registerAdapter(GoalAdapter());
  Hive.registerAdapter(InvoiceAdapter());
  Hive.registerAdapter(CostModelAdapter());
  Hive.registerAdapter(HarvestCostAdapter());
  Hive.registerAdapter(HarvestInvoiceAdapter());
}

Future<Map<String, Box>> _initializeBoxes() async {
  final boxes = <String, Box>{};

  try {
    boxes['customerBox'] = await Hive.openBox<CustomerModel>('customerBox');
    boxes['costs'] = await Hive.openBox<CostModel>('costs');
    boxes['costsBox'] = await Hive.openBox<HarvestCost>('costsBox');
    boxes['projectBox'] = await Hive.openBox<BedModel>('projectBox');
    boxes['goalsBox'] = await Hive.openBox<Goal>('goalsBox');
    boxes['transactions'] = await Hive.openBox<Transaction>('transactions');
    boxes['balance'] = await Hive.openBox<Balance>('balance');
    boxes['invoiceBox'] = await Hive.openBox<Invoice>('invoiceBox');
    boxes['harvest_invoices'] =
        await Hive.openBox<HarvestInvoice>('harvest_invoices');
    boxes['partnerBox'] = await Hive.openBox('partnerBox');
    boxes['accountingBox'] = await Hive.openBox('accountingBox');
  } catch (e) {
    print('Error opening box: $e');
    // Recovery attempt
    await Hive.deleteBoxFromDisk(e.toString().split("'")[1]);
    // Retry opening
    return _initializeBoxes();
  }

  return boxes;
}

Future<Box> _openBox(String boxName, Type type) async {
  if (type == dynamic) {
    return await Hive.openBox(boxName);
  }
  return await Hive.openBox<dynamic>(boxName);
}

class MyApp extends StatelessWidget {
  final CustomerRepository customerRepo;
  final Box<BedModel> projectBox;
  final Box<Invoice> invoiceBox;

  const MyApp(
      {super.key,
      required this.customerRepo,
      required this.projectBox,
      required this.invoiceBox});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Welcome(),
        '/intro1': (context) => const IntroductionScreen1(),
        '/intro2': (context) => const IntroductionScreen2(),
        '/intro3': (context) => const IntroductionScreen3(),
        '/sign_up': (context) => SignUpScreen(),
        '/log_in': (context) => LogInScreen(),
        '/home_screen': (context) =>
            HomeScreen(customerRepo: customerRepo, projectBox: projectBox),
        '/recover_password': (context) => RecoverPasswordScreen(),
        '/accounting': (context) => AccountingScreen(
            accountingBox: Hive.box('accountingBox'),
            customerRepo: customerRepo),
        '/add_transaction': (context) => AddTransactionScreen(),
        '/history': (context) => HistoryScreen(),
        '/banks': (context) => BanksScreen(),
        '/credits': (context) => CreditsScreen(),
        '/savings': (context) => SavingsScreen(),
        '/add_tool': (context) => HarvestInvoiceScreen(
              onInvoiceSaved: (invoice) {
                print('Invoice saved: $invoice');
              },
              costsBox: Hive.box<HarvestCost>('costsBox'),
            ),
        '/invoice': (context) => InvoiceScreen(),
        '/date': (context) => DateTimePickerScreen(),
        '/partners': (context) =>
            PartnersScreen(partnerBox: Hive.box('partnerBox')),
        '/customers': (context) =>
            customers_screen.CustomersScreen(customerRepo: customerRepo),
        '/add_client_invoice': (context) => InvoiceClientScreen(
              onInvoiceSaved: (InvoiceModel) {},
            ),
        '/project': (context) =>
            HydroponicBedsScreen(projectBox: Hive.box('projectBox')),
        '/goals': (context) => GoalsApp(
            goalsBox: Hive.box('goalsBox'), customerRepo: customerRepo),
        '/user': (context) => const UserScreen(),
      },
    );
  }
}
