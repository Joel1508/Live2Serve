import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Customer {
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

  // Constructor
  Customer({
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

  // Add JSON serialization methods here
  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  // Convert the Customer object to a Map for Hive storage
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

  // Convert a Map back to a Customer object
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
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
