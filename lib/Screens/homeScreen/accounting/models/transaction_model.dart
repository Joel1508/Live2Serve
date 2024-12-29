// lib/Screens/homeScreen/accounting/models/transaction_model.dart
import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String paymentMethod;

  @HiveField(6)
  final String? note;

  @HiveField(7)
  final String? imagePath;

  @HiveField(8)
  final bool isIncome;

  Transaction({
    required this.id,
    required this.amount,
    required this.title,
    required this.category,
    required this.date,
    required this.paymentMethod,
    required this.isIncome,
    this.note,
    this.imagePath,
  });
}
