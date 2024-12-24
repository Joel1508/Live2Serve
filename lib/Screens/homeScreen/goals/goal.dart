import 'package:hive/hive.dart';

part 'goal.g.dart'; // This will generate the 'goal.g.dart' file

@HiveType(typeId: 1) // Use a unique ID for this class
class Goal {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String date;

  Goal({
    required this.title,
    required this.description,
    required this.date,
  });
}
