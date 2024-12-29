// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'other_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BankAdapter extends TypeAdapter<Bank> {
  @override
  final int typeId = 3;

  @override
  Bank read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bank(
      name: fields[0] as String,
      balance: fields[1] as double,
      accountNumber: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Bank obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.balance)
      ..writeByte(2)
      ..write(obj.accountNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SavingAdapter extends TypeAdapter<Saving> {
  @override
  final int typeId = 4;

  @override
  Saving read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Saving(
      title: fields[0] as String,
      currentAmount: fields[1] as double,
      targetAmount: fields[2] as double,
      startDate: fields[3] as DateTime,
      targetDate: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Saving obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.currentAmount)
      ..writeByte(2)
      ..write(obj.targetAmount)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.targetDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CreditAdapter extends TypeAdapter<Credit> {
  @override
  final int typeId = 5;

  @override
  Credit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Credit(
      name: fields[0] as String,
      totalAmount: fields[1] as double,
      paidAmount: fields[2] as double,
      dueDate: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Credit obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.totalAmount)
      ..writeByte(2)
      ..write(obj.paidAmount)
      ..writeByte(3)
      ..write(obj.dueDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreditAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GoalAdapter extends TypeAdapter<Goal> {
  @override
  final int typeId = 6;

  @override
  Goal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Goal(
      title: fields[0] as String,
      currentAmount: fields[1] as double,
      targetAmount: fields[2] as double,
      deadline: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Goal obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.currentAmount)
      ..writeByte(2)
      ..write(obj.targetAmount)
      ..writeByte(3)
      ..write(obj.deadline);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
