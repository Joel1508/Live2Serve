// lib/Screens/homeScreen/invoice/invoice_model.dart
import 'package:hive/hive.dart';

part 'invoice_model.g.dart';

@HiveType(typeId: 0)
class Invoice extends HiveObject {
  @HiveField(0)
  final String reference;

  @HiveField(1)
  final String sender;

  @HiveField(2)
  final String receiver;

  @HiveField(3)
  final String nit;

  @HiveField(4)
  final String dateTime;

  @HiveField(5)
  final String operation;

  @HiveField(6)
  final double amount;

  @HiveField(7)
  final String details;

  @HiveField(8)
  final String email;

  @HiveField(9)
  final String month;

  @HiveField(10)
  final String title;

  @HiveField(11)
  final String description;

  Invoice({
    required this.reference,
    required this.sender,
    required this.receiver,
    required this.nit,
    required this.dateTime,
    required this.operation,
    required this.amount,
    required this.details,
    required this.email,
    required this.month,
    required this.title,
    required this.description,
  });

  // Convert Invoice to Map
  Map<String, dynamic> toMap() {
    return {
      'reference': reference,
      'sender': sender,
      'receiver': receiver,
      'nit': nit,
      'dateTime': dateTime,
      'operation': operation,
      'amount': amount,
      'details': details,
      'email': email,
      'month': month,
      'title': title,
      'description': description,
    };
  }

  // Create Invoice from Map
  static Invoice fromMap(Map<String, dynamic> map) {
    return Invoice(
      reference: map['reference'] ?? '',
      sender: map['sender'] ?? '',
      receiver: map['receiver'] ?? '',
      nit: map['nit'] ?? '',
      dateTime: map['dateTime'] ?? '',
      operation: map['operation'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      details: map['details'] ?? '',
      email: map['email'] ?? '',
      month: map['month'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
