import 'package:FRES.CO/Screens/homeScreen/accounting/models/transaction.dart';
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
  String selectedFilter = 'Todo';
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
      bool passesIncomeFilter =
          !isIncomeFilter || transaction.isIncome == isIncomeFilter;

      bool passesTimeFilter = true;
      switch (selectedFilter) {
        case 'Hoy':
          passesTimeFilter = _isToday(transaction.date);
          break;
        case 'Semana':
          passesTimeFilter = _isThisWeek(transaction.date);
          break;
        case 'Mes':
          passesTimeFilter = _isThisMonth(transaction.date);
          break;
        case 'Año':
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
        title: Text('Historial de Transacciones'),
        actions: [
          IconButton(
            icon: Icon(isIncomeFilter ? Icons.attach_money : Icons.money_off),
            onPressed: _toggleIncomeFilter,
            tooltip: isIncomeFilter ? 'Mostrar todos' : 'Mostrar solo ingresos',
          )
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Todo', 'Hoy', 'Semana', 'Mes', 'Año']
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
          Expanded(
            child: filteredTransactions.isEmpty
                ? Center(child: Text('No hay transacciones disponibles'))
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
                          '${transaction.category} - ${DateFormat('dd/MM/yyyy HH:mm', 'es').format(transaction.date)}',
                        ),
                        trailing: Text(
                          '\$${NumberFormat('#,##0', 'es').format(transaction.amount * 1000)}',
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryCard(
                    'Ingresos Totales',
                    filteredTransactions
                        .where((t) => t.isIncome)
                        .map((t) => t.amount)
                        .fold(0, (a, b) => a + b)),
                _buildSummaryCard(
                    'Gastos Totales',
                    filteredTransactions
                        .where((t) => !t.isIncome)
                        .map((t) => t.amount * 1000)
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
    final formatter = NumberFormat('#,##0', 'es');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              '\$${formatter.format(amount)}',
              style: TextStyle(
                  color:
                      title.contains('Ingresos') ? Colors.green : Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
