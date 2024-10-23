import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const CustomNavigationBar(
      {super.key,
      required this.selectedIndex,
      required this.onDestinationSelected});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Inicio'),
        NavigationDestination(icon: Icon(Icons.history), label: 'Mis reportes'),
        NavigationDestination(
            icon: Icon(Icons.verified), label: 'Verificar reportes'),
      ],
    );
  }
}
