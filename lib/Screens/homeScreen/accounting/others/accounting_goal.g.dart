// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounting_goal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountingGoalAdapter extends TypeAdapter<AccountingGoal> {
  @override
  final int typeId = 0;

  @override
  AccountingGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountingGoal(
      title: fields[0] as String,
      amount: fields[1] as double,
      date: fields[2] as DateTime,
      progress: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, AccountingGoal obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.progress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountingGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
