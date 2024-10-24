import 'package:flutter/material.dart';

class ReportButton extends StatelessWidget {
  final String text = 'Reportar incidente';
  final VoidCallback onPressed;
  const ReportButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: text,
      child: const Icon(Icons.assignment_add),
    );
  }
}
