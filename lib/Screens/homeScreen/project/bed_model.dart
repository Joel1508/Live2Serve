// lib/Screens/homeScreen/project/bed_model.dart
import 'package:hive/hive.dart';

part 'bed_model.g.dart';

@HiveType(typeId: 14)
class BedModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String code;

  @HiveField(2)
  String creationDate;

  @HiveField(3)
  String details;

  BedModel({
    required this.name,
    required this.code,
    required this.creationDate,
    required this.details,
  });

  static BedModel empty() => BedModel(
        name: "",
        code: "",
        creationDate: "",
        details: "",
      );

  bool get isNotEmpty => name.isNotEmpty;
}

// grid_state_model.dart
@HiveType(typeId: 15)
class GridStateModel extends HiveObject {
  @HiveField(0)
  int gridIndex;

  @HiveField(1)
  bool isPlanted;

  @HiveField(2)
  DateTime lastUpdated;

  GridStateModel({
    required this.gridIndex,
    required this.isPlanted,
    required this.lastUpdated,
  });
}
