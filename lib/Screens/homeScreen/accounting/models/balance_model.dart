// lib/Screens/homeScreen/accounting/models/balance_model.dart
import 'package:hive/hive.dart';

part 'balance_model.g.dart';

@HiveType(typeId: 0)
class Balance extends HiveObject {
  @HiveField(0)
  double currentBalance;

  @HiveField(1)
  final List<BalanceHistory> history;

  Balance({
    this.currentBalance = 0.0,
    List<BalanceHistory>? history,
  }) : this.history = history ?? [];
}

@HiveType(typeId: 1)
class BalanceHistory extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final double amount;

  BalanceHistory({
    required this.date,
    required this.amount,
  });
}
