// lib/Screens/homeScreen/harvest/models/partner_model.dart
import 'package:hive/hive.dart';

part 'partner_model.g.dart';

@HiveType(typeId: 11)
class Partner extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String? identification;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final String? phone;

  @HiveField(4)
  final DateTime createdAt;

  Partner({
    required this.name,
    this.identification,
    this.email,
    this.phone,
    required this.createdAt,
  });
}
