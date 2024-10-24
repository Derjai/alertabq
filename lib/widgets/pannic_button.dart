import 'package:flutter/material.dart';

class PannicButton extends StatelessWidget {
  final String text = 'Botón de emergencia';
  final VoidCallback onPressed;

  const PannicButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: text,
      child: const Icon(Icons.local_police),
    );
  }
}
