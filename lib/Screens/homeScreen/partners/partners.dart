import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class Partner {
  final String name;
  final String contactNumber;
  final String email;
  final String address;
  final String id;

  Partner({
    required this.name,
    required this.contactNumber,
    required this.email,
    required this.address,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contactNumber': contactNumber,
      'email': email,
      'address': address,
      'id': id,
    };
  }

  factory Partner.fromMap(Map<String, dynamic> map) {
    return Partner(
      name: map['name'],
      contactNumber: map['contactNumber'],
      email: map['email'],
      address: map['address'],
      id: map['id'],
    );
  }
}

class PartnersScreen extends StatefulWidget {
  final Box partnerBox;
  PartnersScreen({required this.partnerBox});

  @override
  _PartnersScreenState createState() => _PartnersScreenState();
}

class _PartnersScreenState extends State<PartnersScreen> {
  late Box _partnersBox;

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    await Hive.initFlutter();
    _partnersBox = await Hive.openBox('partnersBox',
        encryptionCipher: _getEncryptionCipher());
    setState(() {});
  }

  HiveAesCipher _getEncryptionCipher() {
    final key = sha256
        .convert(utf8.encode('your-secure-password'))
        .bytes
        .sublist(0, 32);
    return HiveAesCipher(key);
  }

  void _addPartner(Partner partner) {
    _partnersBox.add(partner.toMap());
    setState(() {});
  }

  void _deletePartner(int index) {
    _partnersBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Partners'),
      ),
      body: ValueListenableBuilder(
        valueListenable: _partnersBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return Center(
              child: Text('No partners added yet.'),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final partnerMap = box.getAt(index) as Map<String, dynamic>;
              final partner = Partner.fromMap(partnerMap);
              return ListTile(
                title: Text(partner.name),
                subtitle: Text(partner.contactNumber),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deletePartner(index),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPartner = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPartnerScreen(),
            ),
          );
          if (newPartner != null && newPartner is Partner) {
            _addPartner(newPartner);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddPartnerScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Partner'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: 'Contact Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a contact number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newPartner = Partner(
                      name: _nameController.text,
                      contactNumber: _contactController.text,
                      email: _emailController.text,
                      address: _addressController.text,
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                    );
                    Navigator.pop(context, newPartner);
                  }
                },
                child: Text('Add Partner'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
