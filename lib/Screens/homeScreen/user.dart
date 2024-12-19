import 'package:app/Screens/homeScreen/settings.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            const SizedBox(height: 16),

            // User Name
            const Text(
              'John Doe',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // User Email
            const Text(
              'john.doe@example.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Buttons for User Actions
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blueAccent),
              title: Text('Edit Profile'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Add Edit Profile functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.security, color: Colors.blueAccent),
              title: Text('Change Password'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Add Change Password functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.blueAccent),
              title: Text('Settings'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Settings Screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
