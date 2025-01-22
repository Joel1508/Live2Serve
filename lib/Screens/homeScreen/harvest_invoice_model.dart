// harvest_invoice_model.dart
import 'package:hive/hive.dart';
part 'harvest_invoice_model.g.dart';

@HiveType(typeId: 5)
class HarvestCost extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final int quantity;

  HarvestCost({
    required this.name,
    required this.amount,
    required this.quantity,
  });

  double get total => amount * quantity;
}

@HiveType(typeId: 4)
class HarvestInvoice extends HiveObject {
  @HiveField(0)
  final String reference;

  @HiveField(1)
  final String personName;

  @HiveField(2)
  final int plantsHarvested;

  @HiveField(3)
  final double pricePerPlant;

  @HiveField(4)
  final List<HarvestCost> costs;

  @HiveField(5)
  final String dateTime;

  @HiveField(6)
  final double totalHarvestValue;

  @HiveField(7)
  final double totalCosts;

  @HiveField(8)
  final double finalAmount;

  HarvestInvoice({
    required this.reference,
    required this.personName,
    required this.plantsHarvested,
    required this.pricePerPlant,
    required this.costs,
    required this.dateTime,
    required this.totalHarvestValue,
    required this.totalCosts,
    required this.finalAmount,
  });
}
