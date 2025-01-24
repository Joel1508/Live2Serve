import 'package:app/Screens/homeScreen/project/models/cost_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class CostsScreen extends StatefulWidget {
  final Box<CostModel> costsBox;

  const CostsScreen({
    Key? key,
    required this.costsBox,
  }) : super(key: key);

  @override
  _CostsScreenState createState() => _CostsScreenState();
}

class _CostsScreenState extends State<CostsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  late Box<CostModel> _costsBox;
  var uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _costsBox = widget.costsBox;
  }

  void _showAddCostDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Cost'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Cost Name'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Unit Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value!) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
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
            onPressed: _saveCost,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _saveCost() {
    if (_formKey.currentState?.validate() ?? false) {
      final cost = CostModel(
        id: uuid.v4(),
        name: _nameController.text,
        unitPrice: double.parse(_priceController.text),
      );
      _costsBox.add(cost);
      _nameController.clear();
      _priceController.clear();
      Navigator.pop(context);
    }
  }

  void _showEditDialog(CostModel cost) {
    _nameController.text = cost.name;
    _priceController.text = cost.unitPrice.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Cost'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Cost Name'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Unit Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value!) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
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
              if (_formKey.currentState?.validate() ?? false) {
                final updatedCost = cost.copyWith(
                  name: _nameController.text,
                  unitPrice: double.parse(_priceController.text),
                );
                _costsBox.put(cost.key, updatedCost);
                _nameController.clear();
                _priceController.clear();
                Navigator.pop(context);
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Costs'),
        backgroundColor: Color(0xFFFF9FAFB),
      ),
      body: ValueListenableBuilder(
        valueListenable: _costsBox.listenable(),
        builder: (context, Box<CostModel> box, _) {
          final costs = box.values.toList();

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFF9FAFB),
                  Color(0xFFFDEDCDD),
                ],
              ),
            ),
            child: costs.isEmpty
                ? Center(child: Text('No costs added yet'))
                : ListView.builder(
                    itemCount: costs.length,
                    itemBuilder: (context, index) {
                      final cost = costs[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(cost.name),
                          subtitle: Text('Unit Price: \$${cost.unitPrice}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _showEditDialog(cost),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Delete Cost'),
                                      content: Text(
                                          'Are you sure you want to delete this cost?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            box.delete(cost.key);
                                            Navigator.pop(context);
                                          },
                                          child: Text('Delete'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFFFF69697),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCostDialog,
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFFB5DAB9),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
