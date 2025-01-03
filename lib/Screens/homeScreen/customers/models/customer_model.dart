// lib/Screens/homeScreen/customers/models/customer_model.dart
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class CustomerModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String contactNumber;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String address;

  @HiveField(4)
  final String idNit;

  @HiveField(5)
  final String uniqueCode;

  @HiveField(6)
  final String id;

  @HiveField(7)
  final String contact;

  @HiveField(8)
  final bool isSynced;

  CustomerModel({
    required this.name,
    required this.contactNumber,
    required this.email,
    required this.address,
    required this.idNit,
    required this.uniqueCode,
    required this.id,
    required this.contact,
    required this.isSynced,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerModelToJson(this);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contactNumber': contactNumber,
      'email': email,
      'address': address,
      'idNit': idNit,
      'uniqueCode': uniqueCode,
      'id': id,
      'contact': contact,
      'isSynced': isSynced,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      name: map['name'],
      contactNumber: map['contactNumber'],
      email: map['email'],
      address: map['address'],
      idNit: map['idNit'],
      uniqueCode: map['uniqueCode'],
      id: map['id'],
      contact: map['contact'],
      isSynced: map['isSynced'],
    );
  }
}
