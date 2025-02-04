import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_information_screen.dart';
import 'change_password.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _supabase = Supabase.instance.client;
  String? _username;
  String? _email;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      final userData =
          await _supabase.from('profiles').select().eq('id', user.id).single();

      setState(() {
        _username = userData['nombre usuario'] ?? 'Usuario';
        _email = user.email;
        _notificationsEnabled = userData['notifications_enabled'] ?? true;
      });
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      try {
        await _supabase.from('perfiles').update({
          'notifications_enabled': value,
        }).eq('id', user.id);

        setState(() {
          _notificationsEnabled = value;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification preferences updated'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating notification preferences: $error'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  Future<void> _signOut() async {
    // Guarda el contexto del diálogo
    final dialogContext = context;

    showDialog(
      context: dialogContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de querer cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Cierra el diálogo

                try {
                  await _supabase.auth.signOut();

                  // Asegúrate de que el widget sigue montado antes de navegar
                  if (dialogContext.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      dialogContext,
                      '/log_in',
                      (route) => false,
                    );
                  }
                } catch (error) {
                  if (dialogContext.mounted) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(
                        content: Text('Error cerrando sesión: $error'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              child: const Text('Cerrar sesión',
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            const SizedBox(height: 16),
            Text(
              _username ?? 'Loading...',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _email ?? 'Loading...',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Profile Information
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blueAccent),
              title: const Text('Información de perfil'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileInformationScreen(
                      username: _username ?? '',
                      email: _email ?? '',
                    ),
                  ),
                ).then((_) => _loadUserData());
              },
            ),

            // Change Password
            ListTile(
              leading: const Icon(Icons.security, color: Colors.blueAccent),
              title: const Text('Cambiar contraseña'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen(),
                  ),
                );
              },
            ),

            // Notifications Toggle
            ListTile(
              leading:
                  const Icon(Icons.notifications, color: Colors.blueAccent),
              title: const Text('Notificaciones'),
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: _toggleNotifications,
                activeColor: Colors.blueAccent,
              ),
            ),

            // Sign Out
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar sesión',
                  style: TextStyle(color: Colors.red)),
              onTap: _signOut,
            ),
          ],
        ),
      ),
    );
  }
}
