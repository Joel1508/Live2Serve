import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'models/partner_model.dart';
import 'models/harvest_record_model.dart';
import 'package:FRES.CO/Screens/homeScreen/invoice/models/cost_model.dart';

class HarvestInvoiceScreen extends StatefulWidget {
  @override
  _HarvestInvoiceScreenState createState() => _HarvestInvoiceScreenState();
}

class _HarvestInvoiceScreenState extends State<HarvestInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  late Box<Partner> _partnersBox;
  late Box<CostTemplate> _templatesBox;
  late Box<HarvestRecord> _harvestsBox;

  final _plantsController = TextEditingController();
  final _pricePerPlantController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  Partner? _selectedPartner;
  CostTemplate? _selectedTemplate;
  List<ProductionCost> _additionalCosts = [];

  @override
  void initState() {
    super.initState();
    _partnersBox = Hive.box<Partner>('partners');
    _templatesBox = Hive.box<CostTemplate>('costTemplates');
    _harvestsBox = Hive.box<HarvestRecord>('harvests');
    _pricePerPlantController.text = '2000'; // Default price
  }

  /*
  double get _totalRevenue {
    if (_plantsController.text.isEmpty) return 0;
    return int.parse(_plantsController.text) *
        double.parse(_pricePerPlantController.text);
  }
  */

  double get _totalCosts {
    double templateCosts = _selectedTemplate?.totalCost ?? 0;
    double additionalCosts =
        _additionalCosts.fold(0, (sum, cost) => sum + cost.totalCost);
    return templateCosts + additionalCosts;
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _showAddPartnerDialog() {
    final nameController = TextEditingController();
    final idController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Partner'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name *'),
              ),
              TextField(
                controller: idController,
                decoration: InputDecoration(labelText: 'NIT/CC'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final partner = Partner(
                  name: nameController.text,
                  identification: idController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  createdAt: DateTime.now(),
                );
                _partnersBox.add(partner);
                setState(() => _selectedPartner = partner);
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _saveHarvestRecord() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPartner == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a partner')),
      );
      return;
    }

    final harvest = HarvestRecord(
      harvestDate: _selectedDate,
      plantsHarvested: int.parse(_plantsController.text),
      partnerId: _selectedPartner!.key.toString(),
      costTemplateId: _selectedTemplate?.key.toString(),
      pricePerPlant: double.parse(_pricePerPlantController.text),
      notes: _notesController.text,
    );

    await _harvestsBox.add(harvest);
    _showInvoicePreview(harvest);
  }

  void _showInvoicePreview(HarvestRecord harvest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Harvest Invoice'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInvoiceHeader(),
              Divider(),
              _buildInvoiceDetails(harvest),
              Divider(),
              _buildCostSummary(harvest),
              Divider(),
              _buildTotalSection(harvest),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement share functionality
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Share'),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FRES.CO',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Harvest Invoice',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Invoice #: ${DateTime.now().millisecondsSinceEpoch}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInvoiceDetails(HarvestRecord harvest) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Partner: ${_selectedPartner?.name}',
          style: TextStyle(fontSize: 16),
        ),
        if (_selectedPartner?.identification != null)
          Text(
            'NIT/CC: ${_selectedPartner?.identification}',
            style: TextStyle(fontSize: 16),
          ),
        SizedBox(height: 8),
        Text(
          'Plants Harvested: ${harvest.plantsHarvested}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Price per Plant: \$${harvest.pricePerPlant}',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildCostSummary(HarvestRecord harvest) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Harvest Summary:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Plants Harvested:'),
            Text('${harvest.plantsHarvested}'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Price per Plant:'),
            Text('\$${harvest.pricePerPlant}'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Revenue:'),
            Text('\$${harvest.totalRevenue}'),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalSection(HarvestRecord harvest) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Revenue:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '\$${harvest.totalRevenue}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Costs:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '\$${_totalCosts}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Net Profit:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              '\$${harvest.totalRevenue - _totalCosts}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: harvest.totalRevenue - _totalCosts >= 0
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Harvest Record'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Selection
              ListTile(
                title: Text('Harvest Date'),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                trailing: Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),
              Divider(),

              // Partner Selection
              ValueListenableBuilder(
                valueListenable: _partnersBox.listenable(),
                builder: (context, Box<Partner> box, _) {
                  final partners = box.values.toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select Partner', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<Partner>(
                              value: _selectedPartner,
                              items: partners.map((partner) {
                                return DropdownMenuItem(
                                  value: partner,
                                  child: Text(partner.name),
                                );
                              }).toList(),
                              onChanged: (Partner? value) {
                                setState(() => _selectedPartner = value);
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: _showAddPartnerDialog,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16),

              // Harvest Details
              TextFormField(
                controller: _plantsController,
                decoration: InputDecoration(
                  labelText: 'Number of Plants Harvested',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter number of plants';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _pricePerPlantController,
                decoration: InputDecoration(
                  labelText: 'Price per Plant',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter price per plant';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Cost Template Selection
              ValueListenableBuilder(
                valueListenable: _templatesBox.listenable(),
                builder: (context, Box<CostTemplate> box, _) {
                  final templates = box.values.toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select Cost Template',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      DropdownButtonFormField<CostTemplate>(
                        value: _selectedTemplate,
                        items: templates.map((template) {
                          return DropdownMenuItem(
                            value: template,
                            child: Text(template.name),
                          );
                        }).toList(),
                        onChanged: (CostTemplate? value) {
                          setState(() => _selectedTemplate = value);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 24),

              // Save Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: _saveHarvestRecord,
                  icon: Icon(Icons.save),
                  label: Text('Generate Invoice'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _plantsController.dispose();
    _pricePerPlantController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
