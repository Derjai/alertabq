import 'package:flutter/material.dart';

class ReportButton extends StatelessWidget {
  final String text = 'Reportar incidente';
  final VoidCallback onPressed;
  const ReportButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'report_button',
      key: const Key('report_button'),
      onPressed: onPressed,
      tooltip: text,
      child: const Icon(Icons.assignment_add),
    );
  }
}
