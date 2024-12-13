import 'package:app/Screens/homeScreen/accounting/accounting.dart';
import 'package:app/Screens/homeScreen/partners/partners.dart';
import 'package:app/Screens/homeScreen/customers/customers.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDEDCDD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: const Text(
            'JA', // Placeholder initials
            style: TextStyle(color: Colors.black),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // TODO: Navigate to settings screen
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                _buildPlaceholderCard('Accounts Graph Placeholder'),
                _buildPlaceholderCard('Card Details Placeholder'),
                _buildPlaceholderCard('Stock Metrics Placeholder'),
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
                  _buildGridButton(context, 'Customers', '/customers'),
                  _buildGridButton(context, 'Partners', '/partners'),
                  _buildGridButton(context, 'Project', '/project'),
                  _buildGridButton(context, 'Accounting', '/accounting'),
                  _buildGridButton(context, 'Bill history', '/bill_history'),
                  _buildGridButton(context, 'Goals', '/goals'),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
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

  Widget _buildGridButton(BuildContext context, String label, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
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
      ),
    );
  }

  Widget _buildPlaceholderCard(String text) {
    return Container(
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
        child: Text(text),
      ),
    );
  }
}
/*
// Placeholder screens
class CustomersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customers')),
      body: Center(child: Text('Customers Screen')),
    );
  }
}

class PartnersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Partners')),
      body: Center(child: Text('Partners Screen')),
    );
  }
}
*/
// Similarly, create other screens for Project, Accounting, Bill History, and Goals.

// Main Function to Set Up Routes
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => HomeScreen(),
      '/partners': (context) => PartnersScreen(),
      '/customers': (context) => CustomersScreen(),
      '/accounting': (context) => AccountingScreen(),
    },
  ));
}
