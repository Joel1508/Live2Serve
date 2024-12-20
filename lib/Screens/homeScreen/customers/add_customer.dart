import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({Key? key, required Map<String, dynamic> initialData})
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

  // Cancel function to go back to the previous screen
  void cancel() {
    Navigator.pop(context);
  }

  // Function to add customer details and validate the form
  void addCustomer() async {
    String name = nameController.text;
    String contact = contactController.text;
    String email = emailController.text;
    String address = addressController.text;
    String id = idController.text;

    // Check if all fields are filled
    if (name.isNotEmpty &&
        contact.isNotEmpty &&
        email.isNotEmpty &&
        address.isNotEmpty &&
        id.isNotEmpty) {
      // Generate a unique customer code
      String uniqueCode = randomAlphaNumeric(12);

      // Create a map to hold the data to insert into Supabase
      final customerData = {
        'name': name,
        'contact': contact,
        'email': email,
        'address': address,
        'id': id,
        'uniqueCode': uniqueCode,
      };

      try {
        // Insert the customer data into Supabase
        final response = await Supabase.instance.client
            .from('customers')
            .insert([customerData]);

        if (response.error != null) {
          // Handle the error (if any)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.error?.message}')),
          );
        } else {
          // Success, navigate back with the new customer data
          Navigator.pop(context, customerData);
        }
      } catch (error) {
        // Handle any other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $error')),
        );
      }
    } else {
      // Show error message if fields are not completed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDCDD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDEDCDD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: cancel,
        ),
        centerTitle: true,
        title: const Text(
          'Add Customer',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name field
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Contact field
            TextField(
              controller: contactController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Contact Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Email field
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Address field
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // ID/NIT field
            TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: 'ID/NIT',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Action buttons (Cancel and Add)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: cancel,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFD8D0BD)),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: addCustomer,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFD8D0BD)),
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
