// lib/Screens/homeScreen/accounting/others/accounting_goal.dart
import 'package:hive/hive.dart';

part 'accounting_goal.g.dart'; // Required for Hive type adapter

@HiveType(typeId: 6) // Assign a unique typeId
class AccountingGoal extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final double progress;

  AccountingGoal({
    required this.title,
    required this.amount,
    required this.date,
    required this.progress,
  });
}
