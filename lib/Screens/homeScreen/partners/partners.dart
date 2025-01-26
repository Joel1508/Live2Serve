import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Partner {
  final String name;
  final String contactNumber;
  final String email;
  final String address;
  final String description;
  final String id;

  Partner({
    required this.name,
    required this.contactNumber,
    required this.email,
    required this.address,
    required this.description,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contactNumber': contactNumber,
      'email': email,
      'address': address,
      'description': description,
      'id': id,
    };
  }

  factory Partner.fromMap(Map<String, dynamic> map) {
    return Partner(
      name: map['name'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      description: map['description'] ?? '',
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }
}

class PartnersScreen extends StatefulWidget {
  final Box partnerBox;

  const PartnersScreen({Key? key, required this.partnerBox}) : super(key: key);

  @override
  _PartnersScreenState createState() => _PartnersScreenState();
}

class _PartnersScreenState extends State<PartnersScreen> {
  late Box _partnersBox;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _filteredPartners = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _partnersBox = widget.partnerBox;
    _filteredPartners =
        _partnersBox.values.toList().cast<Map<String, dynamic>>();
    _searchController.addListener(_updateSearch);
  }

  void _updateSearch() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filteredPartners = _partnersBox.values
          .where((dynamic item) {
            final Map<String, dynamic> partner =
                Map<String, dynamic>.from(item as Map);
            final p = Partner.fromMap(partner);
            return p.name.toLowerCase().contains(_searchQuery) ||
                p.email.toLowerCase().contains(_searchQuery) ||
                p.contactNumber.contains(_searchQuery);
          })
          .map((dynamic item) => Map<String, dynamic>.from(item as Map))
          .toList();
    });
  }

  void _showAddPartnerDialog() {
    setState(() {
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _addressController.clear();
      _descriptionController.clear();
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Partner"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: "Phone"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: "Address"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: "Description"),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black54),
              ),
            ),
            ElevatedButton(
              onPressed: _addPartner,
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xFFFB5DAB9)),
              child: Text(
                "Save",
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        );
      },
    );
  }

  void _addPartner() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _addressController.text.isEmpty) return;

    final newPartner = Partner(
      name: _nameController.text,
      contactNumber: _phoneController.text,
      email: _emailController.text,
      address: _addressController.text,
      description: _descriptionController.text,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    _partnersBox.add(newPartner.toMap());
    setState(() {
      _filteredPartners =
          _partnersBox.values.toList().cast<Map<String, dynamic>>();
    });

    Navigator.of(context).pop();
  }

  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Partner"),
          content: Text("Are you sure you want to delete this partner?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _partnersBox.deleteAt(index);
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF69697),
              ),
            ),
          ],
        );
      },
    );
  }

  void _viewPartnerDetails(Partner partner) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Partner Details"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Name: ${partner.name}"),
              Text("Phone: ${partner.contactNumber}"),
              Text("Email: ${partner.email}"),
              Text("Address: ${partner.address}"),
              Text("Description: ${partner.description}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Close",
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFF9FAFB),
        appBar: AppBar(
          title: Text("Partners"),
          actions: [
            IconButton(
              onPressed: _showAddPartnerDialog,
              icon: Icon(Icons.add),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
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
          valueListenable: _partnersBox.listenable(),
          builder: (context, Box box, _) {
            final partners = _searchQuery.isEmpty
                ? box.values
                    .map((dynamic item) =>
                        Map<String, dynamic>.from(item as Map))
                    .toList()
                : _filteredPartners;

            return partners.isEmpty
                ? Center(child: Text("No partners found"))
                : ListView.builder(
                    itemCount: partners.length,
                    itemBuilder: (context, index) {
                      final partner = Partner.fromMap(partners[index]);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Card(
                          child: ListTile(
                            title: Text(partner.name),
                            subtitle: Text(
                                "Phone: ${partner.contactNumber} | Email: ${partner.email}"),
                            trailing: IconButton(
                              icon:
                                  Icon(Icons.delete, color: Color(0xFFFF69697)),
                              onPressed: () => _showDeleteConfirmation(index),
                            ),
                            onTap: () => _viewPartnerDetails(partner),
                          ),
                        ),
                      );
                    },
                  );
          },
        ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
