import 'package:alertabq/auth/auth_service.dart';
import 'package:alertabq/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = AuthService();
  int drawerIndex = 1;
  Future<void> _onItemTapped(int index) async {
    setState(() {
      drawerIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/Home');
        break;
      case 1:
        break;
      case 2:
        await _auth.signOut();
        if (mounted) {
          Navigator.popUntil(context, ModalRoute.withName('/'));
        }
        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final pic = user?.email?.substring(0, 1).toUpperCase();
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color textColor =
        isDarkMode ? const Color(0xFFF8F9FA) : const Color(0xFF2D3748);
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Configurar cuenta', style: TextStyle(fontSize: 20.0)),
      ),
      drawer: CustomDrawer(
          isDarkMode: isDarkMode,
          textColor: textColor,
          selectedIndex: drawerIndex,
          onItemTapped: _onItemTapped),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    child: Text(pic!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Correo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child:
                  Text(user?.email ?? '', style: const TextStyle(fontSize: 16)),
            ),
            TextButton(
              onPressed: () async {
                await _auth.forgotPassword(user?.email ?? '');
              },
              child: const Text('Cambiar contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}
