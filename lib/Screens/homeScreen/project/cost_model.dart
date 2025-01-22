import 'package:hive/hive.dart';

part 'cost_model.g.dart';

@HiveType(typeId: 7)
class CostModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double unitPrice;

  @HiveField(3)
  DateTime createdAt;

  CostModel({
    required this.id,
    required this.name,
    required this.unitPrice,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'unitPrice': unitPrice,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CostModel.fromMap(Map<String, dynamic> map) {
    return CostModel(
      id: map['id'],
      name: map['name'],
      unitPrice: map['unitPrice'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  CostModel copyWith({
    String? name,
    double? unitPrice,
  }) {
    return CostModel(
      id: this.id,
      name: name ?? this.name,
      unitPrice: unitPrice ?? this.unitPrice,
      createdAt: this.createdAt,
    );
  }
}
