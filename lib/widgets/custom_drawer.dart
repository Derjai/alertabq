import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final bool isDarkMode;
  final Color textColor;
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  const CustomDrawer(
      {super.key,
      required this.isDarkMode,
      required this.textColor,
      required this.selectedIndex,
      required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Usuario',
                style: TextStyle(fontSize: 20.0, color: textColor)),
            accountEmail: Text('usuario@ejemplo.com',
                style: TextStyle(fontSize: 20.0, color: textColor)),
            currentAccountPicture: const CircleAvatar(
              child: Text(
                'U',
                style: TextStyle(fontSize: 40.0),
              ),
            ),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : Colors.blue,
            ),
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
