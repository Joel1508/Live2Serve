import 'package:app/Screens/homeScreen/harvest_invoice_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class HarvestInvoiceScreen extends StatefulWidget {
  final Function(HarvestInvoice) onInvoiceSaved;
  final Box<HarvestCost> costsBox;

  HarvestInvoiceScreen({
    required this.onInvoiceSaved,
    required this.costsBox,
  });

  @override
  _HarvestInvoiceScreenState createState() => _HarvestInvoiceScreenState();
}

class _HarvestInvoiceScreenState extends State<HarvestInvoiceScreen> {
  final _personNameController = TextEditingController();
  final _plantsController = TextEditingController();
  final _priceController = TextEditingController();
  final List<HarvestCost> _selectedCosts = [];
  bool showPreview = false;
  late HarvestInvoice _currentInvoice;

  void _addNewCost() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final quantityController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Cost'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Cost Name'),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedCosts.add(HarvestCost(
                  name: nameController.text,
                  amount: double.parse(amountController.text),
                  quantity: int.parse(quantityController.text),
                ));
              });
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _selectExistingCost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Existing Cost'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.costsBox.length,
            itemBuilder: (context, index) {
              final cost = widget.costsBox.getAt(index);
              if (cost == null) {
                return SizedBox.shrink();
              }
              return ListTile(
                title: Text(cost.name),
                subtitle:
                    Text('\$${cost.amount?.toStringAsFixed(2) ?? '0.00'}'),
                onTap: () {
                  final quantityController = TextEditingController(text: '1');
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Enter Quantity'),
                      content: TextField(
                        controller: quantityController,
                        decoration: InputDecoration(labelText: 'Quantity'),
                        keyboardType: TextInputType.number,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedCosts.add(HarvestCost(
                                name: cost.name,
                                amount: cost.amount,
                                quantity: int.parse(quantityController.text),
                              ));
                            });
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text('Add'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _generateInvoice() {
    final now = DateTime.now();
    final totalHarvestValue =
        int.parse(_plantsController.text) * double.parse(_priceController.text);
    final totalCosts =
        _selectedCosts.fold(0.0, (sum, cost) => sum + cost.total);

    _currentInvoice = HarvestInvoice(
      reference: 'HARV-${now.millisecondsSinceEpoch}',
      personName: _personNameController.text,
      plantsHarvested: int.parse(_plantsController.text),
      pricePerPlant: double.parse(_priceController.text),
      costs: _selectedCosts,
      dateTime: DateFormat('yyyy-MM-dd HH:mm').format(now),
      totalHarvestValue: totalHarvestValue,
      totalCosts: totalCosts,
      finalAmount: totalHarvestValue - totalCosts,
    );

    setState(() {
      showPreview = true;
    });
  }

  Widget _buildPreview() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Harvest Invoice Preview'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              widget.onInvoiceSaved(_currentInvoice);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Harvest invoice saved successfully!')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              setState(() {
                showPreview = false;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Harvest Invoice',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Divider(),
                _buildPreviewRow('Reference:', _currentInvoice.reference),
                _buildPreviewRow('Person:', _currentInvoice.personName),
                _buildPreviewRow('Date:', _currentInvoice.dateTime),
                Divider(),
                _buildPreviewRow('Plants Harvested:',
                    _currentInvoice.plantsHarvested.toString()),
                _buildPreviewRow(
                    'Price per Plant:', '\$${_currentInvoice.pricePerPlant}'),
                _buildPreviewRow('Total Harvest Value:',
                    '\$${_currentInvoice.totalHarvestValue}'),
                Divider(),
                Text('Costs:', style: Theme.of(context).textTheme.titleMedium),
                ..._currentInvoice.costs.map((cost) => _buildPreviewRow(
                    '${cost.name} (x${cost.quantity}):', '\$${cost.total}')),
                Divider(),
                _buildPreviewRow(
                    'Total Costs:', '\$${_currentInvoice.totalCosts}'),
                _buildPreviewRow(
                    'Final Amount:', '\$${_currentInvoice.finalAmount}'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 6,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Harvest Invoice'),
      ),
      body: showPreview
          ? _buildPreview()
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _personNameController,
                    decoration: InputDecoration(labelText: 'Person Name'),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _plantsController,
                    decoration: InputDecoration(labelText: 'Number of Plants'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Price per Plant'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _selectExistingCost,
                        icon: Icon(Icons.add_circle),
                        label: Text('Select Existing Cost'),
                      ),
                      ElevatedButton.icon(
                        onPressed: _addNewCost,
                        icon: Icon(Icons.add),
                        label: Text('Add New Cost'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text('Selected Costs:',
                      style: Theme.of(context).textTheme.titleMedium),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _selectedCosts.length,
                    itemBuilder: (context, index) {
                      final cost = _selectedCosts[index];
                      return ListTile(
                        title: Text(cost.name),
                        subtitle: Text(
                            'Amount: \$${cost.amount} x ${cost.quantity} = \$${cost.total}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _selectedCosts.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: _generateInvoice,
                      child: Text('Preview Invoice'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
