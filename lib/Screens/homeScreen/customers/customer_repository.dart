import 'package:app/Screens/homeScreen/customers/customer.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomerRepository {
  final Box customerBox;

  // Constructor accepts the Hive box instance
  CustomerRepository({required this.customerBox});

  // Add a new customer to the box
  Future<void> addCustomer(Customer? customer) async {
    if (customer != null) {
      await customerBox.add(customer.toMap());
    }
  }

  // Get a list of customers (you can format it or filter as needed)
  Future<List<Map<String, dynamic>>> getCustomerList() async {
    return customerBox.values.cast<Map<String, dynamic>>().toList();
  }

  // Remove a customer by key (you can use a unique key for each customer)
  Future<void> removeCustomer(int index) async {
    await customerBox.deleteAt(index);
  }

  // Get a specific customer by key (index)
  Future<Map<String, dynamic>?> getCustomer(int index) async {
    return customerBox.getAt(index);
  }

  void syncUnsentCustomers() {}
}
