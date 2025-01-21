// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceAdapter extends TypeAdapter<Invoice> {
  @override
  final int typeId = 3;

  @override
  Invoice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Invoice(
      reference: fields[0] as String,
      sender: fields[1] as String,
      receiver: fields[2] as String,
      nit: fields[3] as String,
      dateTime: fields[4] as String,
      operation: fields[5] as String,
      amount: fields[6] as String,
      details: fields[7] as String,
      email: fields[8] as String,
      month: fields[9] as String,
      imagePath: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Invoice obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.reference)
      ..writeByte(1)
      ..write(obj.sender)
      ..writeByte(2)
      ..write(obj.receiver)
      ..writeByte(3)
      ..write(obj.nit)
      ..writeByte(4)
      ..write(obj.dateTime)
      ..writeByte(5)
      ..write(obj.operation)
      ..writeByte(6)
      ..write(obj.amount)
      ..writeByte(7)
      ..write(obj.details)
      ..writeByte(8)
      ..write(obj.email)
      ..writeByte(9)
      ..write(obj.month)
      ..writeByte(10)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
