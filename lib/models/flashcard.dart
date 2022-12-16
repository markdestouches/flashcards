import 'package:uuid/uuid.dart';

const List<Duration> _alertOffsets = [
  Duration(seconds: 5),
  Duration(seconds: 10),
  Duration(seconds: 30),
  Duration(seconds: 60),
  Duration(seconds: 360),
];

class Flashcard {
  final String id;
  final String name;
  final List<String> hidden;
  final String? hint;
  final DateTime created;
  DateTime alertTime;
  int alertOffsetIndex;

  Flashcard({required this.name, required this.hidden, this.hint})
      : id = const Uuid().v1(),
        created = DateTime.now(),
        alertTime = DateTime.now().add(_alertOffsets[0]),
        alertOffsetIndex = 0;
}
