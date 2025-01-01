import 'package:flutter/material.dart';
import 'package:app/Screens/homeScreen/customers/add_customer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app/repositories/customer_repository.dart'
    show Customer, CustomerRepository;

class CustomersScreen extends StatefulWidget {
  final CustomerRepository customerRepo;

  const CustomersScreen({Key? key, required this.customerRepo})
      : super(key: key);

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  late Box customerBox;

  @override
  void initState() {
    super.initState();
    customerBox = widget.customerRepo.customerBox;
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    await Hive.initFlutter();

    const secureStorage = FlutterSecureStorage();
    String? encryptionKey = await secureStorage.read(key: 'encryptionKey');

    if (encryptionKey == null) {
      final key = Hive.generateSecureKey();
      encryptionKey = key.join(',');
      await secureStorage.write(key: 'encryptionKey', value: encryptionKey);
    }

    final encryptionKeyBytes = encryptionKey.split(',').map(int.parse).toList();

    customerBox = await Hive.openBox(
      'customers',
      encryptionCipher: HiveAesCipher(encryptionKeyBytes),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDCD),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildHeader(),
            const SizedBox(height: 16),
            _buildCustomerList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
                builder: (context) => AddCustomerScreen(existingCustomer: null),
              ),
            );

            if (newCustomer != null) {
              _addCustomer(newCustomer);
            }
          },
        ),
      ],
    );
  }

  Widget _buildCustomerList() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ValueListenableBuilder(
          valueListenable: customerBox.listenable(),
          builder: (context, Box box, _) {
            final customerList = box.values.toList();
            return ListView.builder(
              itemCount: customerList.length,
              itemBuilder: (context, index) {
                return _buildCustomerRow(customerList[index]);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCustomerRow(Map customer) {
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

  void _addCustomer(Map<String, dynamic> customer) {
    customerBox.add(customer);
  }

  void _editCustomer(Map<dynamic, dynamic> customer) async {
    Customer customerObj = Customer(
        id: customer['id'] ?? '',
        name: customer['name'] ?? '',
        contactNumber: customer['contactNumber'] ?? '',
        email: customer['email'] ?? '',
        address: customer['address'] ?? '',
        idNit: customer['ID/NIT'] ?? '',
        uniqueCode: customer['uniqueCode'] ?? '',
        contact: customer['contact'] ?? '',
        isSynced: customer['isSynced'] ?? false);

    final updatedCustomer = await Navigator.push<Customer?>(
      context,
      MaterialPageRoute<Customer?>(
        builder: (context) =>
            AddCustomerScreen(existingCustomer: customerObj as Customer?),
      ),
    );

    if (updatedCustomer != null) {
      // No need to check is Customer
      final index = customerBox.values.toList().indexOf(customer);
      if (index != -1) {
        customerBox.putAt(index, {
          'id': updatedCustomer.id,
          'name': updatedCustomer.name,
          'contactNumber': updatedCustomer.contactNumber,
          'email': updatedCustomer.email,
          'address': updatedCustomer.address,
          'ID/NIT': updatedCustomer.idNit,
          'uniqueCode': updatedCustomer.uniqueCode,
          'contact': updatedCustomer.contact,
          'isSynced': updatedCustomer.isSynced
        });
      }
    }
  }

  void _deleteCustomer(Map customer) {
    final index = customerBox.values.toList().indexOf(customer);
    customerBox.deleteAt(index);
  }

  void _showCustomerDetails(Map customer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(customer['name']),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                if (customer['address']?.isNotEmpty ?? false)
                  Text('Address: ${customer['address']}'),
                if (customer['contact']?.isNotEmpty ?? false)
                  Text('Contact: ${customer['contact']}'),
                if (customer['email']?.isNotEmpty ?? false)
                  Text('Email: ${customer['email']}'),
                if (customer['id']?.isNotEmpty ?? false)
                  Text('ID/NIT: ${customer['id']}'),
                if (customer['uniqueCode']?.isNotEmpty ?? false)
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

  void _showEditDeleteMenu(Map customer) {
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
}
