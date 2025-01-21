import 'dart:io';
import 'package:app/Screens/homeScreen/invoice/models/invoice_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class InvoiceClientScreen extends StatefulWidget {
  final Function(Invoice) onInvoiceSaved;

  InvoiceClientScreen({required this.onInvoiceSaved});

  @override
  _InvoiceClientScreenState createState() => _InvoiceClientScreenState();
}

class _InvoiceClientScreenState extends State<InvoiceClientScreen> {
  final TextEditingController _issuedToController = TextEditingController();
  final TextEditingController _nitCcController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senderController =
      TextEditingController(text: "Fres.Co");
  File? _selectedImage;
  bool showPreview = false;
  late Invoice _currentInvoice;
  final ImagePicker _picker = ImagePicker();

  String _issuedToOption = "Select Customer";
  final List<String> _issuedToOptions = ["Select Customer", "New Customer"];
  final List<String> _customerList = [];

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_formatNumber);
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _issuedToController.dispose();
    _nitCcController.dispose();
    _amountController.dispose();
    _detailsController.dispose();
    _emailController.dispose();
    _senderController.dispose();
    super.dispose();
  }

  void _formatNumber() {
    // Remove all non-numeric characters (except for the minus sign if needed)
    String text = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.isNotEmpty) {
      try {
        final number = int.parse(text);
        final formattedText = NumberFormat.decimalPattern().format(number);
        _amountController.value = TextEditingValue(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
        );
      } catch (e) {
        debugPrint('Error parsing number: $e');
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _saveInvoice() {
    final now = DateTime.now();

    // Create invoice using the Invoice model
    final invoice = Invoice(
      reference: 'INV-${now.millisecondsSinceEpoch}',
      sender: _senderController.text,
      receiver: _issuedToController.text,
      nit: _nitCcController.text,
      dateTime: DateFormat('yyyy-MM-dd HH:mm').format(now),
      operation: 'Products',
      amount: _amountController.text,
      details: _detailsController.text,
      email: _emailController.text,
      month: DateFormat('MMMM yyyy').format(now),
      imagePath: _selectedImage?.path,
    );

    setState(() {
      _currentInvoice = invoice;
      showPreview = true;
    });

    // Don't call onInvoiceSaved here - wait for user confirmation in preview
  }

  InputDecoration _customInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    );
  }

  Widget _buildPreview() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Preview'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // Only save and pop when user confirms
              widget.onInvoiceSaved(_currentInvoice);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Invoice saved successfully!")),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              setState(() {
                showPreview = false;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  padding: EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentInvoice.sender,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "INVOICE",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Invoice No.",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Text(
                                  _currentInvoice.reference,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 40),

                      // Bill To Section
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "BILL TO",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              _currentInvoice.receiver,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text("NIT/CC: ${_currentInvoice.nit}"),
                            Text(_currentInvoice.email),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),

                      // Amount Section
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Amount",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "\$${_currentInvoice.amount}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),

                      // Details Section
                      if (_currentInvoice.details.isNotEmpty) ...[
                        Text(
                          "DETAILS",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(_currentInvoice.details),
                        ),
                      ],

                      if (_selectedImage != null) ...[
                        SizedBox(height: 24),
                        Text(
                          "ATTACHMENT",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(_selectedImage!),
                        ),
                      ],

                      // Footer
                      SizedBox(height: 24),
                      Divider(),
                      SizedBox(height: 16),
                      Center(
                        child: Text(
                          _currentInvoice.dateTime,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value) {
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
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showPreview
          ? _buildPreview()
          : Scaffold(
              appBar: AppBar(
                title: Text("Client Invoice"),
                centerTitle: true,
                backgroundColor: Color(0xFFFF9FAFB),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _senderController,
                                decoration: _customInputDecoration("Sender"),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Optional: Add functionality if needed
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      "Issued To:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    DropdownButtonFormField<String>(
                      decoration: _customInputDecoration("Select Customer"),
                      value: _issuedToOption,
                      items: _issuedToOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _issuedToOption = newValue!;
                        });
                      },
                    ),
                    if (_issuedToOption == "New Customer") ...[
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _issuedToController,
                        decoration: _customInputDecoration("New Customer Name"),
                      ),
                    ],
                    if (_issuedToOption == "Select Customer") ...[
                      SizedBox(height: 16.0),
                      DropdownButtonFormField<String>(
                        decoration:
                            _customInputDecoration("Registered Customers"),
                        value: _customerList.isNotEmpty
                            ? _customerList.first
                            : null,
                        items: _customerList.map((String customer) {
                          return DropdownMenuItem<String>(
                            value: customer,
                            child: Text(customer),
                          );
                        }).toList(),
                        onChanged: (String? selectedCustomer) {
                          setState(() {
                            _issuedToController.text = selectedCustomer ?? "";
                          });
                        },
                        hint: Text("No customers available"),
                      ),
                    ],
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _nitCcController,
                      decoration: _customInputDecoration("Nit / CC"),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      "Operation:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Products", // Default operation
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _amountController,
                      decoration: _customInputDecoration("Amount"),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _detailsController,
                      decoration: _customInputDecoration("Details"),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _emailController,
                      decoration: _customInputDecoration("Email"),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      "Image:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    GestureDetector(
                      onTap: () => _pickImage(ImageSource.gallery),
                      child: Container(
                        height: 150.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.add_a_photo,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _saveInvoice();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF5EBA7D),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text(
                          "Preview Invoice",
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
