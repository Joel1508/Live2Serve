// lib/services/invoice_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/invoice_model.dart';

class InvoiceService {
  static final InvoiceService _instance = InvoiceService._internal();
  late Box<Invoice> _invoiceBox;

  // Private constructor
  InvoiceService._internal();

  // Getter for the singleton instance
  static InvoiceService get instance => _instance;

  // Initialize the service
  Future<void> init() async {
    if (!Hive.isBoxOpen('invoiceBox')) {
      _invoiceBox = await Hive.openBox<Invoice>('invoiceBox');
    } else {
      _invoiceBox = Hive.box<Invoice>('invoiceBox');
    }
  }

  // Add new invoice
  Future<void> addInvoice(Invoice invoice) async {
    await _invoiceBox.add(invoice);
  }

  // Get all invoices
  List<Invoice> getAllInvoices() {
    return _invoiceBox.values.toList();
  }

  // Get invoice by id
  Invoice? getInvoice(int id) {
    return _invoiceBox.getAt(id);
  }

  // Delete invoice
  Future<void> deleteInvoice(int id) async {
    await _invoiceBox.deleteAt(id);
  }

  // Update invoice
  Future<void> updateInvoice(int id, Invoice invoice) async {
    await _invoiceBox.putAt(id, invoice);
  }
}
