// invoice.dart
import 'package:FRES.CO/Screens/homeScreen/add_client_invoice.dart';
import 'package:FRES.CO/Screens/homeScreen/invoice/models/invoice_model.dart';
import 'package:FRES.CO/Screens/homeScreen/invoice/services/invoice_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final List<Map<String, dynamic>> _invoices = [];
  final InvoiceService _invoiceService = InvoiceService.instance;
  late Box<Invoice> invoiceBox;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      await _invoiceService.init();
      invoiceBox = await Hive.openBox<Invoice>('invoices');
      await _loadInvoices();
    } catch (e) {
      setState(() {
        _error = 'Failed to initialize storage: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadInvoices() async {
    try {
      final invoices = _invoiceService.getAllInvoices();
      setState(() {
        _invoices.clear();
        _invoices.addAll(invoices.map((invoice) => invoice.toMap()).toList());
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load invoices: $e';
      });
    }
  }

  Future<void> _addInvoice(Invoice invoice) async {
    try {
      await _invoiceService.addInvoice(invoice);
      await _loadInvoices();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invoice saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save invoice: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _addNewInvoice() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvoiceClientScreen(
          onInvoiceSaved: _addInvoice,
        ),
      ),
    );
  }

  /// Add a new invoice to the Hive box
  void addInvoice(Map<String, dynamic> invoiceData) {
    final invoice = Invoice.fromMap(invoiceData);
    invoiceBox.add(invoice);
    _loadInvoices();
  }

  /// Show invoice details in a bottom sheet
  void _showInvoiceDetails(Map<String, dynamic> invoice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      "Numero de referencia",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "# ${invoice['reference']}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _buildDetailRow("Remitente *", invoice['sender']),
              _buildDetailRow("Emitida A: *", invoice['receiver']),
              _buildDetailRow("Nit / CC *", invoice['nit']),
              _buildDetailRow("Fecha & Hora *", invoice['dateTime']),
              _buildDetailRow("Operación *", invoice['operation']),
              _buildDetailRow("Monto *", "\$ ${invoice['amount']}",
                  boldValue: true),
              _buildDetailRow("Detalles", invoice['details']),
              _buildDetailRow("Mail", invoice['email']),
              SizedBox(height: 10),
              Text("Imagen", style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[300],
                child: Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to build a detail row
  Widget _buildDetailRow(String label, String value, {bool boldValue = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              value,
              style: TextStyle(
                  fontWeight: boldValue ? FontWeight.bold : FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: Container(
          decoration: _buildGradientDecoration(),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: Container(
          decoration: _buildGradientDecoration(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  _error!,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _initializeService,
                  icon: Icon(Icons.refresh),
                  label: Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        decoration: _buildGradientDecoration(),
        child: RefreshIndicator(
          onRefresh: _loadInvoices,
          child: _invoices.isEmpty ? _buildEmptyState() : _buildInvoicesList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewInvoice,
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFF8ABC8B),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text("Historial"),
      centerTitle: true,
      backgroundColor: Color(0xFFFCFCFCF),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  BoxDecoration _buildGradientDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFCFCFCF),
          Color(0xFFFF9FAFB),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            "Sin facturas disponibles.",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Toca el boton + para añadir nueva factura",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoicesList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: _invoices.length,
      itemBuilder: (context, index) {
        final invoice = _invoices[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index == 0 || _invoices[index - 1]['month'] != invoice['month'])
              _buildMonthHeader(invoice['month']),
            _buildInvoiceCard(invoice),
          ],
        );
      },
    );
  }

  Widget _buildMonthHeader(String month) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        month,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInvoiceCard(Map<String, dynamic> invoice) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showInvoiceDetails(invoice),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.receipt, color: Color(0xFFF5EBA7D)),
          ),
          title: Text(
            invoice['receiver'] ??
                '', // Changed from 'Dirigido a' to 'receiver'
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            invoice['details'] ?? '', // Changed from 'descripción' to 'details'
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "\$${invoice['amount'] ?? '0'}", // Added null check
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                _formatDate(invoice['dateTime'] ??
                    ''), // Changed from 'fecha & hora' to 'dateTime'
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('MMM d, y').format(date);
    } catch (e) {
      return dateTime;
    }
  }
}
