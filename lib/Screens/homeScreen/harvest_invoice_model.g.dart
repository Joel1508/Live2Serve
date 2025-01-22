// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harvest_invoice_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HarvestCostAdapter extends TypeAdapter<HarvestCost> {
  @override
  final int typeId = 5;

  @override
  HarvestCost read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HarvestCost(
      name: fields[0] as String,
      amount: fields[1] as double,
      quantity: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HarvestCost obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HarvestCostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HarvestInvoiceAdapter extends TypeAdapter<HarvestInvoice> {
  @override
  final int typeId = 4;

  @override
  HarvestInvoice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HarvestInvoice(
      reference: fields[0] as String,
      personName: fields[1] as String,
      plantsHarvested: fields[2] as int,
      pricePerPlant: fields[3] as double,
      costs: (fields[4] as List).cast<HarvestCost>(),
      dateTime: fields[5] as String,
      totalHarvestValue: fields[6] as double,
      totalCosts: fields[7] as double,
      finalAmount: fields[8] as double,
    );
  }

  @override
  void write(BinaryWriter writer, HarvestInvoice obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.reference)
      ..writeByte(1)
      ..write(obj.personName)
      ..writeByte(2)
      ..write(obj.plantsHarvested)
      ..writeByte(3)
      ..write(obj.pricePerPlant)
      ..writeByte(4)
      ..write(obj.costs)
      ..writeByte(5)
      ..write(obj.dateTime)
      ..writeByte(6)
      ..write(obj.totalHarvestValue)
      ..writeByte(7)
      ..write(obj.totalCosts)
      ..writeByte(8)
      ..write(obj.finalAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HarvestInvoiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
