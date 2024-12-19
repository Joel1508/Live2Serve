/* -------loginScreen------
import 'package:app/supabase/auth_service.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService authService = AuthService();
  final LocalAuthentication auth =
      LocalAuthentication(); // Local authentication instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EC9B2),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Circular Background
                    Container(
                      width: 300,
                      height: 300,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8ABC8B),
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Text Inside the Circle
                    const SizedBox(
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "FRES.CO",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFAFAD8),
                            ),
                          ),
                          SizedBox(height: 25),
                          Text(
                            "Log In",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF17372A),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "To Continue",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFAFAD8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Glassy Effect Container for Entire Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        // Email Field
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Password Field
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Log In Button
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await authService.logIn(
                                emailController.text,
                                passwordController.text,
                              );
                              Navigator.pushNamed(
                                context,
                                '/home_screen',
                              );
                            } catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $error')),
                              );
                            }
                          },
                          child: const Text('Log in'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF8ABC8B),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // "Create an Account" and "Forgot Password?"
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/sign_up'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    Navigator.pushNamed(context, '/sign_up'),
                                child: const Text(
                                  'Create an account',
                                  style: TextStyle(
                                    color: Color(0xFFF17372A),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 50),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/recover_password');
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Color(0xFFF17372A),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: 300,
                height: 150,
                child: Image.asset(
                  'assets/tubo.png',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

/* ------- home screen ------
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3EAF5), // Background color similar to the design
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Text(
            'JA', // Placeholder initials
            style: TextStyle(color: Colors.black),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Home',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // TODO: Navigate to settings screen
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Key metrics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 200,
            child: PageView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text('Accounts Graph Placeholder'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text('Card Details Placeholder'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text('Stock Metrics Placeholder'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildGridButton('Customers'),
                  _buildGridButton('Partners'),
                  _buildGridButton('Project'),
                  _buildGridButton('Accounting'),
                  _buildGridButton('Bill history'),
                  _buildGridButton('Goals'),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: 0, // Home is active
        onTap: (index) {
          // TODO: Handle navigation between tabs
        },
      ),
    );
  }

  Widget _buildGridButton(String label) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

*/
 /* ------ partner screen
 import 'package:flutter/material.dart';

class PartnersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDEDCD), // Background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Partners',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red, width: 2), // Debug border
                image: DecorationImage(
                  image: AssetImage('assets/add-user.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.black),
            onPressed: () {
              // Navigate to AddUserScreen
            },
          ),
        ],
      ),
      body: Center(
        child: Text("Main Content Here"),
      ),
    );
  }
}

 
 */

/* ------- partners screen official -----------
import 'package:app/Screens/partners/add_user.dart';
import 'package:flutter/material.dart';

class PartnersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDEDCD),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Section: Back button, title, and add partner icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  'Partners',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.person_add, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddUserScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount: 0,
                  itemBuilder: (context, index) {
                    return _buildPartnerRow('Partner Name $index');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerRow(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: Row(
          children: [
            const Icon(Icons.person, color: Colors.grey, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Icon(Icons.more_vert, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}


*/

/*
import 'package:flutter/material.dart';
import 'date.dart'; // Import the date picker file

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isIncome = true; // Toggle between Income and Expense
  TextEditingController amountController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  String selectedCategory = "Select Category"; // Default category placeholder
  List<String> categories = []; // Dynamic list based on income/expense type
  DateTime? selectedDate; // Store the selected date
  String paymentMethod = "Digital"; // Default payment method

  @override
  void initState() {
    super.initState();
    categories = [
      "Sales",
      "Commissions",
      "Investments",
      "Freelance / Side Hustles",
      "Salaries and bonuses"
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDEDCD),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Color(0xFFFCFCFC), Color(0xFFFDEDCD)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context); // Navigate back
                    },
                  ),
                  Text(
                    "Add Transaction",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.note_add),
                    onPressed: () {
                      // Action for document icon
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Transaction Type Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isIncome = true; // Toggle to Income
                        categories = [
                          "Sales",
                          "Commissions",
                          "Investments",
                          "Freelance / Side Hustles",
                          "Salaries and bonuses"
                        ];
                        selectedCategory = "Select Category"; // Reset dropdown
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            isIncome ? Color(0xFF8ABC8B) : Color(0xFFEDDCA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "INCOME",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isIncome ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isIncome = false; // Toggle to Expense
                        categories = [
                          "Personal Expenses",
                          "Business Expenses",
                          "Transportation",
                          "Healthcare",
                          "Entertainment"
                        ];
                        selectedCategory = "Select Category"; // Reset dropdown
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            !isIncome ? Color(0xFFFF9444) : Color(0xFFFCAD0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "EXPENSE",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: !isIncome ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Amount Input
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isIncome ? Colors.green : Colors.red,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "+ \$0.00",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

 */

/* ------ goals Screeen -------

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


*/