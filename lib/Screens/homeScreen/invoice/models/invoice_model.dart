// lib/Screens/homeScreen/invoice/invoice_model.dart
import 'package:hive/hive.dart';

part 'invoice_model.g.dart';

@HiveType(typeId: 3) // Changed from 0 to avoid conflicts
class Invoice extends HiveObject {
  @HiveField(0)
  late String reference;

  @HiveField(1)
  late String sender;

  @HiveField(2)
  late String receiver;

  @HiveField(3)
  late String nit;

  @HiveField(4)
  late String dateTime;

  @HiveField(5)
  late String operation;

  @HiveField(6)
  late double amount;

  @HiveField(7)
  late String details;

  @HiveField(8)
  late String email;

  @HiveField(9)
  late String month;

  @HiveField(10)
  late String title;

  @HiveField(11)
  late String description;

  // Default constructor
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

  // Empty constructor for Hive
  Invoice.empty() {
    reference = '';
    sender = '';
    receiver = '';
    nit = '';
    dateTime = '';
    operation = '';
    amount = 0.0;
    details = '';
    email = '';
    month = '';
    title = '';
    description = '';
  }

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
  factory Invoice.fromMap(Map<String, dynamic> map) {
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
