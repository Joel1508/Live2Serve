// lib/Screens/homeScreen/harvest/models/harvest_record_model.dart
import 'package:hive/hive.dart';

part 'harvest_record_model.g.dart';

@HiveType(typeId: 5)
class HarvestRecord extends HiveObject {
  @HiveField(0)
  final DateTime harvestDate;

  @HiveField(1)
  final int plantsHarvested;

  @HiveField(2)
  final String partnerId;

  @HiveField(3)
  final String? costTemplateId;

  @HiveField(4)
  final double pricePerPlant;

  @HiveField(5)
  final String? notes;

  double get totalRevenue => plantsHarvested * pricePerPlant;

  HarvestRecord({
    required this.harvestDate,
    required this.plantsHarvested,
    required this.partnerId,
    this.costTemplateId,
    required this.pricePerPlant,
    this.notes,
  });
}
