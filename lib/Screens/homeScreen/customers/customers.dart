import 'package:flutter/material.dart';
import 'package:app/Screens/homeScreen/customers/add_customer.dart';

class CustomersScreen extends StatefulWidget {
  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  List<Map<String, dynamic>> customersList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDCDD),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Top Section: Back button, title, and add customer icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  'Customers',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.person_add, color: Colors.black),
                  onPressed: () async {
                    final newCustomer = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddCustomerScreen(initialData: {}),
                      ),
                    );

                    if (newCustomer != null) {
                      setState(() {
                        customersList.add(newCustomer);
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount: customersList.length,
                  itemBuilder: (context, index) {
                    return _buildCustomerRow(customersList[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerRow(Map<String, dynamic> customer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: Row(
          children: [
            const Icon(Icons.person, color: Colors.grey, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _showCustomerDetails(customer);
                },
                child: Text(
                  customer['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onPressed: () {
                _showEditDeleteMenu(customer);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDeleteMenu(Map<String, dynamic> customer) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                _editCustomer(customer);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _deleteCustomer(customer);
              },
            ),
          ],
        );
      },
    );
  }

  void _editCustomer(Map<String, dynamic> customer) async {
    final updatedCustomer = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCustomerScreen(initialData: customer),
      ),
    );

    if (updatedCustomer != null) {
      setState(() {
        final index = customersList.indexOf(customer);
        customersList[index] = updatedCustomer;
      });
    }
  }

  void _deleteCustomer(Map<String, dynamic> customer) {
    setState(() {
      customersList.remove(customer);
    });
  }

  void _showCustomerDetails(Map<String, dynamic> customer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(customer['name']),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                if (customer['address'] != null &&
                    customer['address'].isNotEmpty)
                  Text('Address: ${customer['address']}'),
                if (customer['contact'] != null &&
                    customer['contact'].isNotEmpty)
                  Text('Contact: ${customer['contact']}'),
                if (customer['email'] != null && customer['email'].isNotEmpty)
                  Text('Email: ${customer['email']}'),
                if (customer['id'] != null && customer['id'].isNotEmpty)
                  Text('ID/NIT: ${customer['id']}'),
                if (customer['uniqueCode'] != null &&
                    customer['uniqueCode'].isNotEmpty)
                  Text('Code: ${customer['uniqueCode']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
