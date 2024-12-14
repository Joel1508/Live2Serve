import 'package:app/Screens/homeScreen/accounting/others/banks.dart';
import 'package:app/Screens/homeScreen/accounting/others/credits.dart';
import 'package:app/Screens/homeScreen/accounting/others/goals.dart';
import 'package:app/Screens/homeScreen/accounting/others/savings.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(OtherScreen());
}

class OtherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OthersScreen(),
    );
  }
}

class OthersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0BBE4), Color(0xFF957DAD)],
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
                    Icon(Icons.arrow_back, color: Colors.white, size: 28),
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
                          "Which other activities do you need to do?",
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
                      _buildButton(
                          context, Icons.my_location, "Goals", GoalsScreen()),
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
        leading: Icon(icon, size: 28, color: Colors.purple),
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
}
