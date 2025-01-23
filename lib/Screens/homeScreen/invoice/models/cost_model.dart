// lib/Screens/homeScreen/invoice/models/cost_model.dart
import 'package:hive/hive.dart';

part 'cost_model.g.dart';

@HiveType(typeId: 11)
class CostTemplate extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<ProductionCost> costs;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  DateTime? lastModified;

  CostTemplate({
    required this.name,
    required this.costs,
    required this.createdAt,
    this.lastModified,
  });

  double get totalCost => costs.fold(0, (sum, cost) => sum + cost.totalCost);
}

@HiveType(typeId: 12)
class ProductionCost extends HiveObject {
  @HiveField(0)
  String name; // User-defined cost name

  @HiveField(1)
  double costPerUnit; // User-defined cost per unit

  @HiveField(2)
  int quantity; // User-defined quantity

  @HiveField(3)
  String? description; // Optional description/notes

  @HiveField(4)
  String? unitType; // Optional unit type (e.g., "per bag", "per unit", etc.)

  ProductionCost({
    required this.name,
    required this.costPerUnit,
    required this.quantity,
    this.description,
    this.unitType,
  });

  double get totalCost => costPerUnit * quantity;
}
