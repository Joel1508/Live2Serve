import 'package:app/repositories/customer_repository.dart'
    show Customer, CustomerRepository;
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:random_string/random_string.dart';
import 'models/customer_model.dart' as model;

class AddCustomerScreen extends StatefulWidget {
  final Customer? existingCustomer;
  final CustomerRepository customerRepository;

  const AddCustomerScreen(
      {Key? key,
      required this.existingCustomer,
      required this.customerRepository})
      : super(key: key);

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  bool isLoading = false;
  late CustomerRepository customerRepo;

  @override
  void initState() {
    super.initState();
    _initializeConnectivityListener();
  }

  void _initializeConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        customerRepo.syncUnsentCustomers();
      }
    });
  }

  Future<void> addCustomer() async {
    final name = nameController.text.trim();
    final contact = contactController.text.trim();
    final email = emailController.text.trim();
    final address = addressController.text.trim();
    final idNit = idController.text.trim();
    final uniqueCode = generateUniqueCode();

    if (name.isEmpty ||
        contact.isEmpty ||
        email.isEmpty ||
        address.isEmpty ||
        idNit.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final customer = model.CustomerModel(
        name: name,
        contactNumber: contact,
        email: email,
        address: address,
        idNit: idNit,
        uniqueCode: uniqueCode,
        id: '',
        contact: '',
        isSynced: false,
      );

      await customerRepo.addCustomer(customer as Customer);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Customer $name added successfully! Sync pending.'),
        ),
      );
      Navigator.pop(context, customer); // Return the customer object
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add customer: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String generateUniqueCode() {
    return randomAlphaNumeric(12).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(nameController, 'Name'),
            _buildTextField(contactController, 'Contact Number', isPhone: true),
            _buildTextField(emailController, 'Email', isEmail: true),
            _buildTextField(addressController, 'Address'),
            _buildTextField(idController, 'ID/NIT'),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Cancel'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: addCustomer,
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isPhone = false, bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: isPhone
            ? TextInputType.phone
            : isEmail
                ? TextInputType.emailAddress
                : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    emailController.dispose();
    addressController.dispose();
    idController.dispose();
    super.dispose();
  }
}
