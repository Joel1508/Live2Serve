import 'package:app/Screens/homeScreen/customers/models/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:app/repositories/customer_repository.dart';

class CustomersScreen extends StatefulWidget {
  final CustomerRepository customerRepo;

  const CustomersScreen({Key? key, required this.customerRepo})
      : super(key: key);

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  // MARK: - Properties
  late Box<CustomerModel> customerBox;
  List<CustomerModel> _filteredCustomers = [];
  String _searchQuery = "";

  // MARK: - Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _idNitController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  // MARK: - Lifecycle Methods
  @override
  void initState() {
    super.initState();
    customerBox = widget.customerRepo.customerBox as Box<CustomerModel>;
    _filteredCustomers = customerBox.values.toList();
    _searchController.addListener(_updateSearch);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _idNitController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // MARK: - Private Methods
  void _clearControllers() {
    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _addressController.clear();
    _idNitController.clear();
    _descriptionController.clear();
  }

  void _updateSearch() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filteredCustomers = customerBox.values.where((customer) {
        return customer.name.toLowerCase().contains(_searchQuery) ||
            customer.email.toLowerCase().contains(_searchQuery) ||
            customer.contactNumber.contains(_searchQuery) ||
            customer.idNit.contains(_searchQuery);
      }).toList();
    });
  }

  void _addCustomer() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty) return;

    final newCustomer = CustomerModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      contactNumber: _phoneController.text,
      email: _emailController.text,
      address: _addressController.text,
      idNit: _idNitController.text,
      uniqueCode: DateTime.now().millisecondsSinceEpoch.toString(),
      contact: _phoneController.text,
      isSynced: false,
    );

    customerBox.add(newCustomer);
    setState(() {
      _filteredCustomers = customerBox.values.toList();
    });

    Navigator.of(context).pop();
  }

  // MARK: - Dialog Methods
  void _showAddCustomerDialog() {
    _clearControllers();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Customer"),
        content: SingleChildScrollView(
          child: _buildAddCustomerForm(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: _addCustomer,
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Customer"),
        content: const Text("Are you sure you want to delete this customer?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              customerBox.deleteAt(index);
              setState(() {
                _filteredCustomers = customerBox.values.toList();
              });
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF69697),
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _viewCustomerDetails(CustomerModel customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(customer.name),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Phone: ${customer.contactNumber}"),
            Text("Email: ${customer.email}"),
            Text("Address: ${customer.address}"),
            Text("ID/NIT: ${customer.idNit}"),
            Text("Unique Code: ${customer.uniqueCode}"),
            Text("Contact: ${customer.contact}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  // MARK: - UI Builder Methods
  Widget _buildAddCustomerForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: "Name"),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(labelText: "Phone"),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: "Email"),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _addressController,
          decoration: const InputDecoration(labelText: "Address"),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _idNitController,
          decoration: const InputDecoration(labelText: "ID/NIT"),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(labelText: "Description"),
          maxLines: 3,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF9FAFB),
      appBar: AppBar(
        title: const Text("Customers"),
        actions: [
          IconButton(
            onPressed: _showAddCustomerDialog,
            icon: const Icon(Icons.add),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: customerBox.listenable(),
        builder: (context, Box<CustomerModel> box, _) {
          final customers =
              _searchQuery.isEmpty ? box.values.toList() : _filteredCustomers;

          return customers.isEmpty
              ? const Center(child: Text("No customers found"))
              : ListView.builder(
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        child: ListTile(
                          title: Text(customer.name),
                          subtitle: Text(
                              "Phone: ${customer.contactNumber} | ID/NIT: ${customer.idNit}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Color(0xFFFF69697)),
                            onPressed: () => _showDeleteConfirmation(index),
                          ),
                          onTap: () => _viewCustomerDetails(customer),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
