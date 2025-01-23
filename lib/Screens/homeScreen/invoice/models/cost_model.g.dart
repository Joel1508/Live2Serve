// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CostTemplateAdapter extends TypeAdapter<CostTemplate> {
  @override
  final int typeId = 11;

  @override
  CostTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CostTemplate(
      name: fields[0] as String,
      costs: (fields[1] as List).cast<ProductionCost>(),
      createdAt: fields[2] as DateTime,
      lastModified: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CostTemplate obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.costs)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.lastModified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CostTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductionCostAdapter extends TypeAdapter<ProductionCost> {
  @override
  final int typeId = 12;

  @override
  ProductionCost read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductionCost(
      name: fields[0] as String,
      costPerUnit: fields[1] as double,
      quantity: fields[2] as int,
      description: fields[3] as String?,
      unitType: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductionCost obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.costPerUnit)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.unitType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductionCostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
