import 'package:app/Screens/homeScreen/accounting/others/accounting_goal.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AccountingGoalsScreen extends StatefulWidget {
  final Box<AccountingGoal> goalsBox;

  const AccountingGoalsScreen({Key? key, required this.goalsBox})
      : super(key: key);

  @override
  _AccountingGoalsScreenState createState() => _AccountingGoalsScreenState();
}

class _AccountingGoalsScreenState extends State<AccountingGoalsScreen> {
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _addGoal() {
    final title = _goalController.text;
    final amount = double.tryParse(_amountController.text);

    if (title.isNotEmpty && amount != null && _selectedDate != null) {
      final newGoal = AccountingGoal(
        title: title,
        amount: amount,
        date: _selectedDate!,
        progress: 0.0,
      );

      widget.goalsBox.add(newGoal); // Add to Hive Box

      setState(() {
        _goalController.clear();
        _amountController.clear();
        _selectedDate = null;
      });
    }
  }

  void _updateProgress(int index, double progressAmount) {
    final goal = widget.goalsBox.getAt(index);

    if (goal != null) {
      final updatedGoal = AccountingGoal(
        title: goal.title,
        amount: goal.amount,
        date: goal.date,
        progress: (goal.progress * goal.amount + progressAmount) / goal.amount,
      );

      widget.goalsBox.putAt(index, updatedGoal); // Update in Hive Box

      setState(() {});
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Accounting Goals')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _goalController,
              decoration: InputDecoration(labelText: 'Goal Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _pickDate,
              child: Text(
                _selectedDate == null
                    ? 'Select Date'
                    : 'Selected: ${_selectedDate!.toLocal()}'.split(' ')[0],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addGoal,
            child: Text('Add Goal'),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: widget.goalsBox.listenable(),
              builder: (context, Box<AccountingGoal> box, _) {
                if (box.isEmpty) {
                  return Center(child: Text('No goals yet.'));
                }

                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final goal = box.getAt(index);
                    return ListTile(
                      title: Text(goal!.title),
                      subtitle: Text(
                          'Amount: \$${goal.amount}, Progress: ${(goal.progress * 100).toStringAsFixed(1)}%'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _updateProgress(index, 10.0),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
