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
import 'package:app/Screens/homeScreen/customers/add_customer.dart';
import 'package:app/Screens/homeScreen/home_screen.dart';
import 'package:app/Screens/homeScreen/partners/add_partner.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'Screens/homeScreen/customers/customers.dart';
import 'Screens/homeScreen/partners/partners.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://fqdpwiskvyiopqgxuaml.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZxZHB3aXNrdnlpb3BxZ3h1YW1sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM1MDM3MzYsImV4cCI6MjA0OTA3OTczNn0.dkxwbnUkKb2fcpzEFR2uoNCsY_f06wntVxWrZsuxt70',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        '/home_screen': (context) => HomeScreen(),
        '/recover_password': (context) => RecoverPasswordScreen(),
        '/accounting': (context) => AccountingScreen(),
        '/add_transaction': (context) => AddTransactionScreen(),
        '/history': (context) => HistoryScreen(),
        '/date': (context) => DateTimePickerScreen(),
        '/partners': (context) => PartnersScreen(),
        '/add_partners': (context) => const AddPartnerScreen(),
        '/customers': (context) => CustomersScreen(),
        '/add_customer': (context) => const AddCustomerScreen(
              initialData: {},
            ),
      },
    );
  }
}
