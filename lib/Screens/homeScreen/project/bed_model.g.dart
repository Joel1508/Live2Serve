// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bed_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BedModelAdapter extends TypeAdapter<BedModel> {
  @override
  final int typeId = 14;

  @override
  BedModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BedModel(
      name: fields[0] as String,
      code: fields[1] as String,
      creationDate: fields[2] as String,
      details: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BedModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.creationDate)
      ..writeByte(3)
      ..write(obj.details);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BedModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GridStateModelAdapter extends TypeAdapter<GridStateModel> {
  @override
  final int typeId = 15;

  @override
  GridStateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GridStateModel(
      gridIndex: fields[0] as int,
      isPlanted: fields[1] as bool,
      lastUpdated: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GridStateModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.gridIndex)
      ..writeByte(1)
      ..write(obj.isPlanted)
      ..writeByte(2)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridStateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
