import 'package:app/Screens/homeScreen/project/cost.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'bed_model.dart';

class HydroponicBedsScreen extends StatefulWidget {
  final Box<BedModel> projectBox;

  const HydroponicBedsScreen({
    Key? key,
    required this.projectBox,
  }) : super(key: key);

  @override
  _HydroponicBedsScreenState createState() => _HydroponicBedsScreenState();
}

class _HydroponicBedsScreenState extends State<HydroponicBedsScreen> {
  late Box<BedModel> _bedsBox;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<BedModel> _filteredBeds = [];
  String _searchQuery = "";
  String _creationDate = "";
  bool _isDuplicate = false;
  BedModel? _existingBed;

  @override
  void initState() {
    super.initState();
    _bedsBox = widget.projectBox;
    _filteredBeds = _bedsBox.values.toList();
    _searchController.addListener(_updateSearch);
  }

  void _updateSearch() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filteredBeds = _bedsBox.values
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
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Create New Bed"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: "Bed Name"),
                      onChanged: (value) {
                        _checkForDuplicate(value);
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _detailsController,
                      decoration: InputDecoration(labelText: "Details"),
                      maxLines: 3,
                    ),
                    SizedBox(height: 10),
                    Text("Creation Date: $_creationDate"),
                    if (_isDuplicate && _existingBed != null) ...[
                      SizedBox(height: 10),
                      Text(
                        "Duplicate found: ${_existingBed!.name}\nCode: ${_existingBed!.code}",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
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
      },
    );
  }

  void _checkForDuplicate(String name) {
    final beds = _bedsBox.values;
    final duplicate = beds.firstWhere(
      (bed) => bed.name.toLowerCase() == name.toLowerCase(),
      orElse: () => BedModel.empty(),
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

  Future<void> _addBed() async {
    if (_nameController.text.isEmpty || _detailsController.text.isEmpty) return;

    final name = _nameController.text;
    final code = _existingBed?.code ?? randomAlphaNumeric(6);

    final newBed = BedModel(
      name: name,
      code: code,
      creationDate: _creationDate,
      details: _detailsController.text,
    );

    await _bedsBox.add(newBed);
    setState(() {
      _filteredBeds = _bedsBox.values.toList();
    });

    Navigator.of(context).pop();
  }

  void _navigateToHistoryScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryBedScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hydroponic Beds"),
        actions: [
          IconButton(
            onPressed: _navigateToHistoryScreen,
            icon: Icon(Icons.history),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CostsScreen()),
            ),
            icon: Icon(Icons.attach_money),
          ),
          IconButton(
            onPressed: _showAddBedDialog,
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
      body: ValueListenableBuilder(
        valueListenable: _bedsBox.listenable(),
        builder: (context, Box<BedModel> box, _) {
          final beds =
              _searchQuery.isEmpty ? box.values.toList() : _filteredBeds;

          return beds.isEmpty
              ? Center(child: Text("No beds found"))
              : ListView.builder(
                  itemCount: beds.length,
                  itemBuilder: (context, index) {
                    final bed = beds[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        child: ListTile(
                          title: Text(bed.name),
                          subtitle: Text(
                              "Code: ${bed.code} | Date: ${bed.creationDate}"),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}

class HistoryBedScreen extends StatefulWidget {
  const HistoryBedScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryBedScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search in History",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                // Implement search functionality later
                print("Search query: $value");
              },
            ),
          ),
        ),
      ),
      body: Center(
        child: Text(
          "This is the History Screen",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
