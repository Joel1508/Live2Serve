import 'package:app/Screens/homeScreen/project/bed_model.dart';
import 'package:app/repositories/customer_repository.dart';
import 'package:flutter/material.dart';
import 'package:app/Screens/homeScreen/home_screen.dart' as home_screen;
import 'package:hive_flutter/hive_flutter.dart';
import 'goal.dart';

class GoalsApp extends StatelessWidget {
  final Box<Goal> goalsBox;
  final CustomerRepository customerRepo;

  const GoalsApp({Key? key, required this.goalsBox, required this.customerRepo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GoalsScreen(goalsBox: goalsBox, customerRepo: customerRepo),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GoalsScreen extends StatefulWidget {
  final Box<Goal> goalsBox;

  const GoalsScreen({
    Key? key,
    required this.goalsBox,
    required CustomerRepository customerRepo,
  }) : super(key: key);

  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final int startYear = 2024;
  final int endYear = 2030;

  void _addGoal(String year, String month, Goal goal) {
    widget.goalsBox.add(goal);
  }

  Widget _buildMonthWidget(String year, String month) {
    final goals = widget.goalsBox.values
        .where((goal) => goal.date.startsWith('$year-$month'))
        .toList();

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => _buildGoalsModal(goals),
        );
      },
      child: Column(
        children: [
          Text(
            month,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          Text(
            goals.isNotEmpty ? "${goals.length} goals" : "Empty",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsModal(List<Goal> goals) {
    return Container(
      padding: EdgeInsets.all(16),
      child: goals.isNotEmpty
          ? ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                return Card(
                  child: ListTile(
                    title: Text(goal.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (goal.description.isNotEmpty) Text(goal.description),
                        SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: goal.progressPercentage / 100,
                          backgroundColor: Colors.grey[200],
                        ),
                        SizedBox(height: 4),
                        Text(
                          '\$${goal.currentAmount.toStringAsFixed(2)} / \$${goal.targetAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color:
                                goal.isOverdue ? Colors.red : Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Deadline: ${goal.formattedDate}',
                          style: TextStyle(
                            color:
                                goal.isOverdue ? Colors.red : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text("No goals for this month."),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Goals & Reminders"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => home_screen.HomeScreen(
                  customerRepo: CustomerRepository(
                    customerBox: Hive.box<Customer>('customerBox'),
                  ),
                  projectBox: Hive.box<BedModel>('projectBox'),
                ),
              ),
            );
          },
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: widget.goalsBox.listenable(),
        builder: (context, Box<Goal> box, _) {
          return ListView.builder(
            itemCount: endYear - startYear + 1,
            itemBuilder: (context, index) {
              String year = (startYear + index).toString();
              return Column(
                children: [
                  Text(
                    year,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      for (String month in [
                        "JAN",
                        "FEB",
                        "MAR",
                        "APR",
                        "MAY",
                        "JUN",
                        "JUL",
                        "AGO",
                        "SEP",
                        "OCT",
                        "NOV",
                        "DEC"
                      ])
                        _buildMonthWidget(year, month)
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddGoalForm();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddGoalForm() {
    String title = '', description = '', date = '';
    double targetAmount = 0.0;
    DateTime? deadline;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the modal expandable
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onChanged: (value) => title = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) => description = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Target Amount',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a target amount';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    targetAmount = double.tryParse(value) ?? 0.0;
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date (YYYY-MM-DD)',
                  hintText: '2024-01-31',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  try {
                    deadline = DateTime.parse(value);
                    if (deadline!.isBefore(DateTime.now())) {
                      return 'Date cannot be in the past';
                    }
                    date = value;
                    return null;
                  } catch (e) {
                    return 'Please enter a valid date in YYYY-MM-DD format';
                  }
                },
                onChanged: (value) => date = value,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final selectedYear = date.split('-')[0];
                    final selectedMonth = date.split('-')[1].toUpperCase();

                    Goal newGoal = Goal(
                      title: title,
                      description: description,
                      date: date,
                      targetAmount: targetAmount,
                      deadline: deadline!,
                      currentAmount: 0.0, // Starting with zero progress
                    );

                    _addGoal(selectedYear, selectedMonth, newGoal);
                    Navigator.pop(context);
                  }
                },
                child: Text('Save Goal'),
              ),
              SizedBox(height: 16), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
