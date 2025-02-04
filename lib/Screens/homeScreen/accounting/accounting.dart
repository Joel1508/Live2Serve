import 'package:FRES.CO/Screens/homeScreen/accounting/models/transaction.dart';
import 'package:FRES.CO/Screens/homeScreen/accounting/others/others.dart';
import 'package:FRES.CO/repositories/customer_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'add_transaction.dart';
import 'history.dart';
import 'models/balance_model.dart';

class AccountingScreen extends StatelessWidget {
  late final Box<Transaction> transactionBox;
  late final Box<Balance> balanceBox;
  final CustomerRepository customerRepo;

  AccountingScreen(
      {Key? key, required Box accountingBox, required this.customerRepo})
      : super(key: key) {
    try {
      transactionBox = Hive.isBoxOpen('transactions')
          ? Hive.box<Transaction>('transactions')
          : throw HiveError("Transaction box not opened");

      balanceBox = Hive.isBoxOpen('balance')
          ? Hive.box<Balance>('balance')
          : throw HiveError("Balance box not opened");
    } catch (e) {
      // Consider adding more robust error handling or logging
      rethrow;
    }
  }

  // Existing methods for getting balance remain the same
  double getCurrentBalance() {
    final balance = balanceBox.get('actual',
        defaultValue: Balance(currentBalance: 0.0, history: []));
    return balance?.currentBalance ?? 0.0;
  }

  double getCorrectedBalance() {
    final balance = balanceBox.get('actual',
        defaultValue: Balance(currentBalance: 0.0, history: []));
    // Multiplicamos por 1000 para corregir el valor
    return (balance?.currentBalance ?? 0.0) * 1000;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'CONTABILIDAD',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.grid_view),
                ],
              ),

              // Balance Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Balance actual',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable:
                              balanceBox.listenable(keys: ['actual']),
                          builder: (context, Box<Balance> box, _) {
                            final balance = box.get('actual',
                                defaultValue:
                                    Balance(currentBalance: 0.0, history: []));
                            final correctedBalance =
                                getCorrectedBalance(); // Usamos el balance corregido
                            final formatter = NumberFormat('#,##0', 'es');
                            return Text(
                              '\$${formatter.format(correctedBalance)}', // Se muestra el balance corregido
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: correctedBalance >= 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

              // Action Buttons
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 16,
                  children: [
                    _buildActionButton(
                      context,
                      icon: Icons.add,
                      label: 'Añadir',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTransactionScreen(),
                        ),
                      ),
                    ),
                    _buildActionButton(
                      context,
                      icon: Icons.history,
                      label: 'Historial',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryScreen(),
                        ),
                      ),
                    ),
                    _buildActionButton(
                      context,
                      icon: Icons.more_horiz,
                      label: 'Otros',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OthersScreen(customerRepo: customerRepo),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create consistent action buttons
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
