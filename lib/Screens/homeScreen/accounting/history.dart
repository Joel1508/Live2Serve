import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> transactions = [];
  List<Map<String, dynamic>> filteredTransactions = [];
  String selectedFilter = 'Day';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('transactions')
          .select('*')
          .order('date', ascending: false);

      setState(() {
        transactions = List<Map<String, dynamic>>.from(response);
        filteredTransactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching transactions: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading transactions')),
      );
    }
  }

  void applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      // Add more sophisticated filtering logic here
      switch (filter) {
        case 'Day':
          filteredTransactions = transactions;
          break;
        case 'Weekly':
          filteredTransactions = _filterByWeekly(transactions);
          break;
        case 'Monthly':
          filteredTransactions = _filterByMonthly(transactions);
          break;
        case 'Yearly':
          filteredTransactions = _filterByYearly(transactions);
          break;
        default:
          filteredTransactions = transactions;
      }
    });
  }

  List<Map<String, dynamic>> _filterByWeekly(
      List<Map<String, dynamic>> allTransactions) {
    final now = DateTime.now();
    return allTransactions.where((tx) {
      final txDate = DateTime.parse(tx['date']);
      return txDate.isAfter(now.subtract(Duration(days: 7)));
    }).toList();
  }

  List<Map<String, dynamic>> _filterByMonthly(
      List<Map<String, dynamic>> allTransactions) {
    final now = DateTime.now();
    return allTransactions.where((tx) {
      final txDate = DateTime.parse(tx['date']);
      return txDate.month == now.month && txDate.year == now.year;
    }).toList();
  }

  List<Map<String, dynamic>> _filterByYearly(
      List<Map<String, dynamic>> allTransactions) {
    final now = DateTime.now();
    return allTransactions.where((tx) {
      final txDate = DateTime.parse(tx['date']);
      return txDate.year == now.year;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
        backgroundColor: Color(0xFFFDEDCDD),
      ),
      body: Column(
        children: [
          // Filter buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFilterButton('Day'),
                _buildFilterButton('Weekly'),
                _buildFilterButton('Monthly'),
                _buildFilterButton('Yearly'),
              ],
            ),
          ),

          // Loading or Transaction list
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: filteredTransactions.isEmpty
                      ? Center(
                          child: Text(
                            'No transactions available.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredTransactions.length,
                          itemBuilder: (context, index) {
                            final transaction = filteredTransactions[index];
                            final isIncome = transaction['amount'] > 0;

                            return Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              color: Colors.white,
                              elevation: 5,
                              child: ListTile(
                                leading: Icon(
                                  isIncome
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color: isIncome ? Colors.green : Colors.red,
                                ),
                                title: Text(
                                  '${transaction['category']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text('${transaction['title']}'),
                                trailing: Text(
                                  '\$${transaction['amount'].toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: isIncome ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    return ElevatedButton(
      onPressed: () => applyFilter(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor:
            selectedFilter == label ? Color(0xFF79DAB6) : Color(0xFFF979DAB),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(label),
    );
  }
}
