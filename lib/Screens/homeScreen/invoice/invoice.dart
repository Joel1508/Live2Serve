// invoice.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/invoice_model.dart';

class InvoiceScreen extends StatefulWidget {
  final Box invoiceBox;

  const InvoiceScreen({Key? key, required this.invoiceBox}) : super(key: key);

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final List<Map<String, dynamic>> _invoices = [];
  late Box<Invoice> invoiceBox;

  @override
  void initState() {
    super.initState();
    invoiceBox = Hive.box<Invoice>('invoiceBox');
    _loadInvoices();
  }

  void _loadInvoices() {
    final invoices =
        invoiceBox.values.map((invoice) => invoice.toMap()).toList();
    setState(() {
      _invoices.clear();
      _invoices.addAll(invoices);
    });
  }

  // Add new invoice
  void addInvoice(Map<String, dynamic> invoiceData) {
    final invoice = Invoice.fromMap(invoiceData);
    invoiceBox.add(invoice);
    _loadInvoices();
  }

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
                      "Reference Number",
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
              _buildDetailRow("Date & Time *", invoice['dateTime']),
              _buildDetailRow("Operación *", invoice['operation']),
              _buildDetailRow("Amount *", "\$ ${invoice['amount']}",
                  boldValue: true),
              _buildDetailRow("Details", invoice['details']),
              _buildDetailRow("Mail", invoice['email']),
              SizedBox(height: 10),
              Text("Picture", style: TextStyle(fontWeight: FontWeight.bold)),
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice History"),
        centerTitle: true,
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.receipt),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade300,
              Colors.pink.shade200,
            ],
          ),
        ),
        child: _invoices.isEmpty
            ? Center(
                child: Text(
                  "No invoices available.",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: _invoices.length,
                itemBuilder: (context, index) {
                  final invoice = _invoices[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index == 0 ||
                          _invoices[index - 1]['month'] != invoice['month'])
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            invoice['month'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading: Icon(Icons.receipt, color: Colors.purple),
                          title: Text(
                            invoice['title'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(invoice['description']),
                          trailing: Text(
                            "\$${invoice['amount']}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () => _showInvoiceDetails(invoice),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
