import 'package:app/Screens/homeScreen/invoice/models/cost_model.dart';
import 'package:flutter/material.dart';

class CostManagementScreen extends StatefulWidget {
  @override
  _CostManagementScreenState createState() => _CostManagementScreenState();
}

class _CostManagementScreenState extends State<CostManagementScreen> {
  final _formKey = GlobalKey<FormState>();

  final _costNameController = TextEditingController();
  final _costPerUnitController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitTypeController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<ProductionCost> _currentCosts = [];

  @override
  void initState() {
    super.initState();
  }

  void _addNewCost() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _currentCosts.add(
        ProductionCost(
          name: _costNameController.text,
          costPerUnit: double.parse(_costPerUnitController.text),
          quantity: int.parse(_quantityController.text),
          unitType: _unitTypeController.text,
          description: _descriptionController.text,
        ),
      );

      // Clear the form
      _costNameController.clear();
      _costPerUnitController.clear();
      _quantityController.clear();
      _unitTypeController.clear();
      _descriptionController.clear();
    });
  }

  void _editCost(int index) {
    final cost = _currentCosts[index];

    _costNameController.text = cost.name;
    _costPerUnitController.text = cost.costPerUnit.toString();
    _quantityController.text = cost.quantity.toString();
    _unitTypeController.text = cost.unitType ?? '';
    _descriptionController.text = cost.description ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Cost',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            _buildCostForm(),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _currentCosts[index] = ProductionCost(
                      name: _costNameController.text,
                      costPerUnit: double.parse(_costPerUnitController.text),
                      quantity: int.parse(_quantityController.text),
                      unitType: _unitTypeController.text,
                      description: _descriptionController.text,
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Update Cost'),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCostForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _costNameController,
            decoration: InputDecoration(
              labelText: 'Cost Name *',
              hintText: 'e.g., Seedlings, Nutrients, Labor',
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter a cost name';
              }
              return null;
            },
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _costPerUnitController,
                  decoration: InputDecoration(
                    labelText: 'Cost per Unit *',
                    prefixText: '\$',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Required';
                    }
                    if (double.tryParse(value!) == null) {
                      return 'Invalid number';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _unitTypeController,
                  decoration: InputDecoration(
                    labelText: 'Unit Type',
                    hintText: 'e.g., per bag, each',
                  ),
                ),
              ),
            ],
          ),
          TextFormField(
            controller: _quantityController,
            decoration: InputDecoration(
              labelText: 'Quantity *',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Required';
              }
              if (int.tryParse(value!) == null) {
                return 'Invalid number';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description (Optional)',
              hintText: 'Add any additional notes',
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Production Costs'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _currentCosts.length,
              itemBuilder: (context, index) {
                final cost = _currentCosts[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(cost.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${cost.costPerUnit} ${cost.unitType ?? 'per unit'} × ${cost.quantity}',
                        ),
                        if (cost.description?.isNotEmpty ?? false)
                          Text(
                            cost.description!,
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                      ],
                    ),
                    trailing: Text(
                      '\$${cost.totalCost.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () => _editCost(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: _buildCostForm(),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _addNewCost,
                    icon: Icon(Icons.add),
                    label: Text('Add Cost'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _costNameController.dispose();
    _costPerUnitController.dispose();
    _quantityController.dispose();
    _unitTypeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
