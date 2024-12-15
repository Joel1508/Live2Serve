import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class InvoiceClientScreen extends StatefulWidget {
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
      TextEditingController(text: "Default User Name");
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  String _issuedToOption = "Select Customer";
  final List<String> _issuedToOptions = ["Select Customer", "New Customer"];
  final List<String> _customerList = []; // Placeholder for registered customers

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Client Invoice"),
        centerTitle: true,
        backgroundColor: Color(0xFFFDEDCDD),
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _senderController,
                    decoration: InputDecoration(
                      labelText: "Sender",
                      border: OutlineInputBorder(),
                    ),
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
            SizedBox(height: 16.0),
            Text(
              "Issued To:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            DropdownButton<String>(
              isExpanded: true,
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
                decoration: InputDecoration(
                  labelText: "New Customer Name",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            if (_issuedToOption == "Select Customer") ...[
              SizedBox(height: 16.0),
              DropdownButton<String>(
                isExpanded: true,
                value: _customerList.isNotEmpty ? _customerList.first : null,
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
              decoration: InputDecoration(
                labelText: "Nit / CC",
                border: OutlineInputBorder(),
              ),
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
              decoration: InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _detailsController,
              decoration: InputDecoration(
                labelText: "Details",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
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
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
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
                  // Handle saving the invoice
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF979DAB),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  "Save Invoice",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
