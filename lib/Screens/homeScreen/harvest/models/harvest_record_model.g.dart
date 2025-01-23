// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harvest_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HarvestRecordAdapter extends TypeAdapter<HarvestRecord> {
  @override
  final int typeId = 9;

  @override
  HarvestRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HarvestRecord(
      harvestDate: fields[0] as DateTime,
      plantsHarvested: fields[1] as int,
      partnerId: fields[2] as String,
      costTemplateId: fields[3] as String?,
      pricePerPlant: fields[4] as double,
      notes: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HarvestRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.harvestDate)
      ..writeByte(1)
      ..write(obj.plantsHarvested)
      ..writeByte(2)
      ..write(obj.partnerId)
      ..writeByte(3)
      ..write(obj.costTemplateId)
      ..writeByte(4)
      ..write(obj.pricePerPlant)
      ..writeByte(5)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HarvestRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
