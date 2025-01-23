// lib/Screens/homeScreen/goals/goal.dart
import 'package:hive/hive.dart';

part 'goal.g.dart';

@HiveType(typeId: 8)
class Goal extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  double currentAmount;

  @HiveField(2)
  final double targetAmount;

  @HiveField(3)
  final DateTime deadline;

  @HiveField(4)
  String description;

  @HiveField(5)
  String date;

  Goal({
    required this.title,
    this.currentAmount = 0.0,
    required this.targetAmount,
    required this.deadline,
    this.description = '',
    this.date = '',
  });

  // Helper method to get the percentage of completion
  double get progressPercentage {
    return (currentAmount / targetAmount * 100).clamp(0.0, 100.0);
  }

  // Helper method to check if the goal is completed
  bool get isCompleted {
    return currentAmount >= targetAmount;
  }

  // Helper method to check if the goal is overdue
  bool get isOverdue {
    return !isCompleted && DateTime.now().isAfter(deadline);
  }

  // Helper method to get remaining amount
  double get remainingAmount {
    return (targetAmount - currentAmount).clamp(0.0, double.infinity);
  }

  // Helper method to format the date string
  String get formattedDate {
    return date.isNotEmpty ? date : deadline.toString().split(' ')[0];
  }
}
