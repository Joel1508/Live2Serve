import 'package:app/repositories/customer_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
                return ListTile(
                  title: Text(goal.title),
                  subtitle: Text(goal.description),
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
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => title = value,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              onChanged: (value) => description = value,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              onChanged: (value) => date = value,
              decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
            ),
            ElevatedButton(
              onPressed: () {
                if (title.isNotEmpty && date.isNotEmpty) {
                  final selectedYear = date.split('-')[0];
                  final selectedMonth = date.split('-')[1].toUpperCase();
                  Goal newGoal = Goal(
                    title: title,
                    description: description,
                    date: date,
                  );
                  _addGoal(selectedYear, selectedMonth, newGoal);
                  Navigator.pop(context);
                }
              },
              child: Text('Save Goal'),
            ),
          ],
        ),
      ),
    );
  }
}
