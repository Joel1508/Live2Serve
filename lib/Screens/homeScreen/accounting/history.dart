import 'package:app/Screens/homeScreen/accounting/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Transaction> transactions = [];
  List<Transaction> filteredTransactions = [];
  String selectedFilter = 'All';
  bool isIncomeFilter = false;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    final transactionBox = Hive.box<Transaction>('transactions');
    setState(() {
      transactions = transactionBox.values.toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      filteredTransactions = transactions;
    });
  }

  void _applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      _filterTransactions();
    });
  }

  void _toggleIncomeFilter() {
    setState(() {
      isIncomeFilter = !isIncomeFilter;
      _filterTransactions();
    });
  }

  void _filterTransactions() {
    filteredTransactions = transactions.where((transaction) {
      // Income/Expense filter
      bool passesIncomeFilter =
          !isIncomeFilter || transaction.isIncome == isIncomeFilter;

      // Time-based filter
      bool passesTimeFilter = true;
      switch (selectedFilter) {
        case 'Today':
          passesTimeFilter = _isToday(transaction.date);
          break;
        case 'This Week':
          passesTimeFilter = _isThisWeek(transaction.date);
          break;
        case 'This Month':
          passesTimeFilter = _isThisMonth(transaction.date);
          break;
        case 'This Year':
          passesTimeFilter = _isThisYear(transaction.date);
          break;
      }

      return passesIncomeFilter && passesTimeFilter;
    }).toList();
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isThisWeek(DateTime date) {
    final now = DateTime.now();
    return date.isAfter(now.subtract(Duration(days: 7)));
  }

  bool _isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  bool _isThisYear(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
        actions: [
          IconButton(
            icon: Icon(isIncomeFilter ? Icons.attach_money : Icons.money_off),
            onPressed: _toggleIncomeFilter,
          )
        ],
      ),
      body: Column(
        children: [
          // Time Filter Buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Today', 'This Week', 'This Month', 'This Year']
                  .map((filter) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: selectedFilter == filter,
                          onSelected: (_) => _applyFilter(filter),
                        ),
                      ))
                  .toList(),
            ),
          ),

          // Transaction List
          Expanded(
            child: filteredTransactions.isEmpty
                ? Center(child: Text('No transactions found'))
                : ListView.builder(
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = filteredTransactions[index];
                      return ListTile(
                        leading: Icon(
                          transaction.isIncome
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color:
                              transaction.isIncome ? Colors.green : Colors.red,
                        ),
                        title: Text(transaction.title),
                        subtitle: Text(
                          '${transaction.category} - ${transaction.date.toLocal()}',
                        ),
                        trailing: Text(
                          '\$${transaction.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: transaction.isIncome
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Summary Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryCard(
                    'Total Income',
                    filteredTransactions
                        .where((t) => t.isIncome)
                        .map((t) => t.amount)
                        .fold(0, (a, b) => a + b)),
                _buildSummaryCard(
                    'Total Expense',
                    filteredTransactions
                        .where((t) => !t.isIncome)
                        .map((t) => t.amount)
                        .fold(0, (a, b) => a + b)),
              ],
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              '\$${formatter.format(amount)}',
              style: TextStyle(
                  color: title.contains('Income') ? Colors.green : Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
