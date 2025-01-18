import 'package:app/Screens/homeScreen/accounting/others/others.dart';
import 'package:app/repositories/customer_repository.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'add_transaction.dart';
import 'history.dart';
import 'models/transaction_model.dart';
import 'models/balance_model.dart';

class AccountingScreen extends StatelessWidget {
  late final Box<Transaction> transactionBox;
  late final Box<Balance> balanceBox;
  final CustomerRepository customerRepo;

  AccountingScreen(
      {Key? key, required Box accountingBox, required this.customerRepo})
      : super(key: key) {
    // Safely access boxes only when needed
    if (Hive.isBoxOpen('transactions')) {
      transactionBox = Hive.box<Transaction>('transactions');
    } else {
      throw HiveError("Transaction box not opened. Ensure it's initialized.");
    }

    if (Hive.isBoxOpen('balance')) {
      balanceBox = Hive.box<Balance>('balance');
    } else {
      throw HiveError("Balance box not opened. Ensure it's initialized.");
    }
  }

  // Get current balance
  double getCurrentBalance() {
    final balance = balanceBox.get('current',
        defaultValue: Balance(currentBalance: 0.0, history: []));
    return balance?.currentBalance ?? 0.0;
  }

  // Get balance history for the graph
  List<FlSpot> getBalanceSpots() {
    final balance =
        balanceBox.get('current', defaultValue: Balance(currentBalance: 0.0));

    final history = balance?.history ?? [];
    List<FlSpot> spots = [];
    if (history.isNotEmpty) {
      final sortedHistory = List.from(history)
        ..sort((a, b) => a.date.compareTo(b.date));
      for (int i = 0; i < sortedHistory.length; i++) {
        spots.add(FlSpot(i.toDouble(), sortedHistory[i].amount));
      }
    } else {
      spots.add(FlSpot(0, balance?.currentBalance ?? 0.0));
    }

    return spots;
  }

  Widget _buildBalanceChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Color(0xFFFCFCFCF), Color(0xFFFDEDCDD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BALANCE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          ValueListenableBuilder(
            valueListenable: balanceBox.listenable(),
            builder: (context, Box<Balance> box, _) {
              final currentBalance = getCurrentBalance();
              return Text(
                '\$${currentBalance.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              );
            },
          ),
          SizedBox(height: 16),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: balanceBox.listenable(),
              builder: (context, Box<Balance> box, _) {
                final spots = getBalanceSpots();
                return LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: spots.length.toDouble() - 1,
                    minY: spots
                            .map((spot) => spot.y)
                            .reduce((a, b) => a < b ? a : b) -
                        100,
                    maxY: spots
                            .map((spot) => spot.y)
                            .reduce((a, b) => a > b ? a : b) +
                        100,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: Colors.white,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF9FAFB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
        child: Column(
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'ACCOUNTING',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Icon(Icons.grid_view),
              ],
            ),

            const SizedBox(height: 20),

            // Balance Chart
            _buildBalanceChart(),

            const SizedBox(height: 20),

            // Action Buttons
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTransactionScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add Transaction'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HistoryScreen(),
                            ),
                          );
                        },
                        child: Text('History'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OthersScreen(customerRepo: customerRepo),
                            ),
                          );
                        },
                        child: Text('Others'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
