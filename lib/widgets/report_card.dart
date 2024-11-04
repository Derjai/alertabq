import 'package:alertabq/data/report_data.dart';
import 'package:flutter/material.dart';

class ReportCard extends StatefulWidget {
  final String location;
  final String dateTime;
  final String description;
  final String? attachment;
  final List<Event> events;
  final VoidCallback onConfirm;
  final VoidCallback onNegative;
  final String buttonAction;
  final String negativeButtonAction;
  const ReportCard(
      {super.key,
      required this.location,
      required this.dateTime,
      required this.description,
      this.attachment,
      required this.events,
      required this.onConfirm,
      required this.buttonAction,
      required this.negativeButtonAction,
      required this.onNegative});

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.attachment != null)
            Image.network(
              widget.attachment!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          Text(
            'Ubicación: ${widget.location}',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Fecha y Hora: ${widget.dateTime}',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Descripción: ${widget.description}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              TextButton(
                  onPressed: widget.onConfirm,
                  child: Text(widget.buttonAction)),
              TextButton(
                  onPressed: widget.onNegative,
                  child: Text(widget.negativeButtonAction)),
            ],
          ),
          const Divider(),
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Eventos',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Icon(_isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down),
              ],
            ),
          ),
          if (_isExpanded)
            Column(
              children: widget.events
                  .map((event) => EventCard(event: event))
                  .toList(),
            ),
        ],
      ),
    ));
  }
}

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[600],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.attachment != null)
              Image.network(
                event.attachment!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            Text('Ubicación: ${event.location}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Fecha y Hora: ${event.dateTime}'),
            Text('Descripción: ${event.description}'),
          ],
        ),
      ),
    );
  }
}
