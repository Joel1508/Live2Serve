import 'package:app/Screens/acces/intro1.dart';
import 'package:app/Screens/acces/intro2.dart';
import 'package:app/Screens/acces/intro3.dart';
import 'package:app/Screens/acces/log_in.dart';
import 'package:app/Screens/acces/recover_password.dart';
import 'package:app/Screens/acces/sign_up.dart';
import 'package:app/Screens/acces/welcome.dart';
import 'package:app/Screens/homeScreen/accounting/accounting.dart';
import 'package:app/Screens/homeScreen/accounting/add_transaction.dart';
import 'package:app/Screens/homeScreen/accounting/date.dart';
import 'package:app/Screens/homeScreen/accounting/history.dart';
import 'package:app/Screens/homeScreen/accounting/others/banks.dart';
import 'package:app/Screens/homeScreen/accounting/others/credits.dart';
import 'package:app/Screens/homeScreen/accounting/others/savings.dart';
import 'package:app/Screens/homeScreen/add_client_invoice.dart';
import 'package:app/Screens/homeScreen/add_tool.dart';
import 'package:app/Screens/homeScreen/customers/add_customer.dart';
import 'package:app/Screens/homeScreen/customers/models/customer_model.dart';
import 'package:app/Screens/homeScreen/goals/goal.dart';
import 'package:app/Screens/homeScreen/goals/goals.dart';
import 'package:app/Screens/homeScreen/home_screen.dart';
import 'package:app/Screens/homeScreen/invoice/invoice.dart';
import 'package:app/Screens/homeScreen/project/bed_model.dart';
import 'package:app/Screens/homeScreen/project/interactive_map.dart';
import 'package:app/Screens/homeScreen/project/project.dart';
import 'package:app/Screens/homeScreen/user_settings/user.dart';
import 'package:app/repositories/customer_repository.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Screens/homeScreen/customers/customers.dart';
import 'Screens/homeScreen/partners/partners.dart';

Future<void> main() async {
  // Ensure WidgetsFlutterBinding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and open required boxes
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  // Register your adapters (make sure these are registered before opening boxes)
  Hive.registerAdapter(CustomerModelAdapter());
  Hive.registerAdapter(BedModelAdapter());
  Hive.registerAdapter(GoalAdapter());

  // Open boxes with checks
  if (!Hive.isBoxOpen('customerBox')) {
    await Hive.openBox<Customer>('customerBox');
  }
  if (!Hive.isBoxOpen('partnerBox')) {
    await Hive.openBox('partnerBox');
  }
  if (!Hive.isBoxOpen('accountingBox')) {
    await Hive.openBox('accountingBox');
  }
  if (!Hive.isBoxOpen('invoiceBox')) {
    await Hive.openBox('invoiceBox');
  }
  if (!Hive.isBoxOpen('projectBox')) {
    await Hive.openBox<BedModel>('projectBox');
  }
  if (!Hive.isBoxOpen('goalsBox')) {
    await Hive.openBox<Goal>('goalsBox');
  }

  // Get the opened customerBox
  var customerBox = Hive.box<Customer>('customerBox');

  // Initialize your customerRepo, passing Hive's instance and customerBox
  final customerRepo = CustomerRepository(customerBox: customerBox);

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://fqdpwiskvyiopqgxuaml.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZxZHB3aXNrdnlpb3BxZ3h1YW1sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM1MDM3MzYsImV4cCI6MjA0OTA3OTczNn0.dkxwbnUkKb2fcpzEFR2uoNCsY_f06wntVxWrZsuxt70',
  );

  // Run the app, passing the repository to MyApp
  runApp(MyApp(customerRepo: customerRepo));
}

class MyApp extends StatelessWidget {
  final CustomerRepository customerRepo;

  const MyApp({super.key, required this.customerRepo});

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
        '/home_screen': (context) => HomeScreen(customerRepo: customerRepo),
        '/recover_password': (context) => RecoverPasswordScreen(),
        '/accounting': (context) => AccountingScreen(
            accountingBox: Hive.box('accountingBox'),
            customerRepo: customerRepo),
        '/add_transaction': (context) => AddTransactionScreen(),
        '/history': (context) => HistoryScreen(),
        '/banks': (context) => BanksScreen(),
        '/credits': (context) => CreditsScreen(),
        '/savings': (context) => SavingsScreen(),
        '/add_tool': (context) => AddToolScreen(),
        '/invoice': (context) =>
            InvoiceScreen(invoiceBox: Hive.box('invoiceBox')),
        '/date': (context) => DateTimePickerScreen(),
        '/partners': (context) =>
            PartnersScreen(partnerBox: Hive.box('partnerBox')),
        '/add_partners': (context) => AddPartnerScreen(),
        '/customers': (context) => CustomersScreen(customerRepo: customerRepo),
        '/add_customer': (context) => const AddCustomerScreen(
              existingCustomer: null,
            ),
        '/add_client_invoice': (context) => InvoiceClientScreen(),
        '/project': (context) =>
            HydroponicBedsScreen(projectBox: Hive.box('projectBox')),
        '/interactive_map': (context) => InteractiveMapScreen(),
        '/goals': (context) =>
            GoalsApp(goalsBox: Hive.box('goalBox'), customerRepo: customerRepo),
        '/user': (context) => const UserScreen(),
      },
    );
  }
}
