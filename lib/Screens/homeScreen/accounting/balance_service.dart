// balance_service.dart
import 'package:hive/hive.dart';
import 'models/transaction_model.dart';
import 'models/balance_model.dart';

class BalanceService {
  final Box<Transaction> transactionBox;
  final Box<Balance> balanceBox;

  BalanceService({
    required this.transactionBox,
    required this.balanceBox,
  });

  // Update balance when adding a transaction
  Future<void> updateBalance(Transaction transaction) async {
    var balance = balanceBox.get('current',
        defaultValue: Balance(currentBalance: 0.0, history: []));

    if (balance == null) {
      balance = Balance(currentBalance: 0.0, history: []);
    }

    // Update current balance
    if (transaction.isIncome) {
      balance.currentBalance += transaction.amount;
    } else {
      balance.currentBalance -= transaction.amount;
    }

    // Add to history
    balance.history.add(BalanceHistory(
      date: transaction.date,
      amount: balance.currentBalance,
    ));

    // Save updated balance
    await balanceBox.put('current', balance);
  }

  // Calculate total income for a given period
  double calculateIncome({DateTime? start, DateTime? end}) {
    return transactionBox.values
        .where((t) => t.isIncome)
        .where((t) =>
            (start == null || t.date.isAfter(start)) &&
            (end == null || t.date.isBefore(end)))
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  // Calculate total expenses for a given period
  double calculateExpenses({DateTime? start, DateTime? end}) {
    return transactionBox.values
        .where((t) => !t.isIncome)
        .where((t) =>
            (start == null || t.date.isAfter(start)) &&
            (end == null || t.date.isBefore(end)))
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }
}
