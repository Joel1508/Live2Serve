import 'package:FRES.CO/Screens/homeScreen/harvest_invoice_model.dart';
import 'package:FRES.CO/Screens/homeScreen/project/cost.dart';
import 'package:FRES.CO/Screens/homeScreen/project/models/cost_model.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/bed_model.dart';

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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(value),
          ),
        ],
      ),
    );
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
              title: Text("Crear nueva cama"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: "Nombre"),
                      onChanged: (value) {
                        _checkForDuplicate(value);
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _detailsController,
                      decoration: InputDecoration(labelText: "Detalles"),
                      maxLines: 3,
                    ),
                    SizedBox(height: 10),
                    Text("Fecha creación: $_creationDate"),
                    if (_isDuplicate && _existingBed != null) ...[
                      SizedBox(height: 10),
                      Text(
                        "Ya existe una cama con ese nombre: ${_existingBed!.name}\nCódigo: ${_existingBed!.code}",
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
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addBed,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFB5DAB9)),
                  child: Text(
                    "Guardar",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showBedDetailsDialog(BedModel bed, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Detalles"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow("Nombre:", bed.name),
                _buildDetailRow("Código:", bed.code),
                _buildDetailRow("Fecha de creación:", bed.creationDate),
                _buildDetailRow("Detalles:", bed.details),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cerrar",
                style: TextStyle(color: Colors.black54),
              ),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xFFFB5DAB9)),
              onPressed: () {
                Navigator.of(context).pop();
                _showEditBedDialog(bed, index);
              },
              child: Text(
                "Editar",
                style: TextStyle(color: Colors.black54),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteBed(index);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  void _showEditBedDialog(BedModel bed, int index) {
    _nameController.text = bed.name;
    _detailsController.text = bed.details;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Editar"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: "Nombre"),
                      onChanged: (value) {
                        _checkForDuplicate(value);
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _detailsController,
                      decoration: InputDecoration(labelText: "Detalles"),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _updateBed(index),
                  child: Text(
                    "Guardar",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _updateBed(int index) {
    if (_nameController.text.isEmpty || _detailsController.text.isEmpty) return;

    final updatedBed = BedModel(
      name: _nameController.text,
      code: _bedsBox.getAt(index)!.code,
      creationDate: _bedsBox.getAt(index)!.creationDate,
      details: _detailsController.text,
    );

    _bedsBox.putAt(index, updatedBed);
    setState(() {
      _filteredBeds = _bedsBox.values.toList();
    });

    Navigator.of(context).pop();
  }

  void _deleteBed(int index) {
    _bedsBox.deleteAt(index);
    setState(() {
      _filteredBeds = _bedsBox.values.toList();
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Proyecto Hidropónico"),
        actions: [
          IconButton(
            onPressed: _navigateToHistoryScreen,
            icon: Icon(Icons.history),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CostsScreen(costsBox: Hive.box<CostModel>('costs'))),
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
                hintText: "Buscar",
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
              ? Center(child: Text("No se encontraron camas creadas"))
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
                              "Código: ${bed.code} | Fecha: ${bed.creationDate}"),
                          onTap: () => _showBedDetailsDialog(bed, index),
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
  late Box<HarvestInvoice> _harvestInvoicesBox;
  List<HarvestInvoice> _filteredInvoices = [];

  // Add these if they're needed for invoice details (optional)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _harvestInvoicesBox = Hive.box<HarvestInvoice>('harvest_invoices');
    _filteredInvoices = _harvestInvoicesBox.values.toList();
    _searchController.addListener(_filterInvoices);
  }

  void _filterInvoices() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredInvoices = _harvestInvoicesBox.values
          .where((invoice) =>
              invoice.personName.toLowerCase().contains(query) ||
              invoice.reference.toLowerCase().contains(query))
          .toList();
    });
  }

  void _showInvoiceDetails(HarvestInvoice invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalles de factura de cosecha'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Referencia:', invoice.reference),
              _buildDetailRow('Nombre:', invoice.personName),
              _buildDetailRow('Fecha:', invoice.dateTime),
              _buildDetailRow(
                  'Plantas cosechadas:', invoice.plantsHarvested.toString()),
              _buildDetailRow('Precio por planta:',
                  '\$${invoice.pricePerPlant.toStringAsFixed(2)}'),
              _buildDetailRow('Valor total cosecha:',
                  '\$${invoice.totalHarvestValue.toStringAsFixed(2)}'),
              Divider(),
              Text('Costos:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...invoice.costs.map((cost) => _buildDetailRow(
                  '${cost.name} (x${cost.quantity}):',
                  '\$${cost.total.toStringAsFixed(2)}')),
              Divider(),
              _buildDetailRow('Costos Totales:',
                  '\$${invoice.totalCosts.toStringAsFixed(2)}'),
              _buildDetailRow('Valor Final:',
                  '\$${invoice.finalAmount.toStringAsFixed(2)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cerrar',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Historial"),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(110),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Buscar",
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
                TabBar(
                  tabs: [
                    Tab(text: "Facturas de cosecha"),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Harvest Invoices Tab
            ValueListenableBuilder(
              valueListenable: _harvestInvoicesBox.listenable(),
              builder: (context, Box<HarvestInvoice> box, _) {
                final invoices = _searchController.text.isEmpty
                    ? box.values.toList()
                    : _filteredInvoices;

                return invoices.isEmpty
                    ? Center(child: Text("No se encontraron facturas"))
                    : ListView.builder(
                        itemCount: invoices.length,
                        itemBuilder: (context, index) {
                          final invoice = invoices[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: ListTile(
                              title: Text(invoice.personName),
                              subtitle: Text(
                                  "${invoice.reference} | ${invoice.dateTime}"),
                              trailing: Text(
                                  "\$${invoice.finalAmount.toStringAsFixed(2)}"),
                              onTap: () => _showInvoiceDetails(invoice),
                            ),
                          );
                        },
                      );
              },
            ),
          ],
        ),
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
