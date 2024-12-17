import 'package:app/Screens/homeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(GoalsApp());

class GoalsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GoalsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GoalsScreen extends StatefulWidget {
  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final int startYear = 2024;
  final int endYear = 2030;
  Map<String, Map<String, List<Map<String, String>>>> goalsData = {};

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load saved goals
      // Example JSON structure
      String? data = prefs.getString('goalsData');
      goalsData = data != null
          ? Map<String, Map<String, List<Map<String, String>>>>.from(
              Map.fromIterable(data as Iterable))
          : {};
    });
  }

  void _addGoal(String year, String month, Map<String, String> goal) async {
    setState(() {
      goalsData.putIfAbsent(year, () => {});
      goalsData[year]?.putIfAbsent(month, () => []);
      goalsData[year]?[month]?.add(goal);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('goalsData', goalsData.toString());
  }

  Widget _buildMonthWidget(String year, String month) {
    final goals = goalsData[year]?[month] ?? [];
    return GestureDetector(
      onTap: () {
        // Show goals or empty state
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

  Widget _buildGoalsModal(List<Map<String, String>> goals) {
    return Container(
      padding: EdgeInsets.all(16),
      child: goals.isNotEmpty
          ? ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                return ListTile(
                  title: Text(goal['title']!),
                  subtitle: Text(goal['description']!),
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
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: ListView.builder(
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
                final selectedYear = date.split('-')[0];
                final selectedMonth = date.split('-')[1].toUpperCase();
                _addGoal(selectedYear, selectedMonth, {
                  'title': title,
                  'description': description,
                  'date': date,
                });
                Navigator.pop(context);
              },
              child: Text('Save Goal'),
            ),
          ],
        ),
      ),
    );
  }
}
