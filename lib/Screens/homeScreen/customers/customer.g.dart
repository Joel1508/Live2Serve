// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerAdapter extends TypeAdapter<Customer> {
  @override
  final int typeId = 0;

  @override
  Customer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Customer(
      name: fields[0] as String,
      contactNumber: fields[1] as String,
      email: fields[2] as String,
      address: fields[3] as String,
      idNit: fields[4] as String,
      uniqueCode: fields[5] as String,
      id: fields[6] as String,
      contact: fields[7] as String,
      isSynced: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Customer obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.contactNumber)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.idNit)
      ..writeByte(5)
      ..write(obj.uniqueCode)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.contact)
      ..writeByte(8)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      name: json['name'] as String,
      contactNumber: json['contactNumber'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      idNit: json['idNit'] as String,
      uniqueCode: json['uniqueCode'] as String,
      id: json['id'] as String,
      contact: json['contact'] as String,
      isSynced: json['isSynced'] as bool,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'name': instance.name,
      'contactNumber': instance.contactNumber,
      'email': instance.email,
      'address': instance.address,
      'idNit': instance.idNit,
      'uniqueCode': instance.uniqueCode,
      'id': instance.id,
      'contact': instance.contact,
      'isSynced': instance.isSynced,
    };
