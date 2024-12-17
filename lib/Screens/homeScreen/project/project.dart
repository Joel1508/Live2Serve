import 'package:app/Screens/homeScreen/project/interactive_map.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class HydroponicBedsScreen extends StatefulWidget {
  @override
  _HydroponicBedsScreenState createState() => _HydroponicBedsScreenState();
}

class _HydroponicBedsScreenState extends State<HydroponicBedsScreen> {
  final List<Bed> _beds = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Bed> _filteredBeds = [];
  String _searchQuery = "";

  String _creationDate = "";
  bool _isDuplicate = false;
  Bed? _existingBed;

  @override
  void initState() {
    super.initState();
    _filteredBeds = _beds; // Initialize with the full list
    _searchController.addListener(_updateSearch);
  }

  void _updateSearch() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filteredBeds = _beds
          .where((bed) =>
              bed.name.toLowerCase().contains(_searchQuery) ||
              bed.code.toLowerCase().contains(_searchQuery))
          .toList();
    });
  }

  void _showAddBedDialog() {
    setState(() {
      _isDuplicate = false;
      _existingBed = null;
      _nameController.clear();
      _detailsController.clear();
      _creationDate = DateTime.now().toString().split(' ')[0];
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create New Bed"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Bed Name"),
                  onChanged: (value) {
                    _checkForDuplicate(value);
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _detailsController,
                  decoration: InputDecoration(labelText: "Details"),
                ),
                SizedBox(height: 10),
                Text("Creation Date: $_creationDate"),
                if (_isDuplicate && _existingBed != null) ...[
                  SizedBox(height: 10),
                  Text(
                    "Duplicate found: ${_existingBed!.name}. Code: ${_existingBed!.code}",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ]
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: _addBed,
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _checkForDuplicate(String name) {
    final duplicate = _beds.firstWhere(
      (bed) => bed.name.toLowerCase() == name.toLowerCase(),
      orElse: () => Bed.empty(),
    );

    setState(() {
      if (duplicate.isNotEmpty) {
        _isDuplicate = true;
        _existingBed = duplicate;
      } else {
        _isDuplicate = false;
        _existingBed = null;
      }
    });
  }

  void _addBed() {
    if (_nameController.text.isEmpty || _detailsController.text.isEmpty) return;

    final name = _nameController.text;
    final code = _existingBed?.code ?? randomAlphaNumeric(6);

    final newBed = Bed(
      name: name,
      code: code,
      creationDate: _creationDate,
      details: _detailsController.text,
    );

    setState(() {
      _beds.add(newBed);
      _filteredBeds = _beds; // Update filtered list
    });

    Navigator.of(context).pop();
  }

  void _viewBedDetails(Bed bed) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Bed Details"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Name: ${bed.name}"),
              Text("Code: ${bed.code}"),
              Text("Creation Date: ${bed.creationDate}"),
              Text("Details: ${bed.details}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hydroponic Beds"),
        actions: [
          IconButton(
            onPressed: _showAddBedDialog,
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InteractiveMapScreen(),
                ),
              );
            },
            icon: Icon(Icons.map), // Button to navigate to the interactive map
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search by Name or Code",
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
      body: _filteredBeds.isEmpty
          ? Center(child: Text("No beds found"))
          : ListView.builder(
              itemCount: _filteredBeds.length,
              itemBuilder: (context, index) {
                final bed = _filteredBeds[index];
                return Card(
                  child: ListTile(
                    title: Text(bed.name),
                    subtitle:
                        Text("Code: ${bed.code} | Date: ${bed.creationDate}"),
                    onTap: () => _viewBedDetails(bed),
                  ),
                );
              },
            ),
    );
  }
}

class Bed {
  final String name;
  final String code;
  final String creationDate;
  final String details;

  Bed({
    required this.name,
    required this.code,
    required this.creationDate,
    required this.details,
  });

  static Bed empty() => Bed(name: "", code: "", creationDate: "", details: "");

  bool get isNotEmpty => name.isNotEmpty;
}
