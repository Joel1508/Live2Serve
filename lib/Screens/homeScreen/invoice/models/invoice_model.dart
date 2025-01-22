// lib/models/invoice_model.dart
import 'package:hive/hive.dart';

part 'invoice_model.g.dart';

@HiveType(typeId: 10)
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
  final String amount;

  @HiveField(7)
  final String details;

  @HiveField(8)
  final String email;

  @HiveField(9)
  final String month;

  @HiveField(10)
  final String? imagePath;

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
    this.imagePath,
  });

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
      'imagePath': imagePath,
      'title': receiver, // For list display
      'description': details, // For list display
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      reference: map['reference'] ?? '',
      sender: map['sender'] ?? '',
      receiver: map['receiver'] ?? '',
      nit: map['nit'] ?? '',
      dateTime: map['dateTime'] ?? '',
      operation: map['operation'] ?? '',
      amount: map['amount']?.toString() ?? '0',
      details: map['details'] ?? '',
      email: map['email'] ?? '',
      month: map['month'] ?? '',
      imagePath: map['imagePath'],
    );
  }
}
