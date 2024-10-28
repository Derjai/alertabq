import 'package:alertabq/auth/auth_service.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String email = getEmail()!;
  final bool isDarkMode;
  final Color textColor;
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  CustomDrawer({
    super.key,
    required this.isDarkMode,
    required this.textColor,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final String pic = email.substring(0, 1).toUpperCase();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail:
                Text(email, style: TextStyle(fontSize: 20.0, color: textColor)),
            currentAccountPicture: CircleAvatar(
              child: Text(
                pic,
                style: const TextStyle(fontSize: 40.0),
              ),
            ),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : Colors.blue,
            ),
            accountName: null,
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            selected: selectedIndex == 0,
            onTap: () => onItemTapped(0),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurar cuenta'),
            selected: selectedIndex == 1,
            onTap: () => onItemTapped(1),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            selected: selectedIndex == 2,
            onTap: () => onItemTapped(2),
          ),
        ],
      ),
    );
  }
}

String? getEmail() {
  return AuthService().currentUser?.email;
}
