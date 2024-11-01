import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Report {
  final String email;
  final String description;
  final String location;
  final DateTime dateTime;
  final String? attachment;
  final List<Event>? events;
  final mongo.ObjectId? id;
  final bool? confirmed;
  final bool? priority;

  Report({
    required this.email,
    required this.description,
    required this.location,
    required this.dateTime,
    this.events,
    this.attachment,
    this.id,
    this.confirmed,
    this.priority,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'email': email,
      'description': description,
      'location': location,
      'dateTime': dateTime.toIso8601String(),
      'confirmed': confirmed ?? false,
      'priority': priority ?? false,
    };
    if (attachment != null || attachment!.isNotEmpty) {
      map['attachment'] = attachment!;
    }
    if (events != null) {
      map['events'] = events!.map((e) => e.toMap()).toList();
    }
    if (id != null) {
      map['_id'] = id!;
    }
    return map;
  }
}

class Event {
  final String location;
  final DateTime dateTime;
  final String description;
  final String? attachment;

  Event({
    required this.location,
    required this.dateTime,
    required this.description,
    this.attachment,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'location': location,
      'dateTime': dateTime.toIso8601String(),
      'description': description,
    };
    if (attachment != null || attachment!.isNotEmpty) {
      map['attachment'] = attachment!;
    }
    return map;
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      location: map['location'],
      dateTime: DateTime.parse(map['dateTime']),
      description: map['description'],
      attachment: map['attachment'],
    );
  }
}
