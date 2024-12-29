// lib/Screens/homeScreen/accounting/models/other_model.dart
import 'package:hive/hive.dart';

part 'other_model.g.dart';

@HiveType(typeId: 3)
class Bank extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  double balance;

  @HiveField(2)
  final String accountNumber;

  Bank({
    required this.name,
    required this.balance,
    required this.accountNumber,
  });
}

@HiveType(typeId: 4)
class Saving extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  double currentAmount;

  @HiveField(2)
  final double targetAmount;

  @HiveField(3)
  final DateTime startDate;

  @HiveField(4)
  final DateTime targetDate;

  Saving({
    required this.title,
    required this.currentAmount,
    required this.targetAmount,
    required this.startDate,
    required this.targetDate,
  });
}

@HiveType(typeId: 5)
class Credit extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  double totalAmount;

  @HiveField(2)
  double paidAmount;

  @HiveField(3)
  final DateTime dueDate;

  Credit({
    required this.name,
    required this.totalAmount,
    required this.paidAmount,
    required this.dueDate,
  });
}

@HiveType(typeId: 6)
class Goal extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  double currentAmount;

  @HiveField(2)
  final double targetAmount;

  @HiveField(3)
  final DateTime deadline;

  Goal({
    required this.title,
    required this.currentAmount,
    required this.targetAmount,
    required this.deadline,
  });
}
