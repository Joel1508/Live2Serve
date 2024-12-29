// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BalanceAdapter extends TypeAdapter<Balance> {
  @override
  final int typeId = 1;

  @override
  Balance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Balance(
      currentBalance: fields[0] as double,
      history: (fields[1] as List?)?.cast<BalanceHistory>(),
    );
  }

  @override
  void write(BinaryWriter writer, Balance obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.currentBalance)
      ..writeByte(1)
      ..write(obj.history);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BalanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BalanceHistoryAdapter extends TypeAdapter<BalanceHistory> {
  @override
  final int typeId = 2;

  @override
  BalanceHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BalanceHistory(
      date: fields[0] as DateTime,
      amount: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BalanceHistory obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BalanceHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
