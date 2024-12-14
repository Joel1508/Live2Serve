import 'package:flutter/material.dart';

class GoalsScreen extends StatefulWidget {
  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final List<Map<String, dynamic>> _goals = [];
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _addGoal() {
    final goal = _goalController.text;
    final amount = double.tryParse(_amountController.text);

    if (goal.isNotEmpty && amount != null && _selectedDate != null) {
      setState(() {
        _goals.add({
          'goal': goal,
          'amount': amount,
          'date': _selectedDate,
          'progress': 0.0,
        });
        _goalController.clear();
        _amountController.clear();
        _selectedDate = null;
      });
    }
  }

  void _updateProgress(int index, double progressAmount) {
    setState(() {
      final goal = _goals[index];
      final newProgress =
          (goal['progress'] * goal['amount'] + progressAmount) / goal['amount'];
      _goals[index]['progress'] = newProgress.clamp(0.0, 1.0);
    });
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
      appBar: AppBar(
        title: Text("Goals"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _goalController,
              decoration: InputDecoration(labelText: "Goal Description"),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Target Amount (\$)"),
            ),
            Row(
              children: [
                Text(_selectedDate == null
                    ? "Select Deadline"
                    : "Deadline: ${_selectedDate!.toLocal().toString().split(' ')[0]}"),
                TextButton(
                  onPressed: _pickDate,
                  child: Text("Pick Date"),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _addGoal,
              child: Text("Add Goal"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _goals.length,
                itemBuilder: (context, index) {
                  final goal = _goals[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal['goal'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                              "Target Amount: \$${goal['amount'].toStringAsFixed(2)}"),
                          Text(
                              "Deadline: ${goal['date'].toLocal().toString().split(' ')[0]}"),
                          SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: goal['progress'],
                            color: Colors.green,
                            backgroundColor: Colors.grey[300],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "Progress: ${(goal['progress'] * 100).toStringAsFixed(0)}%"),
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      final TextEditingController
                                          progressController =
                                          TextEditingController();
                                      return AlertDialog(
                                        title: Text("Update Progress"),
                                        content: TextField(
                                          controller: progressController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              labelText:
                                                  "Progress Amount (\$)"),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              final progressAmount =
                                                  double.tryParse(
                                                      progressController.text);
                                              if (progressAmount != null &&
                                                  progressAmount >= 0) {
                                                _updateProgress(
                                                    index, progressAmount);
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Update"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text("Edit Progress"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
