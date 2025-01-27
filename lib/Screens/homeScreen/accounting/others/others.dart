import 'package:FRES.CO/Screens/homeScreen/accounting/others/banks.dart';
import 'package:FRES.CO/Screens/homeScreen/accounting/others/credits.dart';
import 'package:FRES.CO/Screens/homeScreen/accounting/others/savings.dart';
import 'package:FRES.CO/Screens/homeScreen/goals/goal.dart';
import 'package:FRES.CO/Screens/homeScreen/goals/goals.dart';
import 'package:FRES.CO/repositories/customer_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OthersScreen extends StatelessWidget {
  final CustomerRepository customerRepo;

  const OthersScreen({
    Key? key,
    required this.customerRepo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFCFCFCF), Color(0xFFFF9FAFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon:
                          Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Column(
                      children: [
                        Text(
                          "Others",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Activities",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Icon(Icons.grid_view, color: Colors.white, size: 28),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Main Content Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton(context, Icons.account_balance, "Banks",
                          BanksScreen()),
                      SizedBox(height: 16),
                      _buildButton(
                          context, Icons.savings, "Savings", SavingsScreen()),
                      SizedBox(height: 16),
                      _buildButton(context, Icons.credit_card, "Credits",
                          CreditsScreen()),
                      SizedBox(height: 16),
                      _buildGoalsButton(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, IconData icon, String label, Widget targetScreen) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, size: 28, color: Colors.blue),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
          );
        },
      ),
    );
  }

  Widget _buildGoalsButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.my_location, size: 28, color: Colors.blue),
        title: Text(
          "Goals",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        onTap: () async {
          // Ensure we're using the correct Goal type from goals/goal.dart
          Box<Goal> goalsBox;
          try {
            goalsBox = Hive.box<Goal>('goals');
          } catch (e) {
            // If the box isn't open yet, open it
            goalsBox = await Hive.openBox<Goal>('goals');
          }

          if (context.mounted) {
            // Check if context is still valid after async operation
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GoalsScreen(
                  goalsBox: goalsBox,
                  customerRepo: customerRepo,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
