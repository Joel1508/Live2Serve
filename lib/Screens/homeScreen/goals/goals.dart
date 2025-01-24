import 'package:app/Screens/homeScreen/customers/models/customer_model.dart';
import 'package:app/Screens/homeScreen/project/models/bed_model.dart';
import 'package:app/repositories/customer_repository.dart';
import 'package:flutter/material.dart';
import 'package:app/Screens/homeScreen/home_screen.dart' as home_screen;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
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
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF9FAFB),
      appBar: AppBar(
        title: Text('Goal Tracker'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => _navigateBack(context),
        ),
      ),
      body: Column(
        children: [
          _buildCalendarView(),
          _buildGoalsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEnhancedGoalModal(),
        label: Text('New Goal'),
        icon: Icon(Icons.add),
        backgroundColor: Color(0xFFFB5DAB9),
      ),
    );
  }

  Widget _buildCalendarView() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        // Check if the day has any goals
        final goalsOnDay = widget.goalsBox.values
            .where((goal) => isSameDay(DateTime.parse(goal.date), day))
            .toList();
        return isSameDay(_selectedDay, day) || goalsOnDay.isNotEmpty;
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Color(0xFFF5EBA7D),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Color(0xFFFCEDDCA),
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: Color(0xFFFB5DAB9),
          shape: BoxShape.circle,
        ),
      ),
      eventLoader: (day) {
        return widget.goalsBox.values
            .where((goal) => isSameDay(DateTime.parse(goal.date), day))
            .toList();
      },
    );
  }

  Widget _buildGoalsList() {
    final goals = widget.goalsBox.values
        .where((goal) => isSameDay(DateTime.parse(goal.date), _selectedDay))
        .toList();

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: goals.isEmpty
            ? Center(
                child: Text(
                  'No goals for this day',
                  style: TextStyle(color: Colors.white54),
                ),
              )
            : ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  return _buildGoalCard(goal);
                },
              ),
      ),
    );
  }

  Widget _buildGoalCard(Goal goal) {
    return Card(
      child: ListTile(
        title: Text(goal.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(goal.description),
            LinearProgressIndicator(
              value: goal.progressPercentage / 100,
            ),
            Text(
              '\$${goal.currentAmount.toStringAsFixed(2)} / \$${goal.targetAmount.toStringAsFixed(2)}',
            ),
            ElevatedButton(
              onPressed: () => _showUpdateGoalModal(goal),
              child: Text('Update Progress'),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateGoalModal(Goal goal) {
    double additionalAmount = 0.0;
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Update Goal Progress for ${goal.title}'),
            TextField(
              decoration: InputDecoration(
                labelText: 'Additional Amount',
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                additionalAmount = double.tryParse(value) ?? 0.0;
              },
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  goal.currentAmount += additionalAmount;
                  goal.save(); // Hive method to persist changes
                });
                Navigator.pop(context);
              },
              child: Text('Save Progress'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEnhancedGoalModal() {
    final formKey = GlobalKey<FormState>();
    String title = '', description = '';
    double targetAmount = 0.0;
    DateTime? selectedDate = _selectedDay ?? DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFFFF9FAFB),
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Color(0xFFFF9FAFB),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Goal Title',
                  labelStyle: TextStyle(color: Colors.black87),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                  ),
                ),
                style: TextStyle(color: Colors.black87),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
                onChanged: (value) => title = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.black87),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                  ),
                ),
                style: TextStyle(color: Colors.black87),
                onChanged: (value) => description = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Target Amount',
                  prefixText: '\$',
                  labelStyle: TextStyle(color: Colors.black87),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black87),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter a target amount';
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
                onChanged: (value) =>
                    targetAmount = double.tryParse(value) ?? 0.0,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Selected Date: ${DateFormat('MMM dd, yyyy').format(selectedDate)}',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFB5DAB9),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Goal newGoal = Goal(
                      title: title,
                      description: description,
                      date: selectedDate.toString().split(' ')[0],
                      targetAmount: targetAmount,
                      deadline: selectedDate,
                      currentAmount: 0.0,
                    );

                    widget.goalsBox.add(newGoal);
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Create Goal',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateBack(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => home_screen.HomeScreen(
          customerRepo: CustomerRepository(
            customerBox: Hive.box<CustomerModel>('customerBox'),
          ),
          projectBox: Hive.box<BedModel>('projectBox'),
        ),
      ),
    );
  }
}
